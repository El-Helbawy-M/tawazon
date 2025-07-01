
import 'package:base/config/firestore_tables.dart';
import 'package:base/features/authentication/core/entities/UserData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import '../../../../config/app_errors.dart';
import '../../core/repo/authentication_repo_interface.dart';

class AuthenticationRepoImpl extends AuthenticationRepoInterface {
  //===================================================
  //=================================================== Variables
  //===================================================
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  AuthenticationRepoImpl({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  //===================================================
  //=================================================== Functions
  //===================================================
  @override
  Future<Either<Failure, UserCredential>> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Check if user is verified
      if (credential.user != null && !credential.user!.emailVerified) {
        // Send verification email
        await credential.user!.sendEmailVerification();
        return Left( AuthFailure(
          message: 'Please verify your email. A verification email has been sent.',
          code: 'email-not-verified'
        ),);
      }
      
      return Right(credential);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Auth error', code: e.code));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserCredential>> register({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user!.sendEmailVerification();
      return Right(credential);

    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Auth error', code: e.code));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> verify({required UserCredential user}) async {
    try {
      await user.user?.sendEmailVerification();
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Verification error', code: e.code));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: e.message ?? 'Password reset error', code: e.code));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createAccount({required UserCreateAccountParameters user}) async{
    try {
      await _firestore.collection(FireStoreTables.users).doc(user.id).set({
        'id': user.id,
        'email': user.email,
        'has_completed_profile': false,
      });
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: e.message ?? "Can't create account", code: e.code));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async{
    try {
      await _firebaseAuth.signOut();
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(message: e.message ?? "Something went wrong", code: e.code));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
} 