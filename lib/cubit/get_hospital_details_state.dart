part of 'get_hospital_details_cubit.dart';

@freezed
class GetHospitalDetailsState with _$GetHospitalDetailsState {
  const factory GetHospitalDetailsState.initial() = _Initial;
  const factory GetHospitalDetailsState.loading() = _Loading;
  const factory GetHospitalDetailsState.loaded(Hospital hospital) = _Loaded;
  const factory GetHospitalDetailsState.error(String errorMessage) = _Error;
}
