enum TravelCategory {
  flight,
  hotel,
  train,
  experience,
}

TravelCategory travelCategoryFromString(String value) {
  switch (value.toLowerCase()) {
    case 'flight':
    case 'pesawat':
      return TravelCategory.flight;
    case 'train':
    case 'kereta':
      return TravelCategory.train;
    case 'hotel':
      return TravelCategory.hotel;
    case 'experience':
    case 'wisata':
    default:
      return TravelCategory.experience;
  }
}

class DestinationItem {
  final String id;
  final String title;
  final String location;
  final String country;
  final String imageUrl;
  final List<String> galleryUrls;
  final double rating;
  final int reviewCount;
  final double pricePerNight;
  final String description;
  final List<String> amenities;
  final TravelCategory category;
  final String tag;
  final bool isPopular;

  const DestinationItem({
    required this.id,
    required this.title,
    required this.location,
    required this.country,
    required this.imageUrl,
    required this.galleryUrls,
    required this.rating,
    required this.reviewCount,
    required this.pricePerNight,
    required this.description,
    required this.amenities,
    required this.category,
    required this.tag,
    this.isPopular = false,
  });

  String get heroTag => 'travel-hero-$id';

  factory DestinationItem.fromJson(Map<String, dynamic> json) {
    return DestinationItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      location: json['location'] as String? ?? '',
      country: json['country'] as String? ?? 'Indonesia',
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String? ?? '',
      galleryUrls: (json['gallery_urls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          (json['galleryUrls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewCount: json['review_count'] as int? ?? json['reviewCount'] as int? ?? 100,
      pricePerNight: (json['price_per_night'] as num?)?.toDouble() ?? (json['pricePerNight'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] as String? ?? '',
      amenities: (json['amenities'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      category: travelCategoryFromString(json['category'] as String? ?? 'hotel'),
      tag: json['tag'] as String? ?? 'HOTEL',
      isPopular: json['is_popular'] as bool? ?? json['isPopular'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'country': country,
      'image_url': imageUrl,
      'gallery_urls': galleryUrls,
      'rating': rating,
      'review_count': reviewCount,
      'price_per_night': pricePerNight,
      'description': description,
      'amenities': amenities,
      'category': category.name,
      'tag': tag,
      'is_popular': isPopular,
    };
  }
}

class FlightTicket {
  final String id;
  final String airlineName;
  final String airlineCode;
  final String flightNumber;
  final String originCity;
  final String originCode;
  final String destinationCity;
  final String destinationCode;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final double price;
  final String cabinClass;
  final int baggageKg;
  final String planeModel;
  final String logoUrl;

  const FlightTicket({
    required this.id,
    required this.airlineName,
    required this.airlineCode,
    required this.flightNumber,
    required this.originCity,
    required this.originCode,
    required this.destinationCity,
    required this.destinationCode,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.price,
    this.cabinClass = 'Economy',
    this.baggageKg = 20,
    this.planeModel = 'Boeing 737-800',
    required this.logoUrl,
  });

  String get heroTag => 'flight-hero-$id';

  factory FlightTicket.fromJson(Map<String, dynamic> json) {
    return FlightTicket(
      id: json['id'] as String? ?? '',
      airlineName: json['airline_name'] as String? ?? json['airlineName'] as String? ?? '',
      airlineCode: json['airline_code'] as String? ?? json['airlineCode'] as String? ?? '',
      flightNumber: json['flight_number'] as String? ?? json['flightNumber'] as String? ?? '',
      originCity: json['origin_city'] as String? ?? json['originCity'] as String? ?? '',
      originCode: json['origin_code'] as String? ?? json['originCode'] as String? ?? '',
      destinationCity: json['destination_city'] as String? ?? json['destinationCity'] as String? ?? '',
      destinationCode: json['destination_code'] as String? ?? json['destinationCode'] as String? ?? '',
      departureTime: json['departure_time'] as String? ?? json['departureTime'] as String? ?? '',
      arrivalTime: json['arrival_time'] as String? ?? json['arrivalTime'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      cabinClass: json['cabin_class'] as String? ?? json['cabinClass'] as String? ?? 'Economy',
      baggageKg: json['baggage_kg'] as int? ?? json['baggageKg'] as int? ?? 20,
      planeModel: json['plane_model'] as String? ?? json['planeModel'] as String? ?? 'Boeing 737',
      logoUrl: json['logo_url'] as String? ?? json['logoUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'airline_name': airlineName,
      'airline_code': airlineCode,
      'flight_number': flightNumber,
      'origin_city': originCity,
      'origin_code': originCode,
      'destination_city': destinationCity,
      'destination_code': destinationCode,
      'departure_time': departureTime,
      'arrival_time': arrivalTime,
      'duration': duration,
      'price': price,
      'cabin_class': cabinClass,
      'baggage_kg': baggageKg,
      'plane_model': planeModel,
      'logo_url': logoUrl,
    };
  }
}

class TrainTicket {
  final String id;
  final String trainName;
  final String trainNumber;
  final String trainClass;
  final String originStation;
  final String originCode;
  final String originCity;
  final String destinationStation;
  final String destinationCode;
  final String destinationCity;
  final String departureTime;
  final String arrivalTime;
  final String duration;
  final double price;
  final List<String> transitStops;
  final String wagonInfo;
  final String speedText;

  const TrainTicket({
    required this.id,
    required this.trainName,
    required this.trainNumber,
    required this.trainClass,
    required this.originStation,
    required this.originCode,
    required this.originCity,
    required this.destinationStation,
    required this.destinationCode,
    required this.destinationCity,
    required this.departureTime,
    required this.arrivalTime,
    required this.duration,
    required this.price,
    required this.transitStops,
    this.wagonInfo = 'Gerbong Eksekutif 1 (2-2)',
    this.speedText = '120 km/jam',
  });

  String get heroTag => 'train-hero-$id';

  factory TrainTicket.fromJson(Map<String, dynamic> json) {
    return TrainTicket(
      id: json['id'] as String? ?? '',
      trainName: json['train_name'] as String? ?? json['trainName'] as String? ?? '',
      trainNumber: json['train_number'] as String? ?? json['trainNumber'] as String? ?? '',
      trainClass: json['train_class'] as String? ?? json['trainClass'] as String? ?? 'Eksekutif',
      originStation: json['origin_station'] as String? ?? json['originStation'] as String? ?? '',
      originCode: json['origin_code'] as String? ?? json['originCode'] as String? ?? '',
      originCity: json['origin_city'] as String? ?? json['originCity'] as String? ?? '',
      destinationStation: json['destination_station'] as String? ?? json['destinationStation'] as String? ?? '',
      destinationCode: json['destination_code'] as String? ?? json['destinationCode'] as String? ?? '',
      destinationCity: json['destination_city'] as String? ?? json['destinationCity'] as String? ?? '',
      departureTime: json['departure_time'] as String? ?? json['departureTime'] as String? ?? '',
      arrivalTime: json['arrival_time'] as String? ?? json['arrivalTime'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      transitStops: (json['transit_stops'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          (json['transitStops'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      wagonInfo: json['wagon_info'] as String? ?? json['wagonInfo'] as String? ?? 'Gerbong 1',
      speedText: json['speed_text'] as String? ?? json['speedText'] as String? ?? '120 km/jam',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'train_name': trainName,
      'train_number': trainNumber,
      'train_class': trainClass,
      'origin_station': originStation,
      'origin_code': originCode,
      'origin_city': originCity,
      'destination_station': destinationStation,
      'destination_code': destinationCode,
      'destination_city': destinationCity,
      'departure_time': departureTime,
      'arrival_time': arrivalTime,
      'duration': duration,
      'price': price,
      'transit_stops': transitStops,
      'wagon_info': wagonInfo,
      'speed_text': speedText,
    };
  }
}

class ExperienceItem {
  final String id;
  final String title;
  final String location;
  final String country;
  final String categoryTag;
  final String duration;
  final double rating;
  final int reviewCount;
  final double price;
  final String imageUrl;
  final List<String> galleryUrls;
  final String description;
  final List<String> highlights;
  final bool includesGuide;
  final bool isInstantConfirm;

  const ExperienceItem({
    required this.id,
    required this.title,
    required this.location,
    required this.country,
    required this.categoryTag,
    required this.duration,
    required this.rating,
    required this.reviewCount,
    required this.price,
    required this.imageUrl,
    required this.galleryUrls,
    required this.description,
    required this.highlights,
    this.includesGuide = true,
    this.isInstantConfirm = true,
  });

  String get heroTag => 'exp-hero-$id';

  factory ExperienceItem.fromJson(Map<String, dynamic> json) {
    return ExperienceItem(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      location: json['location'] as String? ?? '',
      country: json['country'] as String? ?? 'Indonesia',
      categoryTag: json['category_tag'] as String? ?? json['categoryTag'] as String? ?? 'WISATA',
      duration: json['duration'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
      reviewCount: json['review_count'] as int? ?? json['reviewCount'] as int? ?? 100,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['image_url'] as String? ?? json['imageUrl'] as String? ?? '',
      galleryUrls: (json['gallery_urls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          (json['galleryUrls'] as List<dynamic>?)?.map((e) => e.toString()).toList() ??
          [],
      description: json['description'] as String? ?? '',
      highlights: (json['highlights'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      includesGuide: json['includes_guide'] as bool? ?? json['includesGuide'] as bool? ?? true,
      isInstantConfirm: json['is_instant_confirm'] as bool? ?? json['isInstantConfirm'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'country': country,
      'category_tag': categoryTag,
      'duration': duration,
      'rating': rating,
      'review_count': reviewCount,
      'price': price,
      'image_url': imageUrl,
      'gallery_urls': galleryUrls,
      'description': description,
      'highlights': highlights,
      'includes_guide': includesGuide,
      'is_instant_confirm': isInstantConfirm,
    };
  }
}

class PassengerInfo {
  final String fullName;
  final String idCardOrPassport;
  final String email;
  final String phone;
  final String selectedSeat;
  final String selectedMeal;
  final int extraBaggage;

  const PassengerInfo({
    this.fullName = 'Zainal Salamun',
    this.idCardOrPassport = '3171012345678901',
    this.email = 'zainal.dev@example.com',
    this.phone = '+62 812-3456-7890',
    this.selectedSeat = '12A',
    this.selectedMeal = 'Signature Grilled Chicken Rice',
    this.extraBaggage = 0,
  });

  PassengerInfo copyWith({
    String? fullName,
    String? idCardOrPassport,
    String? email,
    String? phone,
    String? selectedSeat,
    String? selectedMeal,
    int? extraBaggage,
  }) {
    return PassengerInfo(
      fullName: fullName ?? this.fullName,
      idCardOrPassport: idCardOrPassport ?? this.idCardOrPassport,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      selectedSeat: selectedSeat ?? this.selectedSeat,
      selectedMeal: selectedMeal ?? this.selectedMeal,
      extraBaggage: extraBaggage ?? this.extraBaggage,
    );
  }

  factory PassengerInfo.fromJson(Map<String, dynamic> json) {
    return PassengerInfo(
      fullName: json['full_name'] as String? ?? json['fullName'] as String? ?? 'Zainal Salamun',
      idCardOrPassport: json['id_card_or_passport'] as String? ?? json['idCardOrPassport'] as String? ?? '3171012345678901',
      email: json['email'] as String? ?? 'zainal.dev@example.com',
      phone: json['phone'] as String? ?? '+62 812-3456-7890',
      selectedSeat: json['selected_seat'] as String? ?? json['selectedSeat'] as String? ?? '12A',
      selectedMeal: json['selected_meal'] as String? ?? json['selectedMeal'] as String? ?? '',
      extraBaggage: json['extra_baggage'] as int? ?? json['extraBaggage'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'id_card_or_passport': idCardOrPassport,
      'email': email,
      'phone': phone,
      'selected_seat': selectedSeat,
      'selected_meal': selectedMeal,
      'extra_baggage': extraBaggage,
    };
  }
}

class BookingOrder {
  final String orderId;
  final String bookingCode;
  final DestinationItem? destination;
  final FlightTicket? flight;
  final TrainTicket? train;
  final ExperienceItem? experience;
  final TravelCategory category;
  final DateTime travelDate;
  final PassengerInfo passenger;
  final double basePrice;
  final double taxAndService;
  final double discountAmount;
  final double extraAddonsPrice;
  final String paymentMethod;
  final String status;

  const BookingOrder({
    required this.orderId,
    required this.bookingCode,
    this.destination,
    this.flight,
    this.train,
    this.experience,
    required this.category,
    required this.travelDate,
    required this.passenger,
    required this.basePrice,
    required this.taxAndService,
    this.discountAmount = 0,
    this.extraAddonsPrice = 0,
    this.paymentMethod = 'BCA Virtual Account',
    this.status = 'Confirmed / Issued',
  });

  double get totalPrice => (basePrice + taxAndService + extraAddonsPrice) - discountAmount;

  factory BookingOrder.fromJson(Map<String, dynamic> json) {
    return BookingOrder(
      orderId: json['order_id'] as String? ?? json['orderId'] as String? ?? '',
      bookingCode: json['booking_code'] as String? ?? json['bookingCode'] as String? ?? '',
      destination: json['destination'] != null ? DestinationItem.fromJson(json['destination'] as Map<String, dynamic>) : null,
      flight: json['flight'] != null ? FlightTicket.fromJson(json['flight'] as Map<String, dynamic>) : null,
      train: json['train'] != null ? TrainTicket.fromJson(json['train'] as Map<String, dynamic>) : null,
      experience: json['experience'] != null ? ExperienceItem.fromJson(json['experience'] as Map<String, dynamic>) : null,
      category: travelCategoryFromString(json['category'] as String? ?? 'hotel'),
      travelDate: json['travel_date'] != null ? DateTime.parse(json['travel_date'] as String) : DateTime.now(),
      passenger: json['passenger'] != null
          ? PassengerInfo.fromJson(json['passenger'] as Map<String, dynamic>)
          : const PassengerInfo(),
      basePrice: (json['base_price'] as num?)?.toDouble() ?? 0.0,
      taxAndService: (json['tax_and_service'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
      extraAddonsPrice: (json['extra_addons_price'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['payment_method'] as String? ?? 'BCA Virtual Account',
      status: json['status'] as String? ?? 'Confirmed',
    );
  }
}
