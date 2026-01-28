class DynamicPageModel {
  int? id;
  String? title;
  String? image;
  String? pageUrl;

  DynamicPageModel({this.id, this.title, this.image, this.pageUrl});

  DynamicPageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    image = json['image'];
    pageUrl = json['page_url'];
  }
}