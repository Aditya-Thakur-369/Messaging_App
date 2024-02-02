// ignore_for_file: depend_on_referenced_packages, avoid_print

import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:chat_app/app/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  User? user;

  AuthBloc() : super(AuthInitial()) {
    on<AuthenticatedCheckEvent>(authenticatedCheckEvent);
    on<UpdateUserDataEvent>(updateUserDataEvent);
    on<LoginpagePageNavigateEvent>(loginpagePageNavigateEvent);
    on<RegisterPageNavigateEvent>(registerPageNavigateEvent);
    on<LoginButtonClickedEvent>(loginButtonClickedEvent);
    on<RegisterButtonClickedEvent>(registerButtonClickedEvent);
    on<PickImageFromGalleryEvent>(pickImageFromGalleryEvent);
  }

  FutureOr<void> loginpagePageNavigateEvent(
      LoginpagePageNavigateEvent event, Emitter<AuthState> emit) {
    emit(LoginPageNavigateDoneState());
  }

  FutureOr<void> registerPageNavigateEvent(
      RegisterPageNavigateEvent event, Emitter<AuthState> emit) {
    emit(RegisterPageNavigatedState());
  }

  FutureOr<void> loginButtonClickedEvent(
      LoginButtonClickedEvent event, Emitter<AuthState> emit) async {
    try {
      UserCredential result = await firebaseAuth.signInWithEmailAndPassword(
          email: event.email, password: event.password);
      user = result.user;
      print("logged in success");
      emit(LoggedInSuccessState());
      //navigate to home page
    } catch (e) {
      print("logged in error");
      emit(LoggedInErrorState(error: e.toString()));
      //display an error
    }
  }

  FutureOr<void> registerButtonClickedEvent(
      RegisterButtonClickedEvent event, Emitter<AuthState> emit) async {
    try {
      UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
          email: event.email, password: event.password);

      user = result.user;

      emit(RegisteredSuccessState(uid: user!.uid));
    } catch (e) {
      emit(RegisteredErrorState(message: e.toString()));
    }
  }

  FutureOr<void> pickImageFromGalleryEvent(
      PickImageFromGalleryEvent event, Emitter<AuthState> emit) async {
    final imagePicker = ImagePicker();
    try {
      final pickedFile =
          await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        emit(ImagePickedSuccessState(image: File(pickedFile.path)));
      } else {
        emit(ImagePickedErrorState(error: 'Please select an image.'));
      }
    } catch (e) {
      emit(ImagePickedErrorState(error: 'Error picking image: $e'));
      print(e.toString());
    }
  }

  FutureOr<void> updateUserDataEvent(
      UpdateUserDataEvent event, Emitter<AuthState> emit) async {
    final storageRef = FirebaseStorage.instance.ref();
    try {
      // Upload profile image to Firebase Storage
      String imageUrl =
          await uploadProfileImage(storageRef, event.uid, event.imageUrl);

      // Update user data in Firestore
      await updateUserDataInFirestore(
          event.uid, event.name, event.email, imageUrl);

      emit(UserDataUpdatedState());
    } catch (e) {
      emit(UserDataUpdateErrorState(error: 'Error updating user data: $e'));
    }
  }

  Future<String> uploadProfileImage(
      Reference storageRef, String uid, File image) async {
    TaskSnapshot result =
        await storageRef.child('profile_images').child(uid).putFile(image);

    return await result.ref.getDownloadURL();
  }

  Future<void> updateUserDataInFirestore(
      String uid, String name, String email, String imageUrl) async {
    String usercollection = "Users";
    await db.collection(usercollection).doc(uid).set({
      'name': name,
      'email': email,
      'image': imageUrl,
      'lastSeen': DateTime.now().toUtc(),
      'uid': uid,
    });
  }

  FutureOr<void> authenticatedCheckEvent(
      AuthenticatedCheckEvent event, Emitter<AuthState> emit) async {
    User? currentUser = FirebaseAuth.instance.currentUser;

    try {
      if (currentUser != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('Users')
            .doc(currentUser.uid)
            .get();
        UserModel userModel = UserModel.fromJSON(userData);
        emit(AuthenticatedSuccessState(userModel: userModel));
      }
    } catch (e) {
      emit(AuthenticatedErrorState());
    }
  }
}
