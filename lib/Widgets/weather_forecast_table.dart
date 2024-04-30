import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lab_weather_1/model/weather-forecast/weather_forecast.dart';

class WeatherForecastTable extends StatelessWidget
{
    final List<WeatherForecast> forecasts;

    const WeatherForecastTable({super.key, required this.forecasts});

    DataColumn _getHeaderCell(String label)
    {
        return DataColumn(
            label: Expanded(
                child: Text(
                    label,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 12,
                    ),
                    textAlign: TextAlign.center,
                ),
            ),
        );
    }

    /// Generates table's header
    List<DataColumn> _getHeader()
    {
        return [
            _getHeaderCell('Дата'),
            _getHeaderCell('Температура (°C)'),
            _getHeaderCell('Влажность (%)'),
            _getHeaderCell(''),
        ];
    }

    DataCell _getBodyCell(String label)
    {
        return DataCell(
            Text(
                label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                ),
                textAlign: TextAlign.center,
            ),
        );
    }

    /// Generates table's body
    List<DataRow> _getBody()
    {
        List<DataRow> result = [];

        for (var forecast in forecasts)
        {
            result.add(DataRow(cells: [
                _getBodyCell(DateFormat('dd.MM.yyyy HH:mm', 'ru').format(forecast.getDate())),
                _getBodyCell(forecast.getTemperature().toStringAsFixed(1)),
                _getBodyCell('${forecast.getHumidity()}'),
                DataCell(Image.network(forecast.getIconUrl(), width: 50, height: 50)),
            ]));
        }

        return result;
    }

      @override
    Widget build(BuildContext context)
    {
        return SingleChildScrollView(
            child: DataTable(
                horizontalMargin: 5,
                columnSpacing: 5,
                columns: _getHeader(),
                rows: _getBody(),
            ),
        );
    }
}
