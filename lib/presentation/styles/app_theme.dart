import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppGradients {
  static const background = LinearGradient(
    colors: [Color(0xFF0f172a), Color(0xFF1e293b)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const userBubble = LinearGradient(
    colors: [Color(0xFF10b981), Color(0xFF34d399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const botBubble = LinearGradient(
    colors: [Color(0xFF334155), Color(0xFF475569)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      colorSchemeSeed: const Color(0xFF6C5CE7),
      brightness: Brightness.light,
    );
    return base.copyWith(
      scaffoldBackgroundColor: Colors.transparent,
      textTheme: GoogleFonts.interTextTheme(base.textTheme),
      iconTheme: const IconThemeData(size: 22),
    );
  }
}
