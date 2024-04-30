// ignore_for_file: constant_identifier_names, file_names

import 'package:lab_weather_1/errors.dart';

/// A subsystem for storing errors that occurred during
/// an attempt to get weather forecasts by query
class WeatherForecastGetByQueryErrors extends Errors
{
    static const ERROR_INTERNET_CONNECTION_MISSING = 1;
    static const ERROR_INTERNAL = 1 << 2;
    static const ERROR_CITY_NOT_FOUND = 1 << 3;

    /// Returns `true` if ocurred an error because the internet connection is missing
    bool isInternetConnectionMissing()
    {
        return has(ERROR_INTERNET_CONNECTION_MISSING);
    }

    /// Returns `true` if ocurred an internal error
    bool isInternalErrorOcurred()
    {
        return has(ERROR_INTERNAL);
    }

    /// Returns `true` if ocurred an error because the city was not found
    bool isCityNotFound()
    {
        return has(ERROR_CITY_NOT_FOUND);
    }
}
