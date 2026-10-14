import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const fundo = Color(0xFF101012);
const superficie = Color(0xFF1A1A1E);
const superficieClara = Color(0xFF25252B);
const destaque = Color(0xFFD7B98E);
const destaqueEscuro = Color(0xFFB08F63);
const texto = Color(0xFFF3F0EA);
const textoSecundario = Color(0xFFB9B5AE);
const borda = Color(0xFF39393F);
const rosa = destaque;
const rosaEscuro = destaque;
const creme = fundo;

const fundoDia = Color(0xFFFFFFFF);
const superficieDia = Color(0xFFF6F4F1);
const textoDia = Color(0xFF25221E);
const secundarioDia = Color(0xFF6B665F);
const bordaDia = Color(0xFFE3DED7);

ThemeData _criarTema(bool claro) {
  final bg = claro ? fundoDia : fundo;
  final surface = claro ? superficieDia : superficie;
  final fg = claro ? textoDia : texto;
  final muted = claro ? secundarioDia : textoSecundario;
  final outline = claro ? bordaDia : borda;
  final accent = claro ? destaqueEscuro : destaque;
  final contrast = claro ? Colors.white : const Color(0xFF171512);
  final brightness = claro ? Brightness.light : Brightness.dark;

  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: bg,
    colorScheme: ColorScheme.fromSeed(seedColor: destaque, brightness: brightness).copyWith(
      surface: bg,
      primary: accent,
      onPrimary: contrast,
      secondary: destaqueEscuro,
      onSurface: fg,
      outline: outline,
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      claro ? ThemeData.light().textTheme : ThemeData.dark().textTheme,
    ).apply(bodyColor: fg, displayColor: fg),
    appBarTheme: AppBarTheme(
      backgroundColor: bg,
      foregroundColor: fg,
      elevation: 0,
      centerTitle: false,
    ),
    drawerTheme: DrawerThemeData(
      backgroundColor: surface,
      surfaceTintColor: Colors.transparent,
    ),
    cardTheme: CardThemeData(color: surface, elevation: 0),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      labelStyle: TextStyle(color: muted),
      prefixIconColor: muted,
      suffixIconColor: accent,
      border: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(14)),
        borderSide: BorderSide(color: accent, width: 1.5),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accent,
      foregroundColor: contrast,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: claro ? superficieDia : superficieClara,
      contentTextStyle: TextStyle(color: fg),
    ),
  );
}

final appTheme = _criarTema(false);
final appThemeLight = _criarTema(true);
