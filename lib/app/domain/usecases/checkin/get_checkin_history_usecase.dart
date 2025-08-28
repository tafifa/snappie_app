import 'package:dartz/dartz.dart';
import '../../errors/failures.dart';
import '../../entities/checkin_entity.dart';
import '../../repositories/checkin_repository.dart';
import '../base_usecase.dart';

class GetCheckinHistoryUseCase implements UseCase<List<CheckinEntity>, GetCheckinHistoryParams> {
  final CheckinRepository repository;

  GetCheckinHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<CheckinEntity>>> call(GetCheckinHistoryParams params) async {
    return await repository.getCheckinHistory(
      page: params.page,
      perPage: params.perPage,
      status: params.status,
    );
  }
}

class GetCheckinHistoryParams {
  final int page;
  final int perPage;
  final String? status;

  GetCheckinHistoryParams({
    this.page = 1,
    this.perPage = 20,
    this.status,
  });
}
