import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/webrtc_repository.dart';

/// Use case for sending WebRTC offer
class SendOfferUseCase {
  final WebRTCRepository repository;

  SendOfferUseCase(this.repository);

  Future<Either<Failure, String>> call(SendOfferParams params) async {
    return await repository.createOffer(params.connectionId);
  }
}

/// Parameters for sending offer
class SendOfferParams extends Equatable {
  final String connectionId;

  const SendOfferParams({required this.connectionId});

  @override
  List<Object> get props => [connectionId];
}
