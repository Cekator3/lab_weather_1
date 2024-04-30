import 'package:flutter/material.dart';

/// A button for fetching weather forecasts based on geolocation.
class GeolocationButton extends StatelessWidget
{
    final void Function() onPressed;

    const GeolocationButton({super.key, required this.onPressed});

    @override
    Widget build(BuildContext context)
    {
        return IconButton(
            onPressed: onPressed,
            icon: const Icon(Icons.location_on)
        );
    }
}
