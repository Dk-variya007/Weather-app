import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/bloc/weather_bloc.dart';
import 'package:weather_app/bloc/weather_state.dart';
import 'package:weather_app/model/weathermodel.dart';
import 'package:weather_app/view/home_screen.dart';

class WeatherDetailScreen extends StatefulWidget {
  final WeatherModel weather;

  const WeatherDetailScreen({super.key, required this.weather});

  @override
  State<WeatherDetailScreen> createState() => _WeatherDetailScreenState();
}

class _WeatherDetailScreenState extends State<WeatherDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: LayoutBuilder(
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

  //for Mobile View
  Widget _buildMobileLayout(BuildContext context) {
    return _buildContent(context);
  }

  //for Tablet View
  Widget _buildTabletLayout(BuildContext context) {
    return _buildContent(context);
  }

  //for content
  Widget _buildContent(BuildContext context) {
    return BlocConsumer<WeatherBloc, WeatherState>(
      listener: (context, state) {
        if (state is WeatherError) {
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is WeatherLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is WeatherLoaded) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromRGBO(65, 100, 220, 0.984),
                  Color(0xff68A5EA),
                ],
              ),
            ),
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              color: Colors.black,
              backgroundColor: Colors.blue,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
                          }, icon: Icon(CupertinoIcons.home)),
                      Center(
                        child: Column(
                          children: [
                            Lottie.asset('assets/animation/Animation.json',
                                height: 200),
                            const SizedBox(height: 10),
                            Text(
                              '📍 ${state.weather.cityName}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              width: 200,
                              height: 100,
                              child: Card(
                                shadowColor: Colors.black,
                                elevation: 10,
                                color: Colors.white.withOpacity(0.7),
                                child: Center(
                                  child: Text(
                                    '${state.weather.temperature}°C',
                                    style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 55,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Icon : ',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          ),
                          Image.network(
                              'https://openweathermap.org/img/w/${state.weather
                                  .icon}.png'),
                        ],
                      ),
                      Divider(color: Colors.white),
                      _buildWeatherDetail(
                          "Condition", state.weather.weatherCondition),
                      Divider(color: Colors.white),
                      _buildWeatherDetail(
                          "Humidity", "${state.weather.humidity}%"),
                      Divider(color: Colors.white),
                      _buildWeatherDetail(
                          "Wind Speed", "${state.weather.windSpeed} m/s"),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
        return const Center(
            child: Text('Something went wrong!',
                style: TextStyle(color: Colors.white)));
      },
    );
  }

  Widget _buildWeatherDetail(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            value,
            style: const TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
