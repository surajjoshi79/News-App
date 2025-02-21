import 'package:flutter/material.dart';
import 'package:news_app/home_ui.dart';
import 'package:news_app/later_provider.dart';
import 'package:news_app/later_ui.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentPage=0;
  final uiList=[HomeUi(),LaterUi()];
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>LaterProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light(useMaterial3: true),
        home: Scaffold(
          body: IndexedStack(
            index: currentPage,
            children: uiList,
          ),
          bottomNavigationBar: BottomNavigationBar(
              onTap: (value){
                setState(() {
                  currentPage=value;
                });
              },
              currentIndex: currentPage,
              items:[
                BottomNavigationBarItem(
                  label: "Home",
                  icon: Icon(Icons.home),
                ),
                BottomNavigationBarItem(
                  label: "Later",
                  icon:Icon(Icons.watch_later),
                )
              ]
          ),
        )
      ),
    );
  }
}
