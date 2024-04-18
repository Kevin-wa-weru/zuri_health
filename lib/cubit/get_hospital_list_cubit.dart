import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zuri_health/models/hospital.dart';
import 'package:zuri_health/services/apis.dart';

part 'get_hospital_list_state.dart';
part 'get_hospital_list_cubit.freezed.dart';

class GetHospitalListCubit extends Cubit<GetHospitalListState> {
  GetHospitalListCubit() : super(const GetHospitalListState.initial());

  Future getNearbyHospitals({
    required int radius,
    required double latitude,
    required double longitude,
  }) async {
    emit(const GetHospitalListState.loading());

    Map<String, dynamic> response = await ZuriApis().fetchNearbyHospitals(
        latitude: latitude, longitude: longitude, radius: radius);

    if (response['message'] == 'ok') {
      emit(GetHospitalListState.loaded(response['hospitals']));
    } else {
      emit(GetHospitalListState.error(response['message']));
    }
  }

  Future filterHospitals({
    required int radius,
    required double latitude,
    required double longitude,
    required String serviceFilter,
  }) async {
    emit(const GetHospitalListState.loading());

    Map<String, dynamic> response = await ZuriApis().filterService(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        serviceFilter: serviceFilter);

    if (response['message'] == 'ok') {
      emit(GetHospitalListState.loaded(response['hospitals']));
    } else {
      emit(GetHospitalListState.error(response['message']));
    }
  }
}
