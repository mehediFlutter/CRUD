import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/add%20_new_product_screen.dart';
import 'package:flutter_application_1/product.dart';
import 'package:flutter_application_1/update_product.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool inProgress = true;
  List<Product> products = [
    Product("id", "ProductNameee", "ProductCode", "Img", "UnitPrice", "Qty",
        "TotalPrice", "CreatedDate")
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("CAll API");
    getProduct();
  }

  void getProduct() async {
    inProgress = true;
    Response response =
        await get(Uri.parse("https://crud.teamrabbil.com/api/v1/ReadProduct"));
    print(response.statusCode);
    final Map<String, dynamic> decodeResponse = jsonDecode(response.body);
    print(decodeResponse['data'].length);
    if (response.statusCode == 200 && decodeResponse['status'] == 'success') {
      print("Condition success");
      for (var e in decodeResponse['data']) {
        print("Loop success");
        products.add(Product.toJson(e));
        setState(() {});
      }
    }
    inProgress = false;
    setState(() {});
  }

  void deleteProduct(String id) async {
    inProgress = true;
    Response response = await get(
        Uri.parse("https://crud.teamrabbil.com/api/v1/DeleteProduct/$id"));
    print(response.statusCode);
    final Map<String, dynamic> decodeResponse = jsonDecode(response.body);
    print(decodeResponse['data'].length);
    if (response.statusCode == 200 && decodeResponse['status'] == 'success') {
      products.clear();
      getProduct();
    } else {
      inProgress = false;

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CRUD"),
        actions: [
          IconButton(
              onPressed: () {
                products.clear();
                getProduct();
              },
              icon: Icon(Icons.refresh))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddNewProduct()));
        },
        child: Icon(Icons.add),
      ),
      body: inProgress
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.separated(
              itemCount: products.length,
              itemBuilder: ((context, index) {
                return ListTile(
                  onLongPress: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            titlePadding: EdgeInsets.only(left: 16),
                            contentPadding:
                                EdgeInsets.only(left: 8, right: 8, bottom: 8),
                            title: Row(
                              children: [
                                Text("Choose an action"),
                                Spacer(),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.close))
                              ],
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  onTap: () {
                                    Navigator.pop(context);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UpdateProduct(
                                                product: products[index],
                                              )),
                                    );
                                  },
                                  leading: Icon(Icons.edit),
                                  title: Text("Edit"),
                                ),
                                ListTile(
                                  onTap: () {
                                    deleteProduct(products[index].id);
                                    Navigator.pop(context);
                                  },
                                  leading: Icon(Icons.delete),
                                  title: Text("Delete"),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  leading: Image.network(
                    products[index].Img,
                    errorBuilder: (_, __, ___) {
                      return Icon(Icons.image);
                    },
                  ),
                  title: Text(products[index].ProductName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Product Code:${products[index].ProductCode}"),
                      Text("Total Price:${products[index].TotalPrice}"),
                      Text("Available Unit:${products[index].Qty}"),
                    ],
                  ),
                  trailing: Text("Unit Price: ${products[index].UnitPrice}"),
                );
              }),
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
            ),
    );
  }
}
