

import 'package:anna_bazar/models/ProductModel.dart';
import 'package:anna_bazar/repositories/ProductRepository.dart';
import 'package:flutter/material.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key});

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  Future<void> updateProduct() async {
    try{
      final data= ProductModel(
        name :name.text,
        price :double.parse(price.text)
      );
      await ProductRepository().updateProduct(id.toString(), data);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data Saved")));
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }
  String? id;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if(arguments!= null){
        setState(() {
          id = arguments.toString();
        });
        fillData(arguments.toString());
      }
    });

    // TODO: implement initState
    super.initState();
  }
  void fillData(String id) async {
    final response = await ProductRepository().getOneProduct(id);
    name.text = response!.name.toString();
    price.text = response.price.toString();
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
            updateProduct();
          }, child: Text("Save Product"))
        ],
      ),
    );
  }
}
