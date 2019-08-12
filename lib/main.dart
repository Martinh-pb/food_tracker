import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';
import 'providers/loggedfood.dart';
import 'providers/foods.dart';

import 'screens/manage_food.dart';
import 'screens/auth_screen.dart';
import 'screens/tab_overview_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/edit_food_screen.dart';

void main() => runApp(FoodTrackerApp());

class FoodTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, LoggedFoods>(
          builder: (ctx, auth, prevloggedFood) => LoggedFoods(
              userId: auth.userId,
              authToken: auth.token,
              items: prevloggedFood == null ? [] : prevloggedFood.items),
        ),
        ChangeNotifierProxyProvider<Auth, Foods>(
          builder: (ctx, auth, prevFood) => Foods(
              auth.token, auth.userId, prevFood == null ? [] : prevFood.items),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          title: 'Food Tracker',
          theme: ThemeData(
            primarySwatch: Colors.lightGreen,
            accentColor: Colors.green,
          ),
          debugShowCheckedModeBanner: false,
          home: auth.isAuth
              ? TabOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, autoLoginSnapshotResult) =>
                      autoLoginSnapshotResult.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ManageFood.routeName: (ctx) => ManageFood(),
            EditFoodScreen.routeName: (ctx) => EditFoodScreen(),
          },
        ),
      ),
    );
  }
}
