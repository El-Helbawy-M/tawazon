import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/error/failures.dart';
import '../entities/UserData.dart';

abstract class AuthenticationRepoInterface {
  Future<Either<Failure, UserCredential>> login({required String email, required String password});

  Future<Either<Failure, UserCredential>> register({required String email, required String password});

  Future<Either<Failure, bool>> verify({required UserCredential user});

  Future<Either<Failure, bool>> resetPassword({required String email});

  Future<Either<Failure, bool>> createAccount({required UserCreateAccountParameters user});

  Future<Either<Failure, bool>> logout();
}
