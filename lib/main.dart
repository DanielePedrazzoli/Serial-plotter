import 'package:context_menus/context_menus.dart';
import 'package:flutter/material.dart';
import 'package:serial_comunication/view/pages/connect_page.dart';

void main() => runApp(
      ContextMenuOverlay(
        child: MaterialApp(
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
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
          home: const ConnectPage(),
        ),
      ),
    );
