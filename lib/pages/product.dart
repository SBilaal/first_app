import 'package:first_app/models/product.dart';
import 'package:first_app/scoped_model/products.dart';
import 'package:first_app/widgets/products/address_tag.dart';
import 'package:first_app/widgets/ui_elements/title_default.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:scoped_model/scoped_model.dart';

class ProductPage extends StatelessWidget {
  final int productIndex;

  ProductPage(this.productIndex);
  Widget _buildTitlePrice(double productPrice, String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TitleDefault(title),
        SizedBox(
          width: 10.0,
        ),
        Text(
          '\$$productPrice',
          style: TextStyle(fontSize: 20.0, color: Colors.black),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: ScopedModelDescendant<ProductsModel>(
        builder: (BuildContext contect, Widget child, ProductsModel model) {
          final Product product = model.products[productIndex];
          return Scaffold(
            appBar: AppBar(
              title: Text(product.title),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image.asset(product.image),
                Container(
                  margin: EdgeInsets.only(top: 10.0),
                  child: Column(
                    children: <Widget>[
                      _buildTitlePrice(product.price, product.title),
                      SizedBox(
                        height: 10.0,
                      ),
                      AddressTag('Jakande Estate, Ejigbo Lagos'),
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        child: Text(
                          product.description,
                          style:
                              TextStyle(fontSize: 20.0, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
