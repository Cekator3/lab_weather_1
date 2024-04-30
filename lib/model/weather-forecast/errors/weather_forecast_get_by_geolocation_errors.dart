// ignore_for_file: constant_identifier_names, file_names

import 'package:lab_weather_1/errors.dart';

/// A subsystem for storing errors that occurred during
/// an attempt to get weather forecasts by query
class WeatherForecastGetByGeolocationErrors extends Errors
{
    static const ERROR_INTERNET_CONNECTION_MISSING = 1;
    static const ERROR_INTERNAL = 1 << 2;
    static const ERROR_CITY_NOT_FOUND = 1 << 3;
    static const ERROR_GEOLOCATION_NOT_SUPPORTED_ON_DEVICE = 1 << 4;
    static const ERROR_GEOLOCATION_SERVICE_DISABLED = 1 << 5;
    static const ERROR_GEOLOCATION_PERMISSION_DENIED = 1 << 6;
    static const ERROR_GEOLOCATION_PERMISSION_DENIED_FOREVER = 1 << 7;

    /// Returns `true` if occurred an error because the device not supporting geolocation
    bool isDeviceNotSupportGeolocation()
    {
       return has(ERROR_GEOLOCATION_NOT_SUPPORTED_ON_DEVICE);
    }

    /// Returns `true` if occurred an error because the internet connection is missing
    bool isInternetConnectionMissing()
    {
        return has(ERROR_INTERNET_CONNECTION_MISSING);
    }

    /// Returns `true` if occurred an internal error
    bool isInternalErrorOcurred()
    {
        return has(ERROR_INTERNAL);
    }

    /// Returns `true` if occurred an error because the city was not found
    bool isCityNotFound()
    {
        return has(ERROR_CITY_NOT_FOUND);
    }

    /// Returns `true` if occurred an error because the geolocation service is disabled
    bool isGeolocationServiceDisabled()
    {
        return has(ERROR_GEOLOCATION_SERVICE_DISABLED);
    }

    /// Returns `true` if occurred an error because the geolocation permissions are denied
    bool isGeolocationPermissionDenied()
    {
        return has(ERROR_GEOLOCATION_PERMISSION_DENIED) ||
               has(ERROR_GEOLOCATION_PERMISSION_DENIED_FOREVER);
    }

    /// Returns `true` if occurred an error because the geolocation permissions are denied forever
    bool isGeolocationPermissionDeniedForever()
    {
        return has(ERROR_GEOLOCATION_PERMISSION_DENIED_FOREVER);
    }
}
