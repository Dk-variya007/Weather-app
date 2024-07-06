
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/bloc/weather_state.dart';
import 'package:weather_app/view/weather_detailed.dart';
import '../bloc/weather_bloc.dart';
import '../bloc/weather_event.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/weathermodel.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recentSearches') ?? [];
    });
  }

  Future<void> _saveRecentSearch(String cityName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      if (!_recentSearches.contains(cityName)) {
        _recentSearches.insert(0, cityName);
        if (_recentSearches.length > 5) {
          _recentSearches.removeLast();
        }
        prefs.setStringList('recentSearches', _recentSearches);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(65, 100, 220, 0.984),
              Colors.black45,
              Colors.grey,
              Colors.white,
              Colors.blue.shade50
            ],
          ),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              return _buildTabletLayout(context);
            } else {
              return _buildMobileLayout(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            //_buildBackground(),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: _buildContent(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Stack(
          children: [
            //_buildBackground(),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: _buildContent(context),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildBackground() {
  //   return Stack(
  //     children: [
  //       Align(
  //         alignment: const AlignmentDirectional(3, -0.3),
  //         child: Container(
  //           width: 300,
  //           height: 300,
  //           decoration: const BoxDecoration(
  //               shape: BoxShape.circle, color: Colors.deepPurple),
  //         ),
  //       ),
  //       Align(
  //         alignment: const AlignmentDirectional(-3, -0.3),
  //         child: Container(
  //           width: 300,
  //           height: 300,
  //           decoration: const BoxDecoration(
  //               shape: BoxShape.circle, color: Colors.deepPurple),
  //         ),
  //       ),
  //       Align(
  //         alignment: const AlignmentDirectional(0, -1.2),
  //         child: Container(
  //           width: 600,
  //           height: 110,
  //           decoration: const BoxDecoration(
  //               shape: BoxShape.rectangle, color: Colors.orange),
  //         ),
  //       ),
  //       BackdropFilter(
  //         filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 100.0),
  //         child: Container(
  //           decoration: const BoxDecoration(color: Colors.transparent),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const SizedBox(height: 50),
          Align(
              alignment: Alignment.topLeft,
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "G",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                    TextSpan(
                      text: "ood",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                    TextSpan(
                      text: " M",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                    TextSpan(
                      text: "orning! ☀️",
                      style: TextStyle(
                        fontSize: 25,
                        color: Colors.white,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: Colors.black.withOpacity(0.5),
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Lottie.asset("assets/animation/Animation1.json"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40),
            child: TextField(
              style: const TextStyle(color: Colors.black),
              controller: _cityController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Colors.grey,
                labelText: 'Enter city name',
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              if (_cityController.text.trim().isNotEmpty) {
                BlocProvider.of<WeatherBloc>(context)
                    .add(FetchWeather(_cityController.text));
                _saveRecentSearch(_cityController.text);
              }
              _cityController.clear();
            },
            child: const Text('Search',style: TextStyle(color: CupertinoColors.black),),
          ),
          const SizedBox(height: 20),
          BlocConsumer<WeatherBloc, WeatherState>(
            listener: (context, state) {
              if (state is WeatherLoaded) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        WeatherDetailScreen(weather: state.weather),
                  ),
                );
              } else if (state is WeatherError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            builder: (context, state) {
              if (state is WeatherLoading) {
                return const CircularProgressIndicator();
              }
              if (state is WeatherLoaded) {
                return Column(
                  children: [
                    _buildWeatherCard(state.weather),
                    const SizedBox(height: 20),
                  ],
                );
              }
              return Container();
            },
          ),
          const SizedBox(height: 20),
          _buildRecentSearches(),
        ],
      ),
    );
  }

  Widget _buildWeatherCard(WeatherModel weather) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Current Weather in ${weather.cityName}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${weather.temperature}°C',
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Image.network(
              'https://openweathermap.org/img/w/${weather.icon}.png',
              scale: 0.5,
            ),
            const SizedBox(height: 10),
            Text(
              weather.weatherCondition,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recent Searches',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: _recentSearches.map((city) {
            return ActionChip(
              label: Text(city),
              onPressed: () {
                BlocProvider.of<WeatherBloc>(context).add(FetchWeather(city));
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
