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

// Mantidos para preservar a estrutura da V1.
const rosa = destaque;
const rosaEscuro = destaque;
const creme = fundo;

final appTheme = ThemeData(
  useMaterial3: true,
  scaffoldBackgroundColor: fundo,
  colorScheme: const ColorScheme.dark(
    surface: fundo,
    primary: destaque,
    onPrimary: Color(0xFF171512),
    secondary: destaqueEscuro,
    onSurface: texto,
  ),
  textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).apply(
    bodyColor: texto,
    displayColor: texto,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: fundo,
    foregroundColor: texto,
    elevation: 0,
    centerTitle: false,
  ),
  drawerTheme: const DrawerThemeData(
    backgroundColor: superficie,
    surfaceTintColor: Colors.transparent,
  ),
  inputDecorationTheme: const InputDecorationTheme(
    filled: true,
    fillColor: superficie,
    labelStyle: TextStyle(color: textoSecundario),
    prefixIconColor: textoSecundario,
    suffixIconColor: destaque,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: borda),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: borda),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(14)),
      borderSide: BorderSide(color: destaque, width: 1.5),
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: destaque,
    foregroundColor: Color(0xFF171512),
  ),
  snackBarTheme: const SnackBarThemeData(
    backgroundColor: superficieClara,
    contentTextStyle: TextStyle(color: texto),
  ),
);
