class ProductDataModel {
  int? id;
  String? title;
  String? artist;
  String? imagesource;
  String? audiosource;

  ProductDataModel(
    this.id,
    this.title,
    this.artist,
    this.imagesource,
    this.audiosource,
  );

  ProductDataModel.fromJson(Map<String, dynamic> json)
  {
  id = json['id'];
  title = json['title'];
  artist = json['artist'];
  imagesource = json['imagesource'];
  audiosource = json['audiosource'];
  }
}
