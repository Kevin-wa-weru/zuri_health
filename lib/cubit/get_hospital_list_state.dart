part of 'get_hospital_list_cubit.dart';

@freezed
class GetHospitalListState with _$GetHospitalListState {
  const factory GetHospitalListState.initial() = _Initial;
  const factory GetHospitalListState.loading() = _Loading;
  const factory GetHospitalListState.loaded(List<Hospital> hospitals) = _Loaded;
  const factory GetHospitalListState.error(String errorMessage) = _Error;
}
