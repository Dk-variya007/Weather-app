import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/api/service.dart';
import 'package:weather_app/view/home_screen.dart';

void main() {
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => WeatherBloc(weatherService: WeatherService()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
                titleSmall:
                GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
                titleLarge: GoogleFonts.lato(fontWeight: FontWeight.bold),
                titleMedium:
                GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold))),
        home: HomeScreen(),
      ),
    );
  }
}
