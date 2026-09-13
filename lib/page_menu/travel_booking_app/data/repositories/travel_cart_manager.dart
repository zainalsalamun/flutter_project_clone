import 'package:flutter/material.dart';
import '../models/travel_item_model.dart';
import 'travel_repository.dart';

class TravelCartItem {
  final String id;
  final TravelCategory category;
  final FlightTicket? flight;
  final TrainTicket? train;
  final DestinationItem? destination;
  final ExperienceItem? experience;
  final String selectedDetail;
  final DateTime travelDate;
  final double basePrice;
  int quantity;
  bool isSelected;

  TravelCartItem({
    required this.id,
    required this.category,
    this.flight,
    this.train,
    this.destination,
    this.experience,
    required this.selectedDetail,
    required this.travelDate,
    required this.basePrice,
    this.quantity = 1,
    this.isSelected = true,
  });

  String get title {
    if (flight != null) return flight!.airlineName;
    if (train != null) return train!.trainName;
    if (destination != null) return destination!.title;
    if (experience != null) return experience!.title;
    return 'Item Perjalanan';
  }

  String get subtitle {
    if (flight != null) return '${flight!.originCode} ➔ ${flight!.destinationCode} (${flight!.flightNumber})';
    if (train != null) return '${train!.originCode} ➔ ${train!.destinationCode} (${train!.trainClass})';
    if (destination != null) return '${destination!.location} • 1 Malam';
    if (experience != null) return '${experience!.location} • ${experience!.duration}';
    return '';
  }

  IconData get icon {
    switch (category) {
      case TravelCategory.flight:
        return Icons.flight_takeoff_rounded;
      case TravelCategory.train:
        return Icons.directions_railway_rounded;
      case TravelCategory.hotel:
        return Icons.hotel_rounded;
      case TravelCategory.experience:
        return Icons.explore_rounded;
    }
  }

  Color get categoryColor {
    switch (category) {
      case TravelCategory.flight:
        return const Color(0xFFFF5722);
      case TravelCategory.train:
        return const Color(0xFF0284C7);
      case TravelCategory.hotel:
        return const Color(0xFF0F766E);
      case TravelCategory.experience:
        return const Color(0xFF10B981);
    }
  }

  String get categoryName {
    switch (category) {
      case TravelCategory.flight:
        return 'Pesawat';
      case TravelCategory.train:
        return 'Kereta Api';
      case TravelCategory.hotel:
        return 'Hotel & Villa';
      case TravelCategory.experience:
        return 'Paket Wisata';
    }
  }

  double get totalPrice => basePrice * quantity;
}

class TravelCartManager extends ChangeNotifier {
  static final TravelCartManager _instance = TravelCartManager._internal();
  factory TravelCartManager() => _instance;

  final List<TravelCartItem> _items = [];

  TravelCartManager._internal() {
    _seedInitialCartItems();
  }

  void _seedInitialCartItems() {
    final repo = TravelRepository();
    final flights = repo.getFlightTickets();
    final trains = repo.getTrainTickets();
    final experiences = repo.getExperiences();

    _items.addAll([
      TravelCartItem(
        id: 'cart_fl_1',
        category: TravelCategory.flight,
        flight: flights[0],
        selectedDetail: 'Kursi 14A (Jendela)',
        travelDate: DateTime.now().add(const Duration(days: 4)),
        basePrice: flights[0].price,
        quantity: 1,
        isSelected: true,
      ),
      TravelCartItem(
        id: 'cart_tr_1',
        category: TravelCategory.train,
        train: trains[0],
        selectedDetail: 'Gerbong VIP 1 - 4A',
        travelDate: DateTime.now().add(const Duration(days: 9)),
        basePrice: trains[0].price,
        quantity: 1,
        isSelected: true,
      ),
      TravelCartItem(
        id: 'cart_exp_1',
        category: TravelCategory.experience,
        experience: experiences[0],
        selectedDetail: 'Sesi Pagi (08:30 WIB) • Pemandu',
        travelDate: DateTime.now().add(const Duration(days: 12)),
        basePrice: experiences[0].price,
        quantity: 2,
        isSelected: false,
      ),
    ]);
  }

  List<TravelCartItem> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  int get selectedCount => _items.where((e) => e.isSelected).length;

  bool get isAllSelected => _items.isNotEmpty && _items.every((e) => e.isSelected);

  double get selectedTotalPrice {
    return _items
        .where((e) => e.isSelected)
        .fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  void addItem({
    required TravelCategory category,
    FlightTicket? flight,
    TrainTicket? train,
    DestinationItem? destination,
    ExperienceItem? experience,
    String? selectedDetail,
    DateTime? travelDate,
    required double basePrice,
  }) {
    final id = 'cart_${DateTime.now().millisecondsSinceEpoch}';
    final newItem = TravelCartItem(
      id: id,
      category: category,
      flight: flight,
      train: train,
      destination: destination,
      experience: experience,
      selectedDetail: selectedDetail ??
          (flight != null
              ? 'Kursi 12B'
              : (train != null ? 'Gerbong 1 - 2A' : 'Standar')),
      travelDate: travelDate ?? DateTime.now().add(const Duration(days: 7)),
      basePrice: basePrice,
      quantity: 1,
      isSelected: true,
    );

    _items.insert(0, newItem);
    notifyListeners();
  }

  void removeItem(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateQuantity(String id, int quantity) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
      notifyListeners();
    }
  }

  void toggleItemSelection(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index].isSelected = !_items[index].isSelected;
      notifyListeners();
    }
  }

  void selectAll(bool select) {
    for (var item in _items) {
      item.isSelected = select;
    }
    notifyListeners();
  }

  List<TravelCartItem> getSelectedItems() {
    return _items.where((e) => e.isSelected).toList();
  }

  void removeSelected() {
    _items.removeWhere((item) => item.isSelected);
    notifyListeners();
  }
}
