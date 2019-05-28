import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'product_edit.dart';
import 'package:first_app/scoped_model/products.dart';

class ProductListPage extends StatelessWidget {
  Widget _buildEditButton(BuildContext context, int index, ProductsModel model) {
    return IconButton(
          onPressed: () {
            model.selectProduct(index);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) {
                  return ProductEditPages();
                },
              ),
            );
          },
          icon: Icon(Icons.edit),
        );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.selectProduct(index);
                  model.deleteProducts();
                }
              },
              background: Container(
                color: Colors.red,
              ),
              key: Key(model.products[index].title),
              child: Column(
                children: <Widget>[
                  ListTile(
                    leading: CircleAvatar(
                        backgroundImage: AssetImage(model.products[index].image)),
                    title: Text(model.products[index].title),
                    subtitle: Text('\$${model.products[index].price.toString()}'),
                    trailing: _buildEditButton(context, index, model),
                  ),
                  Divider(),
                ],
              ),
            );
          },
          itemCount: model.products.length,
        );
      },
    );
  }
}
