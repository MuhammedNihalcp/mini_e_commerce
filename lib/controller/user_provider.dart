import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../model/user_model/user_model.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  UserModel? _user;
  UserModel? get user => _user;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  /// Load current user from Firestore
  Future<void> loadUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        _user = null;
        _isLoading = false;
        notifyListeners();
        return;
      }

      final doc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (!doc.exists) {
        _user = UserModel(
          id: currentUser.uid,
          name: currentUser.displayName,
          email: currentUser.email,
        );
        await _firestore
            .collection('users')
            .doc(currentUser.uid)
            .set(_user!.toJson());
      } else {
        _user = UserModel.fromJson({'id': doc.id, ...doc.data()!});
      }
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Update name or email
  Future<void> updateProfile({String? name, String? email}) async {
    if (_user == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      _user = _user!.copyWith(
        name: name ?? _user!.name,
        email: email ?? _user!.email,
      );

      await _firestore
          .collection('users')
          .doc(_user!.id)
          .update(_user!.toJson());
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> requestImagePermissions() async {
    final statuses = await [
      Permission.camera,
      Permission.photos, // gallery access
      Permission.storage, // optional for older Android
    ].request();

    return statuses.values.every((status) => status.isGranted);
  }

  /// Update profile picture with cropping
  Future<void> updateProfilePicture() async {
    if (await requestImagePermissions()) {
      await updateProfilePicture();
    } else {
      _error = "Permission denied";
      notifyListeners();
    }
    if (_user == null || _isLoading) return; // prevent multiple calls

    final picker = ImagePicker();
    XFile? pickedImage;

    try {
      pickedImage = await picker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      _error = "Failed to pick image: $e";
      notifyListeners();
      return;
    }

    if (pickedImage == null) return; // user cancelled

    // Crop the image
    // CroppedFile? croppedImage;
    // try {
    //   croppedImage = await ImageCropper().cropImage(
    //     sourcePath: pickedImage.path,
    //     aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1), // square crop
    //     compressQuality: 80, // optional: compress quality
    //     uiSettings: [
    //       AndroidUiSettings(
    //         toolbarTitle: 'Crop Image',
    //         toolbarColor: Colors.blue,
    //         toolbarWidgetColor: Colors.white,
    //         initAspectRatio: CropAspectRatioPreset.square,
    //         lockAspectRatio: true,
    //       ),
    //       IOSUiSettings(title: 'Crop Image', aspectRatioLockEnabled: true),
    //     ],
    //   );
    // } catch (e) {
    //   _error = "Failed to crop image: $e";
    //   notifyListeners();
    //   return;
    // }

    // if (croppedImage == null) return; // user cancelled crop

    // _isLoading = true;
    // notifyListeners();

    try {
      final file = File(pickedImage.path);
      final ref = _storage.ref().child('profile_pictures/${_user!.id}');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();

      // Update local user object
      _user = _user!.copyWith(imageUrl: url);

      // Update Firestore
      await _firestore.collection('users').doc(_user!.id).update({
        'imageUrl': url,
      });
    } catch (e) {
      _error = "Failed to update profile picture: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
