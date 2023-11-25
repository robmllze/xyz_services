//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Service Brokers
//
// Copyright Ⓒ Robert Mollentze.
//
// This file is proprietary. No external sharing or distribution.
// Refer to README.md and the project's LICENSE file for details.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'dart:async';

import 'package:meta/meta.dart';
import 'package:xyz_pod/xyz_pod.dart';
import 'package:xyz_utils/html.dart';

import 'user_broker.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract class AuthServiceBroker extends PostDestructionChecker {
  //
  //
  //
  @visibleForOverriding
  Timer? $expiryChecker;
  //@visibleForOverriding
  final pCurrentUser = Pod<UserBroker?>(null);
  final void Function(UserBroker)? onLogin;
  final void Function()? onLogout;

  //
  //
  //

  AuthServiceBroker({
    required this.onLogin,
    required this.onLogout,
  });

  //
  //
  //

  @override
  void onPostDestruction() {
    // Ensure pCurrentUser is disposed when this instance destructs.
    this.pCurrentUser.dispose();
  }

  //
  //
  //

  Future<bool> checkPersistency();

  //
  //
  //

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  });

  //
  //
  //

  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  });

  //
  //
  //

  Future<void> logOut();

  //
  //
  //

  Future<void> sendPasswordResetEmail(String email);

  //
  //
  //

  void $startExpiryChecker();

  //
  //
  //

  @visibleForOverriding
  void $stopExpiryChecker() {
    this.$expiryChecker?.cancel();
    this.$expiryChecker = null;
  }
}
