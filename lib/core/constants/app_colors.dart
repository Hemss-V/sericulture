import 'package:flutter/material.dart';

/// Central color palette for the Sericulture IoT app.
/// Primary: Deep green #1B4332, Accent: Amber #F59E0B
class AppColors {
  AppColors._();

  // ── Brand ──────────────────────────────────────────
  static const Color primary = Color(0xFF1B4332);
  static const Color primaryLight = Color(0xFF2D6A4F);
  static const Color primaryDark = Color(0xFF0D2B1E);
  static const Color accent = Color(0xFFF59E0B);
  static const Color accentLight = Color(0xFFFBBF24);
  static const Color accentDark = Color(0xFFD97706);

  // ── Backgrounds ────────────────────────────────────
  static const Color background = Color(0xFF0A0F0D);
  static const Color surface = Color(0xFF111A15);
  static const Color surfaceVariant = Color(0xFF1A2820);
  static const Color cardBackground = Color(0xFF162118);
  static const Color divider = Color(0xFF2A3E30);

  // ── Status ─────────────────────────────────────────
  static const Color statusNormal = Color(0xFF10B981);   // green
  static const Color statusWarning = Color(0xFFF59E0B);  // amber
  static const Color statusCritical = Color(0xFFEF4444); // red
  static const Color statusOffline = Color(0xFF6B7280);  // gray

  // ── Text ───────────────────────────────────────────
  static const Color textPrimary = Color(0xFFF0FDF4);
  static const Color textSecondary = Color(0xFF9DB7A8);
  static const Color textDisabled = Color(0xFF4B6055);
  static const Color textOnAccent = Color(0xFF0A0F0D);

  // ── Sensor-specific tints (for cards) ──────────────
  static const Color tempTint = Color(0xFFFF8C42);
  static const Color humidityTint = Color(0xFF38BDF8);
  static const Color co2Tint = Color(0xFFA78BFA);
  static const Color lightTint = Color(0xFFFBBF24);
}
