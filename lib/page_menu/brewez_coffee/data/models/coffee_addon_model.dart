import 'package:flutter/material.dart';

enum AddonCategory {
  milk,
  syrup,
  booster,
  topping,
}

enum AddonType {
  // Milk Base
  freshMilk,
  oatMilk,
  almondMilk,

  // Syrups & Sauces
  palmSugar,
  caramelDrizzle,
  vanillaSyrup,

  // Boosters
  extraIce,
  extraShot,

  // Toppings & Foam
  cinnamonDust,
  cheeseFoam,
}

class CoffeeAddonModel {
  final AddonType type;
  final AddonCategory category;
  final String translationKeyName;
  final String translationKeySub;
  final double price; // 0 for Free
  final IconData icon;

  const CoffeeAddonModel({
    required this.type,
    required this.category,
    required this.translationKeyName,
    required this.translationKeySub,
    required this.price,
    required this.icon,
  });

  bool get isFree => price == 0;

  static const List<CoffeeAddonModel> allAddons = [
    // 1. Milk Base
    CoffeeAddonModel(
      type: AddonType.freshMilk,
      category: AddonCategory.milk,
      translationKeyName: 'addon_fresh_milk',
      translationKeySub: 'addon_fresh_milk_sub',
      price: 0,
      icon: Icons.local_drink_rounded,
    ),
    CoffeeAddonModel(
      type: AddonType.oatMilk,
      category: AddonCategory.milk,
      translationKeyName: 'addon_oat_milk',
      translationKeySub: 'addon_oat_milk_sub',
      price: 6000,
      icon: Icons.water_drop_outlined,
    ),
    CoffeeAddonModel(
      type: AddonType.almondMilk,
      category: AddonCategory.milk,
      translationKeyName: 'addon_almond_milk',
      translationKeySub: 'addon_almond_milk_sub',
      price: 6000,
      icon: Icons.spa_rounded,
    ),

    // 2. Syrups & Sweeteners
    CoffeeAddonModel(
      type: AddonType.palmSugar,
      category: AddonCategory.syrup,
      translationKeyName: 'addon_palm_sugar',
      translationKeySub: 'addon_palm_sugar_sub',
      price: 0,
      icon: Icons.eco_rounded,
    ),
    CoffeeAddonModel(
      type: AddonType.caramelDrizzle,
      category: AddonCategory.syrup,
      translationKeyName: 'addon_caramel',
      translationKeySub: 'addon_caramel_sub',
      price: 5000,
      icon: Icons.grain_rounded,
    ),
    CoffeeAddonModel(
      type: AddonType.vanillaSyrup,
      category: AddonCategory.syrup,
      translationKeyName: 'addon_vanilla',
      translationKeySub: 'addon_vanilla_sub',
      price: 4000,
      icon: Icons.bubble_chart_rounded,
    ),

    // 3. Boosters
    CoffeeAddonModel(
      type: AddonType.extraIce,
      category: AddonCategory.booster,
      translationKeyName: 'addon_extra_ice',
      translationKeySub: 'addon_extra_ice_sub',
      price: 0,
      icon: Icons.ac_unit_rounded,
    ),
    CoffeeAddonModel(
      type: AddonType.extraShot,
      category: AddonCategory.booster,
      translationKeyName: 'addon_extra_shot',
      translationKeySub: 'addon_extra_shot_sub',
      price: 8000,
      icon: Icons.bolt_rounded,
    ),

    // 4. Topping & Foam
    CoffeeAddonModel(
      type: AddonType.cinnamonDust,
      category: AddonCategory.topping,
      translationKeyName: 'addon_cinnamon',
      translationKeySub: 'addon_cinnamon_sub',
      price: 0,
      icon: Icons.flare_rounded,
    ),
    CoffeeAddonModel(
      type: AddonType.cheeseFoam,
      category: AddonCategory.topping,
      translationKeyName: 'addon_cheese_foam',
      translationKeySub: 'addon_cheese_foam_sub',
      price: 7000,
      icon: Icons.cloud_rounded,
    ),
  ];
}
