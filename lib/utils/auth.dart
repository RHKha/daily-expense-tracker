import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  String errorMessage = '';

//  // Error Codes for SignUp
//
//  ERROR_OPERATION_NOT_ALLOWED` - Indicates that Anonymous accounts are not enabled.
//  ERROR_WEAK_PASSWORD - If the password is not strong enough.
//  ERROR_INVALID_EMAIL` - If the email address is malformed.
//  ERROR_EMAIL_ALREADY_IN_USE - If the email is already in use by a different account.
//  ERROR_INVALID_CREDENTIAL` - If the [email] address is malformed.
//
//  // sending password reset email
//  ERROR_INVALID_EMAIL` - If the [email] address is malformed.
//  ERROR_USER_NOT_FOUND` - If there is no user corresponding to the given [email] address.
//
//// errors when signing in from email using a link
//
//  ERROR_NOT_ALLOWED - Indicates that email and email sign-in link accounts are not enabled. Enable them in the Auth section of the Firebase console.
//  ERROR_DISABLED - Indicates the users account is disabled.
//  ERROR_INVALID - Indicates the email address is invalid.
//
//
//// errors when signing in using email and password
//
//  ERROR_INVALID_EMAIL` - If the [email] address is malformed.
//  ERROR_WRONG_PASSWORD` - If the [password] is wrong.
//  ERROR_USER_NOT_FOUND` - If there is no user corresponding to the given [email] address, or if the user has been deleted.
//  ERROR_USER_DISABLED` - If the user has been disabled (for example, in the Firebase console)
//  ERROR_TOO_MANY_REQUESTS` - If there was too many attempts to sign in as this user.
//  ERROR_OPERATION_NOT_ALLOWED` - Indicates that Email & Password accounts are not enabled.
//
//
//// errors when signing in using credentials
//
//  ERROR_INVALID_CREDENTIAL` - If the credential data is malformed or has expired.
//  ERROR_USER_DISABLED` - If the user has been disabled (for example, in the Firebase console)
//  ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL - If there already exists an account with the email address asserted by Google.
//  /// Resolve this case by calling [fetchSignInMethodsForEmail] and then asking the user to sign in using one of them.
//  ///       This error will only be thrown if the "One account per email address" setting is enabled in the Firebase console (recommended).
//  ERROR_OPERATION_NOT_ALLOWED` - Indicates that Google accounts are not enabled.
//  ERROR_INVALID_ACTION_CODE` - If the action code in the link is malformed, expired, or has already been used.
//
//
//// error code when signing in with custom token
//
//  ERROR_INVALID_CUSTOM_TOKEN` - The custom token format is incorrect. Please check the documentation.
//  ERROR_CUSTOM_TOKEN_MISMATCH` - Invalid configuration. Ensure your apps SHA1 is correct in the Firebase console.
//
//// errors while confirming password reset
//
//  EXPIRED_ACTION_CODE` - if the password reset code has expired.
//  INVALID_ACTION_CODE` - if the password reset code is invalid. This can happen if the code is malformed or has already been used.
//  USER_DISABLED` - if the user corresponding to the given password reset code has been disabled.
//  USER_NOT_FOUND` - if there is no user corresponding to the password reset code. This may have happened if the user was deleted between when the code was issued and when this method was called.
//  WEAK_PASSWORD` - if the new password is not strong enough.
//
//
//  // errors when verification codes is invalid
//
//  ERROR_INVALID_VERIFICATION_CODE - if the code is invalid

//example for catching sign in exceptions

  Future<String> signIn(String email, String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    FirebaseUser user;
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
//      name = user.displayName;
      email = user.email;
//      userId = user.uid;
    } catch (error) {
      switch (error.code) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }

    return user.uid;
  }

  /// example for catching sign up exceptions

  Future<String> signUp(String email, String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    FirebaseUser user;

    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      user = result.user;
//      name = user.displayName;
      email = user.email;

//      Firestore.instance.collection('users').document(user.uid).setData({
//        "uid": user.uid,
//        "firstName": firstName,
//        "email": email,
//        "userImage": userImage,
//      });
    } catch (error) {
      switch (error.code) {
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Anonymous accounts are not enabled";
          break;
        case "ERROR_WEAK_PASSWORD":
          errorMessage = "Your password is too weak";
          break;
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email is invalid";
          break;
        case "ERROR_EMAIL_ALREADY_IN_USE":
          errorMessage = "Email is already in use on different account";
          break;
        case "ERROR_INVALID_CREDENTIAL":
          errorMessage = "Your email is invalid";
          break;

        default:
          errorMessage = "An undefined Error happened.";
      }
    }
    if (errorMessage != null) {
      return Future.error(errorMessage);
    }

    return user.uid;
  }
}
