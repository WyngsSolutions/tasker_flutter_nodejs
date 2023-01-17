import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:twitter_login/twitter_login.dart';
import '../models/app_user.dart';
import '../screens/navigation_view/navigation_view.dart';
import '../utils/constants.dart';
import 'app_controller.dart';

class SocialLoginController{

  Future<void> googleSignIn() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential = await auth.signInWithCredential(credential);
        googleSignIn.signOut();

        EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
        dynamic result =  await AppController().signInSocialUser(userCredential.user!.uid, googleSignInAccount.displayName!,googleSignInAccount.email, googleSignInAccount.photoUrl);
        EasyLoading.dismiss();
        if(result['Status'] == 'Success'){
          await Constants.appUser.saveUserDetails();
        Get.offAll(const NavigationView(defaultPage: 0,));
        }
        else{
          Constants.showDialog(result['ErrorMessage']);
        }
      } 
      on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        }
        else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }
  }

  Future signInWithFacebook() async {
    try{
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile',],
        loginBehavior: LoginBehavior.webOnly
      );

      if (loginResult.status == LoginStatus.success) {
        // you are logged
        EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
        final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
        final userData = await FacebookAuth.instance.getUserData();
        dynamic result =  await AppController().signInSocialUser(userCredential.user!.uid, userData['name'],userData['email'], '');
        EasyLoading.dismiss();
        if(result['Status'] == 'Success'){
          await Constants.appUser.saveUserDetails();
          Get.offAll(const NavigationView(defaultPage: 0,));
        }
        else{
          Constants.showDialog(result['ErrorMessage']);
        }
      } 
      else
      {
        print(loginResult.status);
        print(loginResult.message);
      }
    }
    catch(e)
    {
      Constants.showDialog('Cannot login to facebook at this time');
    }
  }  

  Future<void> signInApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    print(credential);
    print(credential.email);
    print(credential.givenName);
    print(credential.userIdentifier);
    EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
    AppUser appleUserExists = await AppUser.checkIfAppleUserIdExists(credential.userIdentifier!);
    dynamic result = {};
    if(appleUserExists.email.isEmpty)//not exists
    {
      result = await AppController().signUpAppleUser(credential.givenName!, credential.userIdentifier!, credential.email!, '12345678');
    }
    else
    {
      result = <dynamic, dynamic>{}; //empty map
      result['Status'] = "Success";
      Constants.appUser = appleUserExists;
    }

    EasyLoading.dismiss();
    if(result['Status'] == 'Success'){
      await Constants.appUser.saveUserDetails();
      Get.offAll(const NavigationView(defaultPage: 0,));
    }
    else{
      Constants.showDialog(result['ErrorMessage']);
    }
  }

  Future<void> signInTwitter() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    UserCredential userCredential;

  final twitterLogin = TwitterLogin(  
    apiKey: '4aI9TfYL165AvcSLXpwOsMyiS',
    apiSecretKey: 'ImXCWj54zxf3Xl4VpHCtSnXgDGLM0tvXip3toE7noj9e5ckjhZ',
    redirectURI: 'taskapp://',
  );
  final authResult = await twitterLogin.login();
  switch (authResult.status!) {
    case TwitterLoginStatus.loggedIn:
      // success
      try {
        final AuthCredential twitterAuthCredential = TwitterAuthProvider.credential(accessToken: authResult.authToken!,secret: authResult.authTokenSecret!);
        userCredential = await auth.signInWithCredential(twitterAuthCredential);
        EasyLoading.show(status: 'Please wait', maskType: EasyLoadingMaskType.black);
        dynamic result =  await AppController().signInSocialUser(userCredential.user!.uid, userCredential.user!.displayName!,userCredential.user!.email!, userCredential.user!.photoURL);
        EasyLoading.dismiss();
        if(result['Status'] == 'Success'){
          await Constants.appUser.saveUserDetails();
          Get.offAll(const NavigationView(defaultPage: 0,));
        }
        else{
          Constants.showDialog(result['ErrorMessage']);
        }
      } 
      on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
          Constants.showDialog('Account already exists with this email address');
        }
        else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      }
      catch (e) {
        // handle the error here
        print(e.toString());
      }
      break;
    case TwitterLoginStatus.cancelledByUser:
      // cancel
      break;
    case TwitterLoginStatus.error:
      // error
      break;
    }
    // } catch (e) {
    //   // handle the error here
    // }
  }
}