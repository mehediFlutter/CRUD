import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/product.dart';
import 'package:http/http.dart';
import 'home_screen.dart';

class UpdateProduct extends StatefulWidget {
  final product;
  const UpdateProduct({super.key, required this.product});

  @override
  State<UpdateProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<UpdateProduct> {
  bool inProgress = false;
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _productCodeTEController =
      TextEditingController();
  final TextEditingController _priceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();

  GlobalKey<FormState> _formState = GlobalKey<FormState>();
  @override
  void initState() {
    _nameTEController.text = widget.product.ProductName;
    _productCodeTEController.text = widget.product.ProductCode;
    _priceTEController.text = widget.product.UnitPrice;
    _quantityTEController.text = widget.product.Qty;
    _totalPriceTEController.text = widget.product.TotalPrice;
    _imageTEController.text = widget.product.Img;
    // TODO: implement initState
    super.initState();
  }

  void updateProduct() async {
    inProgress = true;
    setState(() {});
    Response response = await post(
      Uri.parse(
          "https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.product.id}"),
      headers: {'Content-type': 'application/json'},
      body: jsonEncode(
        {
          "Img": _imageTEController.text.trim(),
          "ProductCode": _productCodeTEController.text.trim(),
          "ProductName": _nameTEController.text.trim(),
          "Qty": _quantityTEController.text.trim(),
          "TotalPrice": _totalPriceTEController.text.trim(),
          "UnitPrice": _priceTEController.text.trim(),
        },
      ),
    );
    inProgress = false;
    setState(() {});
    if (response.statusCode == 200) {
      final decodeBody = jsonDecode(response.body);
      if (decodeBody['status'] == 'success') {
        if (mounted) {
          _imageTEController.clear();
          _nameTEController.clear();
          _priceTEController.clear();
          _quantityTEController.clear();
          _productCodeTEController.clear();
          _totalPriceTEController.clear();
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Product is  added .")));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Product is not added . Try Again")));
        }
      }
    }
  }

  final size = SizedBox(
    height: 10,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Product"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formState,
          child: Column(
            children: [
              TextFormField(
                controller: _nameTEController,
                decoration: InputDecoration(hintText: "Product Name"),
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return "Enter Your Product Name";
                  }
                  return null;
                },
              ),
              size,
              TextFormField(
                controller: _productCodeTEController,
                decoration: InputDecoration(hintText: "Product Code"),
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return "Enter Your Product Code";
                  }
                  return null;
                },
              ),
              size,
              TextFormField(
                controller: _priceTEController,
                decoration: InputDecoration(hintText: "Price"),
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return "Enter Your Product Price";
                  }
                  return null;
                },
              ),
              size,
              TextFormField(
                controller: _quantityTEController,
                decoration: InputDecoration(hintText: "Quantity"),
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return "Enter Your Product Quantity";
                  }
                  return null;
                },
              ),
              size,
              TextFormField(
                controller: _totalPriceTEController,
                decoration: InputDecoration(hintText: "Total Price"),
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return "Enter Total Price";
                  }
                  return null;
                },
              ),
              size,
              TextFormField(
                controller: _imageTEController,
                decoration: InputDecoration(hintText: "Image"),
                validator: (String? value) {
                  if (value?.isEmpty ?? true) {
                    return "Enter Your Product Image";
                  }
                  return null;
                },
              ),
              size,
              SizedBox(
                  width: double.infinity,
                  child: inProgress
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formState.currentState!.validate()) {
                              updateProduct();
                            }
                          },
                          child: Text("Update"))),
            ],
          ),
        ),
      ),
    );
  }
}
