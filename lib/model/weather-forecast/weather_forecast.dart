class WeatherForecast
{
    final num _temperature;
    final int _humidity;
    final String _icon;
    final DateTime _date;

    WeatherForecast(this._temperature, this._humidity, this._icon, this._date);

    /// Returns temperature in celsius
    num getTemperature()
    {
        return _temperature - 273;
    }

    /// Returns humidity in percentages
    int getHumidity()
    {
        return _humidity;
    }

    DateTime getDate()
    {
        return _date;
    }

    String getIconUrl()
    {
        return _icon;
    }
}
