import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/models/user_model.dart';
import '../repositories/user_repository.dart';

/// Use case for creating a new user profile
class CreateUserUseCase {
  final UserRepository repository;

  CreateUserUseCase(this.repository);

  Future<Either<Failure, UserModel>> call(CreateUserParams params) async {
    return await repository.createUser(
      name: params.name,
      avatar: params.avatar,
      age: params.age,
      phoneNumber: params.phoneNumber,
    );
  }
}

/// Parameters for creating a user
class CreateUserParams extends Equatable {
  final String name;
  final String? avatar;
  final int? age;
  final String? phoneNumber;

  const CreateUserParams({
    required this.name,
    this.avatar,
    this.age,
    this.phoneNumber,
  });

  @override
  List<Object?> get props => [name, avatar, age, phoneNumber];
}
