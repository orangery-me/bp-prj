part of 'measurement_bloc.dart';

class MeasurementEvent {}

class PostMeasurement extends MeasurementEvent {
  final Measurement measurement;

  PostMeasurement(this.measurement);
}

class GetAllMeasurements extends MeasurementEvent {
  final int profileId;

  GetAllMeasurements(this.profileId);
}

class GetLatestMeasurement extends MeasurementEvent {
  final int profileId;

  GetLatestMeasurement(this.profileId);
}

class GetMeasurementsInRange extends MeasurementEvent {
  final int profileId;
  final DateTime startDate;
  final DateTime endDate;

  GetMeasurementsInRange(this.profileId, this.startDate, this.endDate);
}

class GetAverageByDayInRange extends MeasurementEvent {
  final int profileId;
  final DateTime startDate;
  final DateTime endDate;

  GetAverageByDayInRange(this.profileId, this.startDate, this.endDate);
}

class DeleteMeasurement extends MeasurementEvent {
  final int id;

  DeleteMeasurement(this.id);
}

class UpdateMeasurement extends MeasurementEvent {
  final Measurement measurement;

  UpdateMeasurement(this.measurement);
}
