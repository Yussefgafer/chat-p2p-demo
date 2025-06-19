import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/peer_connection_entity.dart';
import '../repositories/webrtc_repository.dart';

/// Use case for creating a peer connection
class CreatePeerConnectionUseCase {
  final WebRTCRepository repository;

  CreatePeerConnectionUseCase(this.repository);

  Future<Either<Failure, PeerConnectionEntity>> call(
    CreatePeerConnectionParams params,
  ) async {
    return await repository.createPeerConnection(
      peerId: params.peerId,
      peerName: params.peerName,
      connectionType: params.connectionType,
    );
  }
}

/// Parameters for creating a peer connection
class CreatePeerConnectionParams extends Equatable {
  final String peerId;
  final String peerName;
  final ConnectionType connectionType;

  const CreatePeerConnectionParams({
    required this.peerId,
    required this.peerName,
    required this.connectionType,
  });

  @override
  List<Object> get props => [peerId, peerName, connectionType];
}
