import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'loggedfood.dart';
import 'secrets.dart';

class FoodItem {
  String id;
  String title;
  double carbs;
  double protein;
  double fat;
  double fiber;
  double sugar;
  double portionSize;
  PortionType portionType;

  String barCode;

  FoodItem({
    @required this.id,
    @required this.title,
    @required this.carbs,
    @required this.protein,
    @required this.fat,
    @required this.fiber,
    @required this.sugar,
    @required this.portionSize,
    @required this.portionType,
    this.barCode,
  });
}

class Foods with ChangeNotifier {
  String _authToken;
  String _userId;

  List<FoodItem> _items = [];

  Foods(this._authToken, this._userId, this._items);

  Future<void> fetchAndSetFoods() async {
    final String url = Secrets.firebaseUrl + 'foods.json?auth=$_authToken';
    try {
      var response = await http.get(url);
      var data = json.decode(response.body) as Map<String, dynamic>;

      if (data == null) {
        _items = [];
      } else {
        List<FoodItem> retrievedFoods = [];
        print(data);
        
        data.forEach((key, value) {
        retrievedFoods.add(
          FoodItem(
            id: key,
            title: value['title'],
            carbs: value['carbs'],
            barCode: value['barcode'],
            fat: value['fat'],
            fiber: value['fiber'],
            protein: value['protein'],
            sugar: value['sugar'],
            portionSize: value['portionSize'],
            portionType:  (value['portionType'] == 0 ? PortionType.Gram : PortionType.Ml),
          ),
        );
      });
        
        
        _items = retrievedFoods;
      }

      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  List<FoodItem> get items {
    return [..._items];
  }

  Future<void> addFood(FoodItem newItem) async {
    final url = Secrets.firebaseUrl + 'foods.json?auth=$_authToken';

    try {
      var response = await http.post(
        url,
        body: json.encode(
          {
            'title': newItem.title,
            'barCode': newItem.barCode,
            'carbs': newItem.carbs,
            'fat': newItem.fat,
            'fiber': newItem.fiber,
            'portionSize': newItem.portionSize,
            'portionType': newItem.portionType.index,
            'protein': newItem.protein,
            'sugar': newItem.sugar,
            'createdBy': _userId
          },
        ),
      );

      FoodItem p = FoodItem(
          id: json.decode(response.body)['name'],
          title: newItem.title,
          barCode: newItem.barCode,
          carbs: newItem.carbs,
          fat: newItem.fat,
          fiber: newItem.fiber,
          portionSize: newItem.portionSize,
          portionType: newItem.portionType,
          protein: newItem.protein,
          sugar: newItem.sugar);

      _items.add(p);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
