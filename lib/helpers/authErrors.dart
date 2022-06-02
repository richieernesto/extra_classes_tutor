class AuthErrors{
   Map<String, String> detectedErrors = {
    //"An internal error has occurred.":"invalid-auth-event",
    "The password must be 6 characters long or more.": "Password is Weak",
    "There is no user record corresponding to this identifier. The user may have been deleted.":"Email Not Found",
    "The operation has timed out.": "Timeout! Check Your Network Connection",
    "The email address is badly formatted.": "Invalid email",
    "The password is invalid or the user does not have a password.": "Wrong Password" ,
    "The email address is already in use by another account.": "Email Already in Use",
    "An internal error has occurred.": "Internal Error" ,
   };
  }