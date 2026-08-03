import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'weather_event.dart';
import 'weather_state.dart';
import '../weather_model.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<FetchWeather>(_onFetchWeather);
  }

  Future<void> _onFetchWeather(
    FetchWeather event,
    Emitter<WeatherState> emit,
  ) async {
    emit(WeatherLoading());

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Dummy JSON response simulating an API response
      const String jsonResponse = '''
      {
        "cityName": "Bandung",
        "temperature": "22°",
        "condition": "Cloudy",
        "humidity": "85%",
        "windSpeed": "10 km/h",
        "visibility": "8 km"
      }
      ''';

      // Parse JSON string into Map
      final Map<String, dynamic> decodedJson = jsonDecode(jsonResponse);
      
      // Convert Map into WeatherModel
      final WeatherModel weatherData = WeatherModel.fromJson(decodedJson);

      // Emit loaded state using data from model
      emit(WeatherLoaded(
        cityName: weatherData.cityName,
        temperature: weatherData.temperature,
        condition: weatherData.condition,
        humidity: weatherData.humidity,
        windSpeed: weatherData.windSpeed,
        visibility: weatherData.visibility,
      ));
    } catch (e) {
      emit(const WeatherError("Failed to parse weather data."));
    }
  }
}

