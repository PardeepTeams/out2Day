window.initWebAutocomplete = function(inputId, onPlaceChanged) {
  const input = document.getElementById(inputId);
  if (!input) return;

  const autocomplete = new google.maps.places.Autocomplete(input);

  autocomplete.addListener('place_changed', () => {
    const place = autocomplete.getPlace();
    onPlaceChanged(place);
  });
};
