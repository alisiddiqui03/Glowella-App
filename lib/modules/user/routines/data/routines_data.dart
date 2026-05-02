import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

class RoutineData {
  final String id;
  final String title;
  final String subtitle;
  final Color cardColor;
  final IconData icon;
  final List<RoutineStep> steps;
  final String educationalNote;

  const RoutineData({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.cardColor,
    required this.icon,
    required this.steps,
    required this.educationalNote,
  });
}

class RoutineStep {
  final int stepNumber;
  final String action;
  final String productName;
  final String tip;

  const RoutineStep({
    required this.stepNumber,
    required this.action,
    required this.productName,
    required this.tip,
  });
}

final List<RoutineData> glowRoutines = [
  RoutineData(
    id: 'master',
    title: 'Master Routine',
    subtitle: 'Complete all-day skincare',
    cardColor: AppColors.routineMaster,
    icon: Icons.auto_awesome_rounded,
    steps: [
      RoutineStep(
        stepNumber: 1,
        action: 'Double Cleanse',
        productName: 'Glowella Cleanser',
        tip: 'Start with an oil-based cleanser to remove makeup and SPF.',
      ),
      RoutineStep(
        stepNumber: 2,
        action: 'Tone',
        productName: 'Glowella Toner',
        tip: 'Apply toner on a cotton pad to balance your skin pH.',
      ),
      RoutineStep(
        stepNumber: 3,
        action: 'Serum',
        productName: 'Vitamin C Serum',
        tip: 'Vitamin C brightens and protects from oxidative stress.',
      ),
      RoutineStep(
        stepNumber: 4,
        action: 'Eye Cream',
        productName: 'Glowella Eye Cream',
        tip: 'Gently tap — never rub — around the delicate eye area.',
      ),
      RoutineStep(
        stepNumber: 5,
        action: 'Moisturise',
        productName: 'Glowella Moisturiser',
        tip: 'Lock in all previous layers with a nourishing moisturiser.',
      ),
      RoutineStep(
        stepNumber: 6,
        action: 'SPF',
        productName: 'Glowella SPF 50',
        tip: 'Apply SPF as the final AM step every single day.',
      ),
    ],
    educationalNote:
        'Consistency is the key to glowing skin. A complete routine addresses cleansing, treatment, hydration, and sun protection — the four pillars of healthy skin.',
  ),
  RoutineData(
    id: 'morning',
    title: 'Morning Routine',
    subtitle: 'Start fresh every day',
    cardColor: AppColors.routineMorning,
    icon: Icons.wb_sunny_rounded,
    steps: [
      RoutineStep(
        stepNumber: 1,
        action: 'Gentle Cleanse',
        productName: 'Glowella Cleanser',
        tip: 'A light cleanse removes overnight oils without stripping skin.',
      ),
      RoutineStep(
        stepNumber: 2,
        action: 'Toner',
        productName: 'Glowella Toner',
        tip: 'Prep your skin to absorb serums and treatments better.',
      ),
      RoutineStep(
        stepNumber: 3,
        action: 'Vitamin C',
        productName: 'Vitamin C Serum',
        tip: 'Morning is the best time for antioxidant protection.',
      ),
      RoutineStep(
        stepNumber: 4,
        action: 'Moisturise',
        productName: 'Glowella Moisturiser',
        tip: 'Hydrate before sun protection to create an even base.',
      ),
      RoutineStep(
        stepNumber: 5,
        action: 'Sunscreen',
        productName: 'Glowella SPF 50',
        tip: 'SPF is non-negotiable! Reapply every 2 hours outdoors.',
      ),
    ],
    educationalNote:
        'Morning skincare focuses on protection. You are shielding your skin from UV rays, pollution, and environmental stress throughout the day.',
  ),
  RoutineData(
    id: 'night',
    title: 'Night Routine',
    subtitle: 'Repair while you sleep',
    cardColor: AppColors.routineNight,
    icon: Icons.nightlight_round,
    steps: [
      RoutineStep(
        stepNumber: 1,
        action: 'Remove Makeup',
        productName: 'Glowella Micellar Water',
        tip: 'Always remove makeup before cleansing to avoid clogged pores.',
      ),
      RoutineStep(
        stepNumber: 2,
        action: 'Deep Cleanse',
        productName: 'Glowella Cleanser',
        tip: 'A thorough cleanse removes the day\'s buildup and pollution.',
      ),
      RoutineStep(
        stepNumber: 3,
        action: 'Exfoliate (2x/week)',
        productName: 'Glowella Exfoliator',
        tip: 'Exfoliation promotes cell turnover for smoother, brighter skin.',
      ),
      RoutineStep(
        stepNumber: 4,
        action: 'Treatment Serum',
        productName: 'Retinol Serum',
        tip: 'Retinol works best at night — it breaks down in sunlight.',
      ),
      RoutineStep(
        stepNumber: 5,
        action: 'Eye Cream',
        productName: 'Glowella Eye Cream',
        tip: 'Night eye creams contain richer, repairing ingredients.',
      ),
      RoutineStep(
        stepNumber: 6,
        action: 'Night Moisturiser',
        productName: 'Glowella Night Cream',
        tip: 'Night creams are richer to support your skin\'s repair cycle.',
      ),
    ],
    educationalNote:
        'Your skin repairs and regenerates during sleep. Night routines focus on treatment ingredients like retinol and peptides that work in the absence of UV exposure.',
  ),
];
