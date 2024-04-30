// ignore_for_file: curly_braces_in_flow_control_structures
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:lab_weather_1/Widgets/city_search_bar.dart';
import 'package:lab_weather_1/Widgets/current_weather.dart';
import 'package:lab_weather_1/Widgets/geolocation_button.dart';
import 'package:lab_weather_1/Widgets/weather_forecast_table.dart';
import 'package:lab_weather_1/model/weather-forecast/errors/weather_forecast_get_by_geolocation_errors.dart';
import 'model/weather-forecast/errors/weather_forecast_get_by_query_errors.dart';
import 'model/weather-forecast/weather_forecast.dart';
import 'model/weather-forecast/weather_forecast_getter.dart';

class WeatherHomePageState extends State<WeatherHomePage>
{
    List<WeatherForecast> _forecasts = [];

    void showError(String message)
    {
        final snackBar = SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    void _getWeatherForecastsByQuery(String query) async
    {
        final forecastsGetter = WeatherForecastGetter();
        final errors = WeatherForecastGetByQueryErrors();

        final newForecasts = await forecastsGetter.getByQuery(query, errors);

        // Errors handling
        if (errors.hasAny())
        {
            if (errors.isInternetConnectionMissing())
                showError('Отсутствует интернет-соединение.');
            if (errors.isInternalErrorOcurred())
                showError('В приложении произошла критическая ошибка. Разработчики уже были оповещены.');
            if (errors.isCityNotFound())
                showError('Информации по введённому населённому пункту не было найдено.');

            return;
        }

        // Applying changes
        setState(()
        {
            _forecasts = newForecasts;
        });
    }

    void _getWeatherForecastsByUserGeolocation() async
    {
        final forecastsGetter = WeatherForecastGetter();
        final errors = WeatherForecastGetByGeolocationErrors();

        final newForecasts = await forecastsGetter.getByGeolocation(errors);

        // Errors handling
        if (errors.hasAny())
        {
            if (errors.isInternetConnectionMissing())
                showError('Отсутствует интернет-соединение.');
            if (errors.isInternalErrorOcurred())
                showError('В приложении произошла критическая ошибка. Разработчики уже были оповещены.');
            if (errors.isCityNotFound())
                showError('Информации по введённому населённому пункту не было найдено.');
            if (errors.isDeviceNotSupportGeolocation())
                showError('Ваше устройство не поддерживает геолокацию. Автоматическое определение вашего местоположения невозможно.');

            return;
        }

        // Applying changes
        setState(()
        {
            _forecasts = newForecasts;
        });
    }

    @override
    Widget build(BuildContext context)
    {
        return Scaffold(
            appBar: AppBar(
                title: Text(
                    widget.title,
                    style: Theme.of(context).appBarTheme.titleTextStyle,
                ),
            ),

            body: Column(
                children: [
                    // City search bar and geolocation button
                    Row(
                        children: [
                            Expanded(
                                child: CitySearchBar(onSubmitted: _getWeatherForecastsByQuery),
                            ),
                            const SizedBox(width: 10),
                            GeolocationButton(onPressed: _getWeatherForecastsByUserGeolocation),
                        ],
                    ),
                    if (_forecasts.isNotEmpty)
                        CurrentWeather(weatherForecast: _forecasts.first),
                    if (_forecasts.isNotEmpty)
                        SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.64,
                            child: Container(
                                margin: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.cyan,
                                    borderRadius: BorderRadius.circular(10),
                                ),
                                child: IntrinsicWidth(
                                    child: WeatherForecastTable(forecasts: _forecasts),
                                ),
                            ),
                        )
                ],
            )
        );
    }
}

class WeatherHomePage extends StatefulWidget
{
    final String title;

    const WeatherHomePage({super.key, required this.title});

    @override
    WeatherHomePageState createState() => WeatherHomePageState();
}

class WeatherApp extends StatelessWidget
{
    const WeatherApp({super.key});

    @override
    Widget build(BuildContext context)
    {
        initializeDateFormatting('ru');

        return MaterialApp(
            title: 'Прогноз погоды',
            theme: ThemeData(
                useMaterial3: true,
                colorScheme: const ColorScheme.light(
                    onSurface: Colors.cyan,
                    onBackground: Colors.cyan,
                ),
                textTheme: GoogleFonts.manropeTextTheme(),
                appBarTheme: const AppBarTheme(
                    backgroundColor: Colors.cyan,
                    titleTextStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                    ),
                    centerTitle: true,
                ),
            ),
            home: const WeatherHomePage(title: 'Прогноз погоды'),
        );
    }
}

void main()
{
    WeatherApp app = const WeatherApp();
    runApp(app);
}
