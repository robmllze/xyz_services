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

// import 'dart:async';

// // ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// class LiveCollection<T> extends SingleService {
//   /// The Firestore collection reference.
//   final FirestoreCollectionPath<T> path;

//   /// The Firestore collection reference.
//   late final CollectionReference<T?> ref = this.path.get();

//   /// The stream subscription that listens for changes to the collection.
//   StreamSubscription<QuerySnapshot<T?>>? _stream;

//   /// The Pod map that stores the current values of the documents in the collection.
//   final pPods = PodMap<String, T>({});

//   /// Called when a document is added to the collection.
//   final void Function(String id, T data)? onAdded;

//   /// Called when a document in the collection is changed.
//   final void Function(String id, T data)? onChanged;

//   /// Called when a document is removed from the collection.
//   final void Function(String id)? onRemoved;

//   int? _docLimit;
//   int? get docLimit => this._docLimit;

//   LiveCollection._({
//     required super.creator,
//     required super.onError,
//     required this.path,
//     int? docLimit,
//     this.onAdded,
//     this.onChanged,
//     this.onRemoved,
//   }) {
//     this._docLimit = docLimit;
//   }

//   @override
//   Future<void> init() async {
//     await this.restart(docLimit: this._docLimit);
//   }

//   /// Returns the Pod for the document with the given [id].
//   Pod<T>? pDoc(String id) => this.pPods.getPod(id);

//   /// Returns a Pod for total number of documents in the collection.
//   Pod<int> get pLength => this.pPods.pLength;

//   /// Adds a new document to the collection.
//   Future<void> addDoc(T value) {
//     return this.ref.add(value);
//   }

//   /// Sets a document in the collection with the given [id] to the given [value].
//   Future<void> setDoc(String id, T value, {SetOptions? options}) {
//     return this.ref.doc(id).set(value, options ?? SetOptions(merge: true));
//   }

//   /// Removes the document with the given [id] from the collection.
//   Future<void> removeDoc(String id) {
//     return this.ref.doc(id).delete();
//   }

//   /// Restarts listening for changes to the collection.
//   Future<void> restart({required int? docLimit}) async {
//     await this.stop();
//     this._docLimit = docLimit;
//     final shapshots = (this._docLimit == null ? ref : ref.limit(this._docLimit!)).snapshots();
//     this._stream = shapshots.listen(
//       (final snapshot) {
//         final docChanges = snapshot.docChanges;
//         for (final change in docChanges) {
//           final index = change.newIndex;
//           final id = change.doc.id;
//           if (index == -1) {
//             this.pPods.removePod(id).then((final removed) {
//               if (removed) this.onRemoved?.call(id);
//             });
//             continue;
//           }
//           final doc = change.doc;
//           final data = doc.data();
//           if (data != null) {
//             final pod = this.pPods.getPod(id);
//             if (pod == null) {
//               this.pPods.addPod(id, Pod<T>(data)).then((final added) {
//                 if (added) this.onAdded?.call(id, data);
//               });
//             } else {
//               this.pPods.setPod(id, data).then((_) {
//                 this.onChanged?.call(id, data);
//               });
//             }
//           }
//         }
//       },
//       onError: this.onError,
//     );
//   }

//   /// Stops listening for changes to the Firestore collection.
//   /// Call [restart] to start listening again.
//   Future<void> stop() async {
//     await this._stream?.cancel();
//     this._stream = null;
//   }

//   /// Stops listening for changes to the Firestore document and disposes the
//   /// instance. This means that [restart] can no longer be called and the
//   /// instance is no longer usable.
//   @override
//   Future<void> dispose() async {
//     await this.stop();
//     await this.pPods.dispose();
//   }
// }

// // ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

// class LiveCollectionCreator<T> extends SingleServiceCreator<LiveCollection<T>> {
//   //
//   //
//   //

//   final FirestoreCollectionPath<T> path;
//   final void Function(String, T)? onAdded;
//   final void Function(String, T)? onChanged;
//   final void Function(String)? onRemoved;
//   final int? docLimit;

//   //
//   //
//   //

//   LiveCollectionCreator({
//     required super.onError,
//     required this.path,
//     this.docLimit = 100,
//     this.onAdded,
//     this.onChanged,
//     this.onRemoved,
//   });

//   //
//   //
//   //

//   @override
//   Future<void> createService(_) async {
//     final i = LiveCollection<T>._(
//       creator: this,
//       onError: super.onError,
//       path: this.path,
//       docLimit: this.docLimit,
//       onAdded: this.onAdded,
//       onChanged: this.onChanged,
//       onRemoved: this.onRemoved,
//     );
//     await super.createService(i);
//   }
// }
