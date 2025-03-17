part of 'measurement_bloc.dart';

enum MeasurementStatus { initial, loading, success, error }

final class MeasurementState extends Equatable {
  final List<Measurement> measurements;
  final MeasurementStatus status;
  final List<Measurement> latestMeasurement;
  final List<Measurement> measurementsInRange;
  final List<Measurement> averageByDayInRange;

  const MeasurementState({
    this.measurements = const [],
    this.latestMeasurement = const [],
    this.measurementsInRange = const [],
    this.averageByDayInRange = const [],
    this.status = MeasurementStatus.initial,
  });

  MeasurementState copyWith({
    List<Measurement>? measurements,
    MeasurementStatus? status,
    List<Measurement>? latestMeasurement,
    List<Measurement>? measurementsInRange,
    List<Measurement>? averageByDayInRange,
  }) {
    return MeasurementState(
      measurements: measurements ?? this.measurements,
      status: status ?? this.status,
      latestMeasurement: latestMeasurement ?? this.latestMeasurement,
      measurementsInRange: measurementsInRange ?? this.measurementsInRange,
      averageByDayInRange: averageByDayInRange ?? this.averageByDayInRange,
    );
  }

  @override
  List<Object?> get props => [
        measurements,
        latestMeasurement,
        measurementsInRange,
        averageByDayInRange,
        status
      ];
}
