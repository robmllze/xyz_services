//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Shared
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:xyz_service_brokers/xyz_service_brokers.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class FirebaseAuthServiceBroker extends AuthServiceBroker {
  //
  //
  //

  final FirebaseAuth firebaseAuth;
  Timer? expiryChecker;

  //
  //
  //

  FirebaseAuthServiceBroker({
    required this.firebaseAuth,
    super.onLogin,
    super.onLogout,
  });

  //
  //
  //

  @override
  void $startExpiryChecker() {
    // this.expiryChecker = Timer.periodic(
    //   const Duration(minutes: 1),
    //   (final timer) async {
    //     final currentFirebaseUser = this.firebaseAuth.currentUser;
    //     final idToken = currentFirebaseUser?.getIdToken(true);
    //     if (idToken == null) {
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
    final currentFirebaseUser = this.firebaseAuth.currentUser;
    final loggedIn = currentFirebaseUser != null;
    if (loggedIn) {
      await super.pCurrentUser.set(_firebaseUserToUserBroker(currentFirebaseUser));
      this.$startExpiryChecker();
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
    await this.firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    await super.pCurrentUser.set(_firebaseUserToUserBroker(this.firebaseAuth.currentUser!));
    this.$startExpiryChecker();
  }

  //
  //
  //

  @override
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await this.firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    await super.pCurrentUser.set(_firebaseUserToUserBroker(this.firebaseAuth.currentUser!));
    this.$startExpiryChecker();
  }

  //
  //
  //

  @override
  Future<void> logOut() async {
    this.$stopExpiryChecker();
    await this.firebaseAuth.signOut();
    await super.pCurrentUser.set(null);
  }

  //
  //
  //

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await this.firebaseAuth.sendPasswordResetEmail(email: email);
  }
}

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

UserBroker _firebaseUserToUserBroker(User firebaseAuthUser) {
  return UserBroker(
    uid: firebaseAuthUser.uid,
    email: firebaseAuthUser.email!,
  );
}
