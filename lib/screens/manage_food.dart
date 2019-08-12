import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/main_drawer.dart';
import '../providers/foods.dart';
import '../screens/edit_food_screen.dart';

class ManageFood extends StatelessWidget {
  static const routeName = "/manage_food";

  Future<void> refreshFoods(BuildContext context) async {
    await Provider.of<Foods>(context, listen: false).fetchAndSetFoods();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Food'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditFoodScreen.routeName);
            },
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: FutureBuilder(
        future: refreshFoods(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => refreshFoods(context),
                    child: Consumer<Foods>(
                      builder: (ctx, foods, _) => Padding(
                        padding: EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: foods.items.length,
                          itemBuilder: (ctx, index) => Column(children: [
                            ListTile(
                              title: Text(
                                foods.items[index].title,
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      EditFoodScreen.routeName,
                                      arguments: foods.items[index].id);
                                },
                              ),
                            ),
                            Divider(),
                          ]),
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
