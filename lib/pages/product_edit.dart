import 'package:flutter/material.dart';

import 'package:first_app/models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:first_app/scoped_model/products.dart';

class ProductEditPages extends StatefulWidget {
  _ProductEditPagesState createState() => _ProductEditPagesState();
}

class _ProductEditPagesState extends State<ProductEditPages> {
  final Map<String, dynamic> _formData = {
    "title": null,
    "description": null,
    "price": null,
    "image": 'assets/food.jpg'
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget _buildTitleTextField(Product product) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        validator: (String value) {
          if (value.isEmpty || value.length < 5) {
            return 'Title is required and should be 5+ characters long!';
          }
        },
        onSaved: (String value) {
          _formData['title'] = value;
        },
        initialValue: product == null ? '' : product.title,
        decoration: InputDecoration(
            labelText: 'Product Title',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      ),
    );
  }

  Widget _buildPriceTextField(Product product) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        validator: (String value) {
          if (value.isEmpty ||
              !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
            return 'Price is required and should be a number!';
          }
        },
        onSaved: (String value) {
          _formData['price'] = double.parse(value);
        },
        keyboardType: TextInputType.numberWithOptions(),
        initialValue: product == null ? '' : product.price.toString(),
        decoration: InputDecoration(
            labelText: 'Product Price',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      ),
    );
  }

  Widget _buildDescriptionTextField(Product product) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: TextFormField(
        validator: (String value) {
          if (value.isEmpty || value.length < 10) {
            return 'Description is required and should be 10+ characters long!';
          }
        },
        onSaved: (String value) {
          _formData['description'] = value;
        },
        maxLines: 4,
        initialValue: product == null ? '' : product.description,
        decoration: InputDecoration(
            labelText: 'Product Description',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        return RaisedButton(
          textColor: Colors.white,
          child: Text(
            'Save',
            style: TextStyle(fontSize: 20.0),
          ),
          onPressed: () => _submitForm(
                model.addProducts,
                model.updateProduct,
                model.selectedProductIndex,
              ),
        );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Container(
        margin: EdgeInsets.all(10.0),
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: targetPadding / 3),
            children: <Widget>[
              _buildTitleTextField(product),
              _buildDescriptionTextField(product),
              _buildPriceTextField(product),
              SizedBox(height: 5.0),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm(Function addProduct, Function updateProduct,
      [int selectedProductIndex]) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (selectedProductIndex == null) {
        addProduct(
          Product(
              title: _formData['title'],
              description: _formData['description'],
              price: _formData['price'],
              image: _formData['image']),
        );
      } else {
        updateProduct(
          Product(
              title: _formData['title'],
              description: _formData['description'],
              price: _formData['price'],
              image: _formData['image']),
        );
      }
      Navigator.pushReplacementNamed(context, '/products');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<ProductsModel>(
      builder: (BuildContext context, Widget child, ProductsModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedProduct);
        return model.selectedProductIndex == null
            ? pageContent
            : Scaffold(
                appBar: AppBar(
                  title: Text('Edit Product'),
                ),
                body: pageContent,
              );
      },
    );
  }
}
