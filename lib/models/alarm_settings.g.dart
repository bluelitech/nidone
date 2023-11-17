// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alarm_settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AlarmSettingsAdapter extends TypeAdapter<AlarmSettings> {
  @override
  final int typeId = 0;

  @override
  AlarmSettings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AlarmSettings(
      wakeupHour: fields[0] as int,
      wakeupMinute: fields[1] as int,
      limitHour: fields[2] as int,
      limitMinute: fields[3] as int,
      trigger: fields[4] as Trigger,
      weekdays: (fields[5] as List).cast<bool>(),
      isEnabled: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AlarmSettings obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.wakeupHour)
      ..writeByte(1)
      ..write(obj.wakeupMinute)
      ..writeByte(2)
      ..write(obj.limitHour)
      ..writeByte(3)
      ..write(obj.limitMinute)
      ..writeByte(4)
      ..write(obj.trigger)
      ..writeByte(5)
      ..write(obj.weekdays)
      ..writeByte(6)
      ..write(obj.isEnabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AlarmSettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
