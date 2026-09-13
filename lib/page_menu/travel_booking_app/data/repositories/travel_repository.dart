import 'dart:convert';
import '../datasources/travel_dummy_json_data.dart';
import '../models/travel_item_model.dart';

class TravelRepository {
  static final TravelRepository _instance = TravelRepository._internal();
  factory TravelRepository() => _instance;

  late final Map<String, dynamic> _parsedData;

  TravelRepository._internal() {
    _parsedData = jsonDecode(kTravelDummyJsonRaw) as Map<String, dynamic>;
  }

  List<DestinationItem> getFeaturedDestinations() {
    final list = _parsedData['destinations'] as List<dynamic>? ?? [];
    return list.map((item) => DestinationItem.fromJson(item as Map<String, dynamic>)).toList();
  }

  List<FlightTicket> getFlightTickets() {
    final list = _parsedData['flights'] as List<dynamic>? ?? [];
    return list.map((item) => FlightTicket.fromJson(item as Map<String, dynamic>)).toList();
  }

  List<TrainTicket> getTrainTickets() {
    final list = _parsedData['trains'] as List<dynamic>? ?? [];
    return list.map((item) => TrainTicket.fromJson(item as Map<String, dynamic>)).toList();
  }

  List<ExperienceItem> getExperiences() {
    final list = _parsedData['experiences'] as List<dynamic>? ?? [];
    return list.map((item) => ExperienceItem.fromJson(item as Map<String, dynamic>)).toList();
  }

  DestinationItem? getDestinationById(String id) {
    return getFeaturedDestinations().firstWhere(
      (item) => item.id == id,
      orElse: () => getFeaturedDestinations().first,
    );
  }

  FlightTicket? getFlightById(String id) {
    return getFlightTickets().firstWhere(
      (item) => item.id == id,
      orElse: () => getFlightTickets().first,
    );
  }

  TrainTicket? getTrainById(String id) {
    return getTrainTickets().firstWhere(
      (item) => item.id == id,
      orElse: () => getTrainTickets().first,
    );
  }

  ExperienceItem? getExperienceById(String id) {
    return getExperiences().firstWhere(
      (item) => item.id == id,
      orElse: () => getExperiences().first,
    );
  }
}
