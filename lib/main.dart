import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:polymarket_analytics/polymarket_analytic_app.dart';
import 'package:provider/provider.dart';
import 'analytic_provider.dart';



void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) =>
          ChangeNotifierProvider(
            create: (context) => AnalyticsProvider(),
            child: const PolymarketAnalyticsApp(),
          ),
    ),
  );
}

