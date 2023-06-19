
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/ProductModel.dart';
import '../repositories/ProductRepository.dart';

class ProductViewModel with ChangeNotifier{
  List<QueryDocumentSnapshot<ProductModel>> _data=[];
  List<QueryDocumentSnapshot<ProductModel>> get data => _data;
  Future<void> fetchData() async{
    try{
      final products = await ProductRepository().getAllProduct();
      _data = products;
      notifyListeners();
    } catch(e){
      print(e);
    }
  }
}