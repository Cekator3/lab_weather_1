import 'package:flutter/material.dart';
import 'package:lab_weather_1/model/weather-forecast/weather_forecast.dart';


class CurrentWeather extends StatelessWidget
{
  final WeatherForecast weatherForecast;

  const CurrentWeather({super.key, required this.weatherForecast});

  @override
  Widget build(BuildContext context)
  {
        return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.15,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: Colors.cyan,
                borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                    // Icon
                    Image.network(
                        weatherForecast.getIconUrl(),
                        color: Colors.white,
                    ),

                    Column(
                        children: [
                            const Spacer(),
                            // Title
                            const Text(
                                'Текущая погода',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                ),
                            ),

                            // Temperature
                            Text(
                                '${weatherForecast.getTemperature().toStringAsFixed(1)}°C',
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                ),
                            ),

                            // Humidity
                            Text(
                                'Влажность: ${weatherForecast.getHumidity()}%',
                                style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                ),
                            ),
                            const Spacer(),
                        ],
                    )
                ]
            )
        );
    }
}
