import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/discovery_data_entity.dart';
import '../repositories/peer_discovery_repository.dart';

/// Use case for starting LAN discovery
class StartLANDiscoveryUseCase {
  final PeerDiscoveryRepository repository;

  StartLANDiscoveryUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.startLANDiscovery();
  }
}

/// Use case for watching LAN peers
class WatchLANPeersUseCase {
  final PeerDiscoveryRepository repository;

  WatchLANPeersUseCase(this.repository);

  Stream<DiscoveryDataEntity> call() {
    return repository.watchLANPeers();
  }
}
