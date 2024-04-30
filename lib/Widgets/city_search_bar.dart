import 'package:flutter/material.dart';

class CitySearchBar extends StatelessWidget
{
    final void Function(String) onSubmitted;

    const CitySearchBar({super.key, required this.onSubmitted});

    @override
    Widget build(BuildContext context)
    {
        return Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
            ),
            child: TextField(
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                    hintText: 'Ханты-мансийск',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                ),
                onSubmitted: onSubmitted,
            ),
        );
    }
}
