class UserProfileModel {
  String name;
  String aboutMeText;
  // String imageUrl;

  UserProfileModel({
    required this.name,
    required this.aboutMeText,
    //   required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'aboutMeText': aboutMeText,
      // 'imageUrl': imageUrl,
    };
  }

  UserProfileModel.fromMap(Map<String, dynamic> map)
      : assert(map['name'] != null),
        name = map['name'],
        aboutMeText = map['aboutMeText'];
  // imageUrl = map['imageUrl'];
}
