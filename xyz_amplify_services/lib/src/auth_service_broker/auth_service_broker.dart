//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Amplify Services
//
// Copyright Ⓒ Robert Mollentze.
//
// This file is proprietary. No external sharing or distribution.
// Refer to README.md and the project's LICENSE file for details.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

// ignore_for_file: invalid_use_of_visible_for_overriding_member
import 'dart:async';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:xyz_service_brokers/xyz_service_brokers.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class AmplifyCognitoAuthServiceBroker extends AuthServiceBroker {
  //
  //
  //

  AmplifyCognitoAuthServiceBroker({
    super.onLogin,
    super.onLogout,
  });

  //
  //
  //

  @override
  void $startExpiryChecker() {
    // super.$expiryChecker = Timer.periodic(
    //   const Duration(minutes: 1),
    //   (final timer) async {
    //     final session = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
    //     if (!session.isSignedIn) {
    //       this.$currentUser = null;
    //       this.onLogout?.call();
    //       Future.delayed(Duration.zero, () => super.$stopExpiryChecker());
    //     }
    //   },
    // );
  }

  //
  //
  //

  @override
  Future<bool> checkPersistency() async {
    final session = await Amplify.Auth.fetchAuthSession() as CognitoAuthSession;
    final loggedIn = session.isSignedIn;
    if (loggedIn) {
      await super.pCurrentUser.set(await _getUserBroker());
    }
    return loggedIn;
  }

  //
  //
  //

  @override
  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final signInResult = await Amplify.Auth.signIn(
      username: email,
      password: password,
    );
    if (signInResult.isSignedIn) {
      await super.pCurrentUser.set(await _getUserBroker());
      this.$startExpiryChecker();
    }
  }

  //
  //
  //

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    final options = SignUpOptions(
      userAttributes: {
        AuthUserAttributeKey.email: email,
      },
    );
    await Amplify.Auth.signUp(
      username: email,
      password: password,
      options: options,
    );
    await this.logInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //
  //
  //

  @override
  Future<void> logOut() async {
    await Amplify.Auth.signOut();
    await super.pCurrentUser.set(null);
    this.onLogout?.call();
  }

  //
  //
  //

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await Amplify.Auth.resetPassword(username: email);
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<UserBroker> _getUserBroker() async {
  final attrributes = await Amplify.Auth.fetchUserAttributes();
  final sub = attrributes.firstWhere((e) => e.userAttributeKey.key == "sub").value;
  final email = attrributes.firstWhere((e) => e.userAttributeKey.key == "email").value;
  return UserBroker(
    uid: sub,
    email: email,
  );
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

Future<void> configureAmplify(
  String amplifyconfig,
  List<AmplifyPluginInterface> plugins,
) async {
  for (final plugin in plugins) {
    Amplify.addPlugin(plugin);
  }
  await Amplify.configure(amplifyconfig);
}
