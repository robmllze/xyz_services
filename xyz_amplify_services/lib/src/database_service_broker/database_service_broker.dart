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

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

class DynamoDBServiceBroker<TModel> extends DatabaseServiceBroker {
  @override
  Future<void> batchWrite(Iterable<BatchWriteOperation> writes) {
    // TODO: implement batchWrite
    throw UnimplementedError();
  }

  @override
  Future<void> deleteModel(modelRef) {
    // TODO: implement deleteModel
    throw UnimplementedError();
  }

  @override
  Future get(modelRef) {
    // TODO: implement get
    throw UnimplementedError();
  }

  @override
  Future<void> runTransaction(Future<void> Function(dynamic p1) transactionHandler) {
    // TODO: implement runTransaction
    throw UnimplementedError();
  }

  @override
  Future<void> setModel(model, modelRef) {
    // TODO: implement setModel
    throw UnimplementedError();
  }

  @override
  Stream<Iterable> streamCollection(collectionRef, Future<void> Function(Iterable p1) onUpdate) {
    // TODO: implement streamCollection
    throw UnimplementedError();
  }

  @override
  Stream streamModel(modelRef, Future<void> Function(dynamic p1) onUpdate) {
    // TODO: implement streamModel
    throw UnimplementedError();
  }

  @override
  Future<void> updateModel(Map<String, dynamic> modelData, modelRef) {
    // TODO: implement updateModel
    throw UnimplementedError();
  }
}
