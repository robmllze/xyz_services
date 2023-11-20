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

import 'batch_write_operation.dart';

// ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

abstract class DatabaseServiceBroker<TModel, TModelRef, TModelCollectionRef> {
  //
  //
  //

  /// Sets a model in the database.
  ///
  /// [model] is the model data to be set.
  /// [modelRef] is a reference to the model.
  Future<void> setModel(
    TModel model,
    TModelRef modelRef,
  );

  //
  //
  //

  /// Updates a model in the database.
  ///
  /// [modelData] is the updated model data.
  /// [modelRef] is a reference to the model to be updated.
  Future<void> updateModel(
    Map<String, dynamic> modelData,
    TModelRef modelRef,
  );

  //
  //
  //

  /// Retrieves a model from the database.
  ///
  /// [TModel] is the type of the model.
  /// [modelRef] is a reference to the model to be retrieved.
  Future<TModel?> get(
    TModelRef modelRef,
  );

  //
  //
  //

  /// Deletes a model from the database.
  ///
  /// [modelRef] is a reference to the model to be deleted.
  Future<void> deleteModel(
    TModelRef modelRef,
  );

  //
  //
  //

  /// Initiates a transaction in the database.
  ///
  /// [transactionHandler] is a function that contains the transaction logic.
  /// It should return a future with the result of the transaction.
  Future<void> runTransaction(
    Future<void> Function(dynamic) transactionHandler,
  );

  //
  //
  //

  /// Performs a batch write operation in the database.
  ///
  /// [writes] is a list of write operations to be executed in a batch.
  Future<void> batchWrite(
    Iterable<BatchWriteOperation<TModel, TModelRef>> writes,
  );

  //
  //
  //

  /// Streams a single document from the database.
  ///
  /// [modelRef] is a reference to the document to be streamed.
  /// [onUpdate] is a callback function to be invoked when the model changes.
  Stream<TModel?> streamModel(
    TModelRef modelRef,
    Future<void> Function(TModel?) onUpdate,
  );

  //
  //
  //

  /// Streams a collection of documents from the database.
  ///
  /// [collectionRef] is a reference to the collection to be streamed.
  /// [onUpdate] is a callback function to be invoked when the collection changes.
  Stream<Iterable<TModel>> streamCollection(
    TModelCollectionRef collectionRef,
    Future<void> Function(Iterable<TModel>) onUpdate,
  );
}
