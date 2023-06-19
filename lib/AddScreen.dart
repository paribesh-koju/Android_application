

import 'package:anna_bazar/models/ProductModel.dart';
import 'package:anna_bazar/repositories/ProductRepository.dart';
import 'package:flutter/material.dart';

class AddScreen extends StatefulWidget {
  const AddScreen({super.key});

  @override
  State<AddScreen> createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  Future<void> saveProduct() async {
    try{
      final data = ProductModel(
        name: name.text,
        price: double.parse(price.text)
      );
      await ProductRepository().createProduct(data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Saved")));
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add a product")),
      body: Column(
        children: [
          TextFormField(controller: name,),
          TextFormField(controller: price,),
          ElevatedButton(onPressed: (){
            saveProduct();
          }, child: Text("Save Product"))
        ],
      ),
    );
  }
}
