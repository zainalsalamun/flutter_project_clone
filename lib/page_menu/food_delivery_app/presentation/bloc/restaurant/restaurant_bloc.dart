import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/restaurant_model.dart';
import '../../../data/repositories/restaurant_repository.dart';

abstract class RestaurantEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchNearbyRestaurants extends RestaurantEvent {}
class FetchRestaurantDetail extends RestaurantEvent {
  final String id;
  FetchRestaurantDetail(this.id);
  @override
  List<Object?> get props => [id];
}

abstract class RestaurantState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RestaurantInitial extends RestaurantState {}
class RestaurantLoading extends RestaurantState {}
class RestaurantsLoaded extends RestaurantState {
  final List<RestaurantModel> restaurants;
  RestaurantsLoaded(this.restaurants);
  @override
  List<Object?> get props => [restaurants];
}
class RestaurantDetailLoaded extends RestaurantState {
  final RestaurantModel restaurant;
  RestaurantDetailLoaded(this.restaurant);
  @override
  List<Object?> get props => [restaurant];
}
class RestaurantError extends RestaurantState {
  final String message;
  RestaurantError(this.message);
  @override
  List<Object?> get props => [message];
}

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  final RestaurantRepository repository;

  RestaurantBloc({required this.repository}) : super(RestaurantInitial()) {
    on<FetchNearbyRestaurants>((event, emit) async {
      emit(RestaurantLoading());
      try {
        final restaurants = await repository.getNearbyRestaurants();
        emit(RestaurantsLoaded(restaurants));
      } catch (e) {
        emit(RestaurantError(e.toString()));
      }
    });

    on<FetchRestaurantDetail>((event, emit) async {
      emit(RestaurantLoading());
      try {
        final restaurant = await repository.getRestaurantDetail(event.id);
        emit(RestaurantDetailLoaded(restaurant));
      } catch (e) {
        emit(RestaurantError(e.toString()));
      }
    });
  }
}
