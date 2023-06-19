import 'package:anna_bazar/repositories/ProductRepository.dart';
import 'package:anna_bazar/viewmodels/product_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/ProductModel.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key}) : super(key: key);

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() async {
    try {
      await _auth.signOut();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logged out")));
    } on FirebaseAuthException catch (err) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(err.message.toString()),
        backgroundColor: Colors.red,
      ));
    }
  }
  void fetchData() async{
    try{
      await productViewModel.fetchData();
    } catch(e){
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())));
    }
  }
  late ProductViewModel productViewModel;
  @override
  void initState(){
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      productViewModel= Provider.of<ProductViewModel>(context, listen: false);
      fetchData();
    });
    super.initState();
  }
  void deleteProduct(String id) async {
    try{
      await ProductRepository().deleteProduct(id);
      fetchData();
    }catch(e){
      print(e);
    }
  }
  void showDeleteDialog(String id){
    showDialog(context: context, builder: (context) => AlertDialog(
      title: Text("Are you sure you want to delete"),
      actions: [
        ElevatedButton(onPressed: (){
          deleteProduct(id);
          Navigator.of(context).pop();
        }, child: Text("Delete")),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    final data = context.watch<ProductViewModel>().data;

    return Consumer<ProductViewModel>(
      builder: (context, productVM, child) {

        return Scaffold(
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
              Navigator.of(context).pushNamed("/add-screen");
            },
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        signOut();
                      },
                      child: Text("Sign Out")),
                  ...productVM.data.map((e) => Card(
                    child: Column(
                      children: [
                        Text(e.data().name.toString()),
                        Text(e.data().price.toString()),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(onPressed: (){
                              Navigator.of(context).pushNamed("/update-screen", arguments: e.id);
                            }, icon: Icon(Icons.edit)),
                            IconButton(onPressed: (){
                              showDeleteDialog(e.id);
                            }, icon: Icon(Icons.delete)),
                          ],
                        ),
                      ],
                    ),))
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}