class WeatherModel {
  final String cityName;
  final String temperature;
  final String condition;
  final String humidity;
  final String windSpeed;
  final String visibility;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.visibility,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['cityName'] ?? '',
      temperature: json['temperature'] ?? '',
      condition: json['condition'] ?? '',
      humidity: json['humidity'] ?? '',
      windSpeed: json['windSpeed'] ?? '',
      visibility: json['visibility'] ?? '',
    );
  }
}
