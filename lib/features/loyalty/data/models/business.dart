import 'package:flutter/material.dart';

class Business {
  final String id;
  final String name;
  final String category;
  final IconData icon;
  final Color accentColor;
  final Color backgroundColor;
  final int totalStamps;
  final int currentStamps;
  final String reward;
  final String description;
  final String nit;

  const Business({
    required this.id,
    required this.name,
    required this.category,
    required this.icon,
    required this.accentColor,
    required this.backgroundColor,
    required this.totalStamps,
    required this.currentStamps,
    required this.reward,
    required this.description,
    required this.nit,
  });
}

final List<Business> mockBusinesses = [
  Business(
    id: 'salon_bella',
    name: 'Bella Studio',
    category: 'Salón de Belleza',
    icon: Icons.content_cut_rounded,
    accentColor: const Color(0xFFE91E63),
    backgroundColor: const Color(0xFF1A1225),
    totalStamps: 8,
    currentStamps: 5,
    reward: 'Corte gratis',
    description:
        'Tu salón de confianza en el centro de La Paz. Especialistas en cortes modernos, colorimetría y tratamientos capilares.',
    nit: '1023456789',
  ),
  Business(
    id: 'cafe_aroma',
    name: 'Café Aroma',
    category: 'Cafetería',
    icon: Icons.coffee_rounded,
    accentColor: const Color(0xFFFF8B53),
    backgroundColor: const Color(0xFF1A1812),
    totalStamps: 10,
    currentStamps: 3,
    reward: 'Café americano gratis',
    description:
        'El mejor café de especialidad boliviano. Granos de Yungas tostados artesanalmente cada semana.',
    nit: '2034567890',
  ),
  Business(
    id: 'helados_glaciar',
    name: 'Glaciar Ice',
    category: 'Heladería',
    icon: Icons.icecream_rounded,
    accentColor: const Color(0xFF00BCD4),
    backgroundColor: const Color(0xFF121A1E),
    totalStamps: 6,
    currentStamps: 6,
    reward: 'Sundae doble gratis',
    description:
        'Helados artesanales con sabores únicos bolivianos. Prueba nuestro helado de api y tumbo.',
    nit: '3045678901',
  ),
];
