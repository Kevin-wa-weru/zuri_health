import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:zuri_health/models/hospital.dart';
import 'package:zuri_health/services/apis.dart';

part 'get_hospital_details_state.dart';
part 'get_hospital_details_cubit.freezed.dart';

class GetHospitalDetailsCubit extends Cubit<GetHospitalDetailsState> {
  GetHospitalDetailsCubit() : super(const GetHospitalDetailsState.initial());
  Future getHospitalDetails({
    required Hospital hospital,
  }) async {
    emit(const GetHospitalDetailsState.loading());

    Map<String, dynamic> response = await ZuriApis().fetchMoreHospitalDetails(
      hospital.placeId,
      hospital.latitude,
      hospital.longitude,
    );

    if (response['message'] == 'ok') {
      emit(GetHospitalDetailsState.loaded(response['hospital']));
    } else {
      emit(GetHospitalDetailsState.error(response['message']));
    }
  }
}
