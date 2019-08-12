import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/foods.dart';
import '../providers/loggedfood.dart';

class EditFoodScreen extends StatefulWidget {
  static const routeName = '/editfood';
  @override
  _EditFoodScreenState createState() => _EditFoodScreenState();
}

class _EditFoodScreenState extends State<EditFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isLoading = false;
  var _mustInit = true;

  var _editFood = FoodItem(
    id: null,
    carbs: 0,
    fiber: 0,
    fat: 0,
    protein: 0,
    portionSize: 0,
    portionType: PortionType.Gram,
    sugar: 0,
    title: '',
    barCode: '',
  );

  Future<void> _save() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();

    try {
      if (_editFood.id == null) {
        await Provider.of<Foods>(context).addFood(_editFood);
      }
    } catch (error) {
      _showErrorDialog(context, error.toString());
    }
  }

  void _showErrorDialog(context, error) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Error"),
        content: Text(error),
        actions: <Widget>[
          RaisedButton(
            child: Text("OK"),
            textColor: Theme.of(context).primaryTextTheme.button.color,
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  void didChangeDependencies() {
    if (_mustInit) {
      String id = ModalRoute.of(context).settings.arguments as String;
      _mustInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit food"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _save,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(8),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Name",
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Name may not be empty.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editFood = FoodItem(
                            id: _editFood.id,
                            carbs: _editFood.carbs,
                            fiber: _editFood.fiber,
                            fat: _editFood.fat,
                            protein: _editFood.protein,
                            portionSize: _editFood.portionSize,
                            portionType: _editFood.portionType,
                            sugar: _editFood.sugar,
                            title: value,
                            barCode: _editFood.barCode);
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: "Portion size"),
                      keyboardType:
                          TextInputType.numberWithOptions(decimal: true),
                      validator: (value) {
                        if (value.isEmpty || double.tryParse(value) == null) {
                          return 'Portion size may not be empty.';
                        }
                        double p = double.parse(value);
                        if (p <= 0) {
                          return 'Portion size must be greater than 0.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editFood = FoodItem(
                            id: _editFood.id,
                            carbs: _editFood.carbs,
                            fiber: _editFood.fiber,
                            fat: _editFood.fat,
                            protein: _editFood.protein,
                            portionSize: double.parse(value),
                            portionType: _editFood.portionType,
                            sugar: _editFood.sugar,
                            title: _editFood.title,
                            barCode: _editFood.barCode);
                      },
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
