import 'package:flutter/material.dart';

/// A subsystem for storing errors that may occur during a function call.
// ignore: camel_case_types
abstract class Errors
{
	int _errors = 0;

	/// Adds [error]
    void add(int error)
    {
		_errors |= error;
    }

	/// Returns `true` if any error occurred
	bool hasAny()
	{
		return _errors != 0;
	}

	@protected
	bool has(int error)
	{
		return (_errors & error) != 0;
	}
}
