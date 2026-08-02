import 'package:equatable/equatable.dart';

abstract class WeatherState extends Equatable {
  const WeatherState();
  
  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState {}

class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final String cityName;
  final String temperature;
  final String condition;
  final String humidity;
  final String windSpeed;
  final String visibility;

  const WeatherLoaded({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.visibility,
  });

  @override
  List<Object> get props => [
        cityName,
        temperature,
        condition,
        humidity,
        windSpeed,
        visibility,
      ];
}

class WeatherError extends WeatherState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object> get props => [message];
}
