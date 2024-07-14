import 'package:flutter/material.dart';
import 'package:serial_comunication/view/home_page.dart';

void main() => runApp(
      MaterialApp(
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          dropdownMenuTheme: const DropdownMenuThemeData(
            inputDecorationTheme: InputDecorationTheme(
              constraints: BoxConstraints(maxHeight: 35),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.zero),
              contentPadding: EdgeInsets.all(4),
            ),
            menuStyle: MenuStyle(
              padding: WidgetStatePropertyAll(
                EdgeInsets.all(0),
              ),
            ),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.zero),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
      ),
    );
