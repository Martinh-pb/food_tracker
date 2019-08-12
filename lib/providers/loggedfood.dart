import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'secrets.dart';

enum MealType {
  BreakFast,
  Lunch,
  Diner,
  Snack,
}

enum PortionType {
  Gram,
  Ml,
}

class LoggedFood {
  int id;
  DateTime dateTime;
  MealType mealType;
  String title;
  double carbs;
  double protein;
  double fat;
  double fiber;
  double sugar;
  double portionSize;
  PortionType portionType;

  LoggedFood({
    @required this.id,
    @required this.dateTime,
    @required this.mealType,
    @required this.title,
    @required this.carbs,
    @required this.protein,
    @required this.fat,
    @required this.fiber,
    @required this.sugar,
    @required this.portionSize,
    @required this.portionType,
  });
}

class LoggedFoods with ChangeNotifier {
  final String userId;
  final String authToken;

  List<LoggedFood> items = [];

  LoggedFoods({@required this.userId, @required this.authToken, this.items});

  Future<void> fetchAndSetLoggedFoods() async {
    final String url =
        Secrets.firebaseUrl + '$userId/loggedfoods.json?auth=$authToken';

    try {
      var response = await http.get(url);
      var data = json.decode(response.body);

      if (data == null) {
        items = [];
      } else {
        List<LoggedFood> retrievedData = [];
        print(retrievedData);
        items = retrievedData;
      }
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
