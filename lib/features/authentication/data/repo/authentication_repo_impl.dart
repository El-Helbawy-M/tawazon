import 'package:base/features/authentication/core/entities/UserData.dart';
import 'package:base/features/authentication/core/usecases/create_user_progress.dart';
import 'package:base/features/authentication/core/usecases/create_firestore_user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dartz/dartz.dart';
import '../../../../config/app_errors.dart';
import '../../core/repo/authentication_repo_interface.dart';

class AuthenticationRepoImpl extends AuthenticationRepoInterface {
  //===================================================
  //=================================================== Variables
  //===================================================
  final FirebaseAuth _firebaseAuth;
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
        return Left(
          AuthFailure(
              message:
                  'Please verify your email. A verification email has been sent.',
              code: 'email-not-verified'),
        );
      }

      return Right(credential);
    } on FirebaseAuthException catch (e) {
      return Left(
          AuthFailure(message: e.message ?? 'Auth error', code: e.code));
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
      return Left(
          AuthFailure(message: e.message ?? 'Auth error', code: e.code));
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
      return Left(AuthFailure(
          message: e.message ?? 'Verification error', code: e.code));
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
      return Left(AuthFailure(
          message: e.message ?? 'Password reset error', code: e.code));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> createAccount(
      {required UserCreateAccountParameters user}) async {
    try {
      // Create user document in Firestore using the usecase
      final firestoreResult =
          await CreateFirestoreUser().call(userId: user.id, email: user.email);

      // If Firestore user creation fails, return the failure
      if (firestoreResult.isLeft()) {
        throw firestoreResult;
      }

      // Create user progress
      final progressResult = await CreateUserProgress().call(userId: user.id);

      // If user progress creation fails, return the failure
      if (progressResult.isLeft()) {
        throw progressResult;
      }

      return const Right(true);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(
          message: e.message ?? "Can't create account", code: e.code));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(true);
    } on FirebaseAuthException catch (e) {
      return Left(AuthFailure(
          message: e.message ?? "Something went wrong", code: e.code));
    } catch (e) {
      return Left(AuthFailure(message: e.toString()));
    }
  }
}
