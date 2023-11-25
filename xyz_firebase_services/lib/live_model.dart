// //.title
// // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
// //
// // XYZ Firebase Services
// //
// // Copyright Ⓒ Robert Mollentze.
// //
// // This file is proprietary. No external sharing or distribution.
// // Refer to README.md and the project's LICENSE file for details.
// //
// // ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓
// //.title~

// import 'dart:async' show StreamSubscription;

// import '/all.dart';

// // ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// class LiveModel<T extends Model> extends SingleService {
//   /// The Firestore document path.
//   final FirestoreDocPath<T> path;

//   /// The Firestore document reference.
//   late final DocumentReference<T?> ref = this.path.get({"id": super.creator.id});

//   /// The Pod that stores the current value of the document.
//   late final pModel = Pod<T?>(null);

//   /// A queue of functions that need to be executed in order.
//   final _queue = FunctionQueue();

//   /// The stream subscription that listens for changes to the document.
//   late final StreamSubscription<T?> _stream;

//   LiveModel._({
//     required super.creator,
//     required super.onError,
//     required this.path,
//   });

//   @override
//   Future<void> init() async {
//     try {
//       await this.update();
//     } catch (e) {
//       if (this.onError != null) {
//         this.onError!(e);
//       } else {
//         rethrow;
//       }
//     }
//     // Listen for changes to the Pod and immediately updates the Firestore
//     // document.
//     this.pModel.callbacks.add(this.save);

//     // Listen for changes to the Firestore document and immediately updates the
//     // Pod.
//     this._stream = this.ref.snapshots().asyncMap((final shapshot) async {
//       final model = shapshot.data();
//       await this.pModel.set(model);
//       return model;
//     }).listen(
//       (final data) {},
//       onError: this.onError,
//     );
//   }

//   /// Updates the document/model from Firestore.
//   Future<T?> update() async {
//     final shapshot = await ref.get();
//     final data = shapshot.data();
//     await this.pModel.set(data);
//     return this.pModel.value;
//   }

//   /// Saves the document/model to Firestore.
//   Future<T?> save(_, T? model) async {
//     if (model != null) {
//       await this._queue.add(() {
//         return this.ref.set(model, SetOptions(merge: true));
//       });
//     }
//     return model;
//   }

//   /// Deletes the document/model from Firestore.
//   Future<void> delete() async {
//     await this._queue.add(this.ref.delete);
//   }

//   /// Stops listening for changes to the Firestore document and disposes the
//   /// instance.
//   @override
//   Future<void> dispose() async {
//     await this._stream.cancel();
//     await this.pModel.dispose();
//   }
// }

// // ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// class LiveModelCreator<T extends Model> extends SingleServiceCreator<LiveModel<T>> {
//   //
//   //
//   //

//   final FirestoreDocPath<T> path;

//   //
//   //
//   //

//   LiveModelCreator({
//     required super.id,
//     required super.onError,
//     required this.path,
//   });

//   //
//   //
//   //

//   @override
//   Future<void> createService(_) async {
//     final i = LiveModel<T>._(
//       creator: this,
//       onError: super.onError,
//       path: this.path,
//     );
//     await super.createService(i);
//   }
// }
