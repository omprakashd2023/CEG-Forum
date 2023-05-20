import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fpdart/fpdart.dart';
import 'dart:io';

//Providers
import './firebase_providers.dart';

//Typedefs
import '../type_def.dart';

//Failure Class
import '../failure.dart';

final firebaseStorageProvider = Provider(
  (ref) => StorageRepository(
    firebaseStorage: ref.watch(
      storageProvider,
    ),
  ),
);

class StorageRepository {
  final FirebaseStorage _firebaseStorage;
  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile(
      {required String path, required String id, required File? file}) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(id);
      UploadTask uploadTask = ref.putFile(file!);
      final snapshot = await uploadTask;
      return right(await snapshot.ref.getDownloadURL());
    } catch (err) {
      return left(
        Failure(
          err.toString(),
        ),
      );
    }
  }
}
