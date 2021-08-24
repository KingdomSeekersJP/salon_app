import 'package:creator/models/user_profile_model.dart';
import 'package:creator/models/user_setting_model.dart';

class UserModel {
  final String email;
  final RoleType role;
  final UserSettings settings;
  final DateTime created;
  final UserProfileModel profile;
  // List<String> salons;

  UserModel({
    required this.email,
    required this.role,
    required this.settings,
    required this.created,
    required this.profile,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'rold': role.index,
      'setting': settings.toMap(),
      'created': created,
      'profile': profile.toMap(),
      // 'salons': List.castFrom(salons),
    };
  }

  bool isCreator() {
    return (role == RoleType.creator);
  }

  // Cast occurs error
  UserModel.fromMap(Map<String, dynamic> map)
      : email = map['email'],
        role = RoleType.values[map['role']],
        settings = UserSettings.fromMap(map['setting'].cast<String, dynamic>()),
        created = map['created'].toDate(),
        profile =
            UserProfileModel.fromMap(map['profile'].cast<String, dynamic>());
  // salons = map['salons'].cast<String>() as List<String>;
}

enum RoleType {
  member, // 0
  creator, // 1
}
