import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:polymarket_analytics/market_trending.dart';
import 'package:polymarket_analytics/trader.dart';
import 'package:polymarket_analytics/sort_criteria.dart';
import 'package:polymarket_analytics/position.dart';
import 'dart:async';

import 'mock_polymarket_api_service.dart';

const String _polymarketBaseUrl = 'https://gamma-api.polymarket.com';

class AnalyticsProvider with ChangeNotifier {
  bool isLoading = true;
  List<Position> positions = [];
  SortCriteria sortCriteria = SortCriteria.pnlValue;
  String? walletAddress;
  List<Trader> topTraders = [];
  List<MarketTrending> trendingMarkets = [];
  bool _isDisposed = false;

  AnalyticsProvider() {
    _initializeData();
  }

  void _initializeData() async {
    await Future.wait([
      _fetchTopTraders(),
      _fetchTrendingMarkets(),
    ]);

    await Future.delayed(const Duration(milliseconds: 100));
    positions = MockPolymarketApiService.getMockPositions();

    isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  // --- Portfolio Management ---

  void setWalletAddress(String address) {
    if (address.isNotEmpty && address != walletAddress) {
      walletAddress = address;
      fetchAllAnalytics();
    } else if (address.isEmpty) {
      walletAddress = null;
      positions = [];
      notifyListeners();
    }
  }

  // ... (Core Portfolio Calculations are unchanged) ...

  double get totalInvestedCapital =>
      positions.fold(0.0, (sum, pos) => sum + pos.totalInvested);

  Map<String, double> get exposureByCategories {
    final Map<String, double> exposure = {};
    for (var pos in positions) {
      exposure.update(
        pos.category,
            (existingValue) => existingValue + pos.totalInvested,
        ifAbsent: () => pos.totalInvested,
      );
    }
    return exposure;
  }

  double get totalPortfolioPnl =>
      positions.fold(0.0, (sum, pos) => sum + pos.unrealizedPnlDollar);

  List<Position> get sortedPositions {
    final list = List<Position>.from(positions);
    list.sort((a, b) {
      if (sortCriteria == SortCriteria.pnlValue) {
        return b.unrealizedPnlDollar.compareTo(a.unrealizedPnlDollar);
      }
      return a.resolutionDate.compareTo(b.resolutionDate);
    });
    return list;
  }

  void setSortCriteria(SortCriteria newCriteria) {
    if (newCriteria != sortCriteria) {
      sortCriteria = newCriteria;
      notifyListeners();
    }
  }

  // --- API/Data Fetching Methods ---

// analytic_provider.dart

  Future<void> _fetchUserPositions(String address) async {
    final url = Uri.parse('$_polymarketBaseUrl/user/$address/positions');
    bool apiSuccess = false;
    // Assume positions will be empty unless successfully populated
    List<Position> fetchedPositions = [];

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));
      debugPrint('Polymarket API Status for $address: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Success: Parse and set data
        if (response.body.isNotEmpty && response.body.trim() != '[]') {
          final List<dynamic> jsonList = json.decode(response.body);
          fetchedPositions = jsonList.map((json) => Position.fromJson(json)).toList();
          apiSuccess = true;
        } else {
          debugPrint('API returned 200 but no positions for $address.');
          apiSuccess = true; // Still a successful outcome (empty list)
        }
      } else if (response.statusCode == 404) {
        // Explicitly handle 404 (No resource/No positions)
        debugPrint('API returned 404: Wallet has no positions or endpoint is wrong.');
        // Do NOT set apiSuccess = true; let it proceed to fallback.
      } else {
        debugPrint('API call failed with status: ${response.statusCode}');
      }
    } on TimeoutException {
      debugPrint('API Request timed out after 15s.');
    } catch (e) {
      debugPrint('Network/Decoding Error: $e');
    }

    // --- FALLBACK LOGIC (Now handles all failures by showing empty state) ---
    if (!apiSuccess) {
      debugPrint('--- SHOWING EMPTY STATE (API Failure/No Positions) ---');
      // Do nothing here; fetchedPositions remains [], and the UI will show the message.
    }

    // Set the positions state and let the UI update
    positions = fetchedPositions;
  }

  // --- Other Mock Fetchers ---

  Future<void> _fetchTopTraders() async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      debugPrint('Error fetching mock traders: $e');
    }
    notifyListeners();
  }



  Future<void> _fetchTrendingMarkets() async {
    bool apiSuccess = false;
    List<MarketTrending> fetchedMarkets = [];


    final url = Uri.parse('$_polymarketBaseUrl/markets?limit=20&order=score&ascending=false');

    try {
      final response = await http.get(url).timeout(const Duration(seconds: 15));
      debugPrint('Trending Markets API Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final List<dynamic> jsonList = json.decode(response.body);


          fetchedMarkets = jsonList.map((json) => MarketTrending.fromJson(json)).toList();
          apiSuccess = true;
        }
      } else {
        debugPrint('Trending Markets API call failed with status: ${response.statusCode}');
      }
    } on TimeoutException {
      debugPrint('Trending Markets API Request timed out.');
    } catch (e) {
      debugPrint('Trending Markets Network/Decoding or JSON Error: $e');
    }


    if (!apiSuccess) {
      debugPrint('--- FALLBACK TO MOCK DATA for Trending Markets ---');
      await Future.delayed(const Duration(milliseconds: 500));
      // fetchedMarkets = MockPolymarketApiService.getMockTrendingMarkets();
    }

    trendingMarkets = fetchedMarkets;
    notifyListeners();
  }

  // --- Combined Fetcher (Used AFTER wallet address is entered) ---

  Future<void> fetchAllAnalytics() async {
    isLoading = true;
    notifyListeners();

    if (walletAddress == null) {
      isLoading = false;
      notifyListeners();
      return;
    }

    try {
      await _fetchUserPositions(walletAddress!);
    } catch (e) {
      debugPrint('Error caught in fetchAllAnalytics: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}