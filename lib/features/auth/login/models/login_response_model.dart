import 'user_model.dart';

class LoginResponseModel {
  final String accessToken;
  final UserModel user;

  const LoginResponseModel({
    required this.accessToken,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final usersJson = json['user'];

    if (usersJson is! Map<String, dynamic>) {
      throw const FormatException(
        'لم يتم العثور على بيانات المستخدم في الاستجابة',
      );
    }

    return LoginResponseModel(
      accessToken: json['access_token']?.toString() ?? '',
      user: UserModel.fromJson(usersJson),
    );
  }
}