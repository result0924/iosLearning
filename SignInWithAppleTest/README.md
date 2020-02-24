### Refer

* https://fluffy.es/sign-in-with-apple-tutorial-ios/
* https://johncodeos.com/how-to-add-sign-in-with-apple-button-to-your-ios-app-using-swift/


### Note

This behaves correctly(only can get email and name in first apple login), user info is only sent in the ASAuthorizationAppleIDCredential upon initial user sign up. Subsequent logins to your app using Sign In with Apple with the same account do not share any user info and will only return a user identifier in the ASAuthorizationAppleIDCredential.

If you are in the midst of developing your app's login system, it can be annoying to get nil name/email returned, and creating a new Apple ID each time you test the Sign-in with Apple feature is not practical. Even deleting the app and installing again won't make your app able to retrieve back the name and email attributes of user.

Fortunately, we can reset this behaviour by revoking the Apple Sign-In permission in the Settings app.

#### example

- first
```
userID: 001036.8a7d61d1234542a690216127b891b49b.0752
email: 7533967usx@privaterelay.appleid.com
givenName: Kk
familyName: Ting
nickName:can't find nick name
identityToken: identityToken
authorizationCode: authorizationCode
```

-  second
```
userID: 001036.8a7d61d1234542a690216127b891b49b.0752
email: can't find email
givenName: can't find given name
familyName: can't find family name
nickName: can't find nick name
identityToken: identityToken
authorizationCode: authorizationCode
```

- revoke and login again
```
userID: 001036.8a7d61d1234542a690216127b891b49b.0752
email: 7533967usx@privaterelay.appleid.com
givenName: 大明
familyName: 王
nickName:can't find nick name
identityToken: identityToken
authorizationCode: authorizationCode
```