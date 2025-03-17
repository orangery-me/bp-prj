import 'dart:async';
import 'package:blood_pressure/data/repositories/measurement_repository.dart';
import 'package:blood_pressure/data/models/measurement.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'measurement_event.dart';
part 'measurement_state.dart';

class MeasurementBloc extends Bloc<MeasurementEvent, MeasurementState> {
  final MeasurementRepository _measurementRepository;

  MeasurementBloc(this._measurementRepository)
      : super(const MeasurementState()) {
    on<PostMeasurement>(_postNewMeasurement);
    on<GetAllMeasurements>(_getAllMeasurements);
    on<GetLatestMeasurement>(_getLatestMeasurement);
    on<GetMeasurementsInRange>(_getMeasurementsInRange);
    on<GetAverageByDayInRange>(_getAverageByDayInRange);
    on<DeleteMeasurement>(_deleteMeasurement);
    on<UpdateMeasurement>(_updateMeasurement);
  }

  Future<void> _postNewMeasurement(
      PostMeasurement event, Emitter<MeasurementState> emit) async {
    emit(state.copyWith(status: MeasurementStatus.loading));

    try {
      Measurement newMeasurement =
          await _measurementRepository.addMeasurement(event.measurement);

      emit(state.copyWith(
          measurements: [newMeasurement, ...state.measurements],
          status: MeasurementStatus.success));
    } catch (e) {
      emit(state.copyWith(status: MeasurementStatus.error));
    }
  }

  Future<void> _getAllMeasurements(
      GetAllMeasurements event, Emitter<MeasurementState> emit) async {
    emit(state.copyWith(status: MeasurementStatus.loading));

    try {
      final List<Measurement> measurements =
          await _measurementRepository.getAllMeasurements(event.profileId);

      emit(state.copyWith(
          measurements: measurements, status: MeasurementStatus.success));
    } catch (e) {
      emit(state.copyWith(status: MeasurementStatus.error));
    }
  }

  Future<void> _getLatestMeasurement(
      GetLatestMeasurement event, Emitter<MeasurementState> emit) async {
    emit(state.copyWith(status: MeasurementStatus.loading));

    try {
      final List<Measurement> latestMeasurement = await _measurementRepository
          .getTheLastestMeasurement(event.profileId);

      emit(state.copyWith(
          latestMeasurement: latestMeasurement,
          status: MeasurementStatus.success));
    } catch (e) {
      emit(state.copyWith(status: MeasurementStatus.error));
    }
  }

  Future<void> _getMeasurementsInRange(
      GetMeasurementsInRange event, Emitter<MeasurementState> emit) async {
    emit(state.copyWith(status: MeasurementStatus.loading));

    try {
      final List<Measurement> measurements =
          await _measurementRepository.getMeasurementsInRange(
              event.profileId, event.startDate, event.endDate);

      emit(state.copyWith(
          measurementsInRange: measurements,
          status: MeasurementStatus.success));
    } catch (e) {
      emit(state.copyWith(status: MeasurementStatus.error));
    }
  }

  Future<void> _getAverageByDayInRange(
      GetAverageByDayInRange event, Emitter<MeasurementState> emit) async {
    try {
      final List<Measurement> measurements =
          await _measurementRepository.getAverageByDayInRange(
              event.profileId, event.startDate, event.endDate);

      emit(state.copyWith(
          averageByDayInRange: measurements,
          status: MeasurementStatus.success));
    } catch (e) {
      emit(state.copyWith(status: MeasurementStatus.error));
    }
  }

  Future<void> _deleteMeasurement(
      DeleteMeasurement event, Emitter<MeasurementState> emit) async {
    emit(state.copyWith(status: MeasurementStatus.loading));

    try {
      // Measurement deletedMeasurement =
      await _measurementRepository.deleteMeasurement(event.id);
      // add(GetLatestMeasurement(deletedMeasurement.profileId));

      emit(state.copyWith(status: MeasurementStatus.success, measurements: [
        ...state.measurements.where((element) => element.id != event.id)
      ]));
    } catch (e) {
      emit(state.copyWith(status: MeasurementStatus.error));
    }
  }

  Future<void> _updateMeasurement(
      UpdateMeasurement event, Emitter<MeasurementState> emit) async {
    emit(state.copyWith(status: MeasurementStatus.loading));

    try {
      await _measurementRepository.updateMeasurement(event.measurement);
      // add(GetLatestMeasurement(event.measurement.profileId));

      emit(state.copyWith(status: MeasurementStatus.success, measurements: [
        ...state.measurements.map((element) =>
            element.id == event.measurement.id ? event.measurement : element)
      ]));
    } catch (e) {
      emit(state.copyWith(status: MeasurementStatus.error));
    }
  }
}
