// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:http/http.dart';
// import 'package:simple_auth/simple_auth.dart' as simpleAuth;
// import 'package:simple_auth_flutter/simple_auth_flutter.dart';

// class InstaController{

//   static const igClientId = "3175956809385721";
//   static const igClientSecret = "dc7aeae04dac91e04a7c46b2458a89f7";
//   static const igRedirectURL = "https://wyngslogistics.com/";

//   late String _errorMsg;
//   late Map _userData;

//   final simpleAuth.InstagramApi _igApi = simpleAuth.InstagramApi(
//     "instagram",
//     igClientId,
//     igClientSecret,
//     igRedirectURL,
//     scopes: [
//       'user_profile', // For getting username, account type, etc.
//       'user_media', // For accessing media count & data like posts, videos etc.
//     ],
//   );

//   Future<void> loginAndGetData() async {
//     _igApi.authenticate().then(
//       (_user) async {
//         print(_user!.userData);
//         simpleAuth.OAuthAccount user = _user as simpleAuth.OAuthAccount;

//         var igUserResponse =
//             await Dio(BaseOptions(baseUrl: 'https://graph.instagram.com')).get(
//           '/me',
//           queryParameters: {
//             "fields": "username,id,account_type,media_count",
//             "access_token": user.token,
//           },
//         );

//         _userData = igUserResponse.data;
//       },
//     ).catchError(
//       (Object e) {
//         _errorMsg = e.toString();
//       },
//     );
//   }

// }
