//.title
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//
// XYZ Firebase Services
//
// Copyright Ⓒ Robert Mollentze.
//
// This file is proprietary. No external sharing or distribution.
// Refer to README.md and the project's LICENSE file for details.
//
// ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
//.title~

import 'package:xyz_service_brokers/xyz_service_brokers.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class FirestoreServiceBroker<TModel>
    extends DatabaseServiceBroker<TModel, DocumentReference<TModel>, CollectionReference<TModel>> {
  //
  //
  //

  final FirebaseFirestore firestore;

  //
  //
  //

  FirestoreServiceBroker(this.firestore);

  //
  //
  //

  @override
  Future<void> setModel(TModel model, DocumentReference<TModel> modelRef) async {
    await modelRef.set(model);
  }

  //
  //
  //

  @override
  Future<void> updateModel(
    Map<String, dynamic> modelData,
    DocumentReference<TModel> modelRef,
  ) async {
    await modelRef.update(modelData);
  }

  //
  //
  //

  @override
  Future<TModel?> get(DocumentReference<TModel> modelRef) async {
    final snapshot = await modelRef.get();
    if (snapshot.exists) {
      return snapshot.data();
    }
    return null;
  }

  //
  //
  //

  @override
  Future<void> deleteModel(DocumentReference<TModel> modelRef) async {
    await modelRef.delete();
  }

  //
  //
  //

  @override
  Future<void> runTransaction(
    Future<void> Function(dynamic) transactionHandler,
  ) async {
    await this.firestore.runTransaction((transaction) async {
      await transactionHandler(transaction);
    });
  }

  //
  //
  //

  @override
  Future<void> batchWrite(
    Iterable<BatchWriteOperation<TModel, DocumentReference<TModel>>> writes,
  ) async {
    final batch = this.firestore.batch();
    for (final write in writes) {
      final modelRef = write.modelRef;
      if (write.data != null) {
        batch.set(modelRef, write.data);
      } else if (write.delete) {
        batch.delete(modelRef);
      }
    }
    await batch.commit();
  }

  //
  //
  //

  @override
  Stream<TModel?> streamModel(
    DocumentReference<TModel> modelRef,
    Future<void> Function(TModel?) onUpdate,
  ) {
    return modelRef.snapshots().asyncMap((snapshot) async {
      final data = snapshot.data();
      await onUpdate(data);
      return data;
    });
  }

  //
  //
  //

  @override
  Stream<Iterable<TModel>> streamCollection(
    CollectionReference<TModel> collectionRef,
    Future<void> Function(Iterable<TModel>) onUpdate,
  ) {
    return collectionRef.snapshots().asyncMap((querySnapshot) async {
      final docs = querySnapshot.docs.map((e) => e.data());
      await onUpdate(docs);
      return docs;
    });
  }
}
