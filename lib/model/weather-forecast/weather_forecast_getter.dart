// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:lab_weather_1/model/weather-forecast/errors/weather_forecast_get_by_geolocation_errors.dart';
import 'package:lab_weather_1/model/weather-forecast/errors/weather_forecast_get_by_query_errors.dart';
import 'package:lab_weather_1/model/weather-forecast/weather_forecast.dart';

class WeatherForecastGetter
{
    final String _apiKey = 'b28eda2584dd5a69b0852a1be14dc209';
    final String _baseUrl = 'https://api.openweathermap.org/data/2.5/forecast';

    /// Checks if device is connected to the internet
    Future<bool> _isConnectedToInternet() async
    {
        return await InternetConnection().hasInternetAccess;
    }

    /// Retrieves the list of `WeatherForecast` from the HTTP-response
    List<WeatherForecast> _getResults(http.Response response)
    {
        var weatherForecastsJson = json.decode(response.body)['list'];

        List<WeatherForecast> result = [];
        for (var forecastJson in weatherForecastsJson)
        {
            num temperature = forecastJson['main']['temp'];
            int humidity = forecastJson['main']['humidity'];
            String icon = 'http://openweathermap.org/img/wn/${forecastJson['weather'][0]['icon']}.png';
            DateTime date = DateTime.fromMillisecondsSinceEpoch(forecastJson['dt'] * 1000);

            WeatherForecast forecast = WeatherForecast(temperature, humidity, icon, date);
            result.add(forecast);
        }

        return result;
    }

    /// Returns weather forecasts by the place provided in query
    Future<List<WeatherForecast>> getByQuery(String query,
                                             WeatherForecastGetByQueryErrors errors) async
    {
        if (! (await _isConnectedToInternet()))
        {
            errors.add(WeatherForecastGetByQueryErrors.ERROR_INTERNET_CONNECTION_MISSING);
            return [];
        }

        http.Response response = await http.get(Uri.parse('$_baseUrl?q=$query&appid=$_apiKey'));

        switch (response.statusCode)
        {
            case 200:
                return _getResults(response);
            case 404:
                errors.add(WeatherForecastGetByQueryErrors.ERROR_CITY_NOT_FOUND);
                return [];
            default:
                errors.add(WeatherForecastGetByQueryErrors.ERROR_INTERNAL);
                return [];
        }
    }

    Future<bool> _isDeviceSupportsGeolocation() async
    {
        try
        {
            await Geolocator.isLocationServiceEnabled();
            return true;
        }
        catch (e)
        {
            return false;
        }
    }

    Future<Position?> _getUserGeolocation(WeatherForecastGetByGeolocationErrors errors) async
    {
        bool serviceEnabled;
        LocationPermission permission;

        // Test if location services are enabled.
        serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (! serviceEnabled)
        {
            errors.add(WeatherForecastGetByGeolocationErrors.ERROR_GEOLOCATION_SERVICE_DISABLED);
            return null;
        }

        permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied)
        {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied)
            {
                errors.add(WeatherForecastGetByGeolocationErrors.ERROR_GEOLOCATION_PERMISSION_DENIED);
                return null;
            }
        }

        if (permission == LocationPermission.deniedForever)
        {
            errors.add(WeatherForecastGetByGeolocationErrors.ERROR_GEOLOCATION_PERMISSION_DENIED_FOREVER);
            return null;
        }
        return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    }

    /// Returns weather forecasts by the user's geolocation.
    Future<List<WeatherForecast>> getByGeolocation(WeatherForecastGetByGeolocationErrors errors) async
    {
        if (! (await _isDeviceSupportsGeolocation()))
        {
            errors.add(WeatherForecastGetByGeolocationErrors.ERROR_GEOLOCATION_NOT_SUPPORTED_ON_DEVICE);
            return [];
        }

        if (! (await _isConnectedToInternet()))
        {
            errors.add(WeatherForecastGetByGeolocationErrors.ERROR_INTERNET_CONNECTION_MISSING);
            return [];
        }

        Position? userPosition = await _getUserGeolocation(errors);
        if (errors.hasAny() || (userPosition == null))
            return [];

        http.Response response = await http.get(Uri.parse('$_baseUrl?lat=${userPosition.latitude}&lon=${userPosition.longitude}&&appid=$_apiKey'));

        switch (response.statusCode)
        {
            case 200:
                return _getResults(response);
            case 404:
                errors.add(WeatherForecastGetByQueryErrors.ERROR_CITY_NOT_FOUND);
                return [];
            default:
                errors.add(WeatherForecastGetByQueryErrors.ERROR_INTERNAL);
                return [];
        }
    }
}
