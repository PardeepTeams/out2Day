import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:js' as js; // ✅ JS import sirf web file mein
import '../utils/colors.dart';

class GoogleWebAutocomplete extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final Function(String description, String placeId)? onSelected;

  const GoogleWebAutocomplete({required this.controller,required this.hint, this.onSelected});

  @override
  _GoogleWebAutocompleteState createState() => _GoogleWebAutocompleteState();
}

class _GoogleWebAutocompleteState extends State<GoogleWebAutocomplete> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<dynamic> _predictions = [];
  Timer? _debounce;

  void _getSuggestions(String input) {
    if (input.isEmpty) {
      _hideOverlay();
      return;
    }

    final service = js.JsObject(js.context['google']['maps']['places']['AutocompleteService']);
    final request = js.JsObject.jsify({'input': input});

    service.callMethod('getPlacePredictions', [
      request,
          (predictions, status) {
        if (status == 'OK' && predictions != null) {
          setState(() => _predictions = predictions);
          _showOverlay();
        } else {
          _hideOverlay();
        }
      }
    ]);
  }

  void _showOverlay() {
    _hideOverlay();
    final overlay = Overlay.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: _layerLink.leaderSize?.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(0, _layerLink.leaderSize!.height + 5),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: _predictions.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_predictions[index]['description']),
                  onTap: () {
                    final predictionJs = _predictions[index]; // Yeh JsObject hai
                    final desc = predictionJs['description'];
                    final pId = predictionJs['place_id'];

                    // ✅ JsObject se Prediction model create karna


                    //widget.controller.text = desc;

                    if (widget.onSelected != null) {
                      widget.onSelected!(desc, pId);
                    }

                    _hideOverlay();
                    FocusScope.of(context).unfocus();
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
    overlay.insert(_overlayEntry!);
  }

  void _hideOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        controller: widget.controller,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: MyColors.black,
          fontFamily: "regular",
        ),
        decoration: InputDecoration(
          counterText: "",
          hintText: widget.hint,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          filled: true,
          fillColor: MyColors.white,
          contentPadding: const EdgeInsets.only(
              left: 16,
              right: 45, // 👈 Eh padding text nu icon ton pehle rok devegi
              top: 16,
              bottom: 16
          ),

          // ✅ Border Styling (CommonTextField ton copy kiti)
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: MyColors.borderColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: MyColors.borderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: MyColors.borderColor, width: 1),
          ),
          suffixIcon: widget.controller.text.isNotEmpty
              ?Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: () {
                widget.controller.clear();
                _hideOverlay();
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: MyColors.greyFilled2.withOpacity(0.8),
                  border: Border.all(color: MyColors.borderColor, width: 1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 14, color: MyColors.black),
              ),
            ),
          ) : null,
        ),
        onChanged: (value) {
          if (_debounce?.isActive ?? false) _debounce!.cancel();
          _debounce = Timer(Duration(milliseconds: 500), () => _getSuggestions(value));
        },
      ),
    );
  }

  @override
  void dispose() {
    _hideOverlay();
    _debounce?.cancel();
    super.dispose();
  }
}