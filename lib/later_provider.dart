import 'package:flutter/material.dart';

class LaterProvider extends ChangeNotifier{
  final List<Map<String,dynamic>> list=[];
  void addNews(Map<String,dynamic> news){
    list.add(news);
  }
  void removeNews(Map<String,dynamic> news){
    list.remove(news);
  }
}