import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:news_app/later_provider.dart';
import 'package:url_launcher/url_launcher.dart' as urlLunch;
import 'package:provider/provider.dart';

class HomeUi extends StatefulWidget {
  const HomeUi({super.key});

  @override
  State<HomeUi> createState() => _HomeUiState();
}

class _HomeUiState extends State<HomeUi> {
  final List<String> filters=["India","World","Business","Entertainment","Netflix","Anime","Sports","Cricket","Technology","Politics","Music","Finance"];
  late String selectedFilter;
  void lunchUrl(String url){
    urlLunch.launchUrl(Uri.parse(url));
  }
  @override
  void initState() {
    super.initState();
    selectedFilter=filters[0];

    getNews();
  }
  Future<Map<String,dynamic>> getNews() async{
    try{
      final res=await http.get(Uri.parse("https://newsapi.org/v2/everything?q=$selectedFilter&language=en&language=hindi&from=${DateTime.now}&sortBy=publishedAt&apiKey=66fdbcba6f6e44aeb936713b19f899c9"));
      final data=json.decode(res.body);
      if(data["status"]!="ok"){
        throw "A unknown error occur";
      }
      return data;
    }catch(e){
      throw "A unknown error occur";
    }
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getNews(),
      builder: (context,snapshot) {
        if(snapshot.connectionState==ConnectionState.waiting){
          return Scaffold(
            appBar: AppBar(
              title: Text("News App",style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              ),
              elevation: 5,
              backgroundColor: Colors.white10,
              centerTitle: true,
              actions: [
                IconButton(onPressed:(){
                  setState(() {});
                }, icon: Icon(Icons.refresh,color: Colors.black,))
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filters.length,
                    itemBuilder: (context, index) {
                      final filter = filters[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFilter = filter;
                            });
                          },
                          child: Chip(label: Text(filter),
                              padding: EdgeInsets.all(5),
                              labelStyle: TextStyle(
                                  color: selectedFilter == filter ?Colors.white:Colors.black,
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold
                              ),
                              avatar: CircleAvatar(radius: 20,child: Icon(Icons.newspaper)),
                              side: BorderSide(
                                  width: 1,
                                  color: selectedFilter == filter ?Colors.white24:Colors.black
                              ),
                              backgroundColor: selectedFilter != filter ?Colors.white:Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)
                              )
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Center(
                    child: CircularProgressIndicator.adaptive(),
                  ),
                )
              ],
            ),
          );
        }
        if(snapshot.hasError){
          return Center(child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[ Text("A unknown error occur.\nPlease restart the app.\nSorry for inconvenience.",style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
              textAlign: TextAlign.center,),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(onPressed: (){
                setState(() {
                  selectedFilter=filters[0];
                });
              },child: Text("Retry",style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              )
              )
            ],
          ),
          );
        }
        final data=snapshot.data!;
        List<dynamic> articles=data["articles"];
        return Scaffold(
          appBar: AppBar(
            title: Text("News App",style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            ),
            elevation: 5,
            backgroundColor: Colors.white10,
            centerTitle: true,
            actions: [
              IconButton(onPressed:(){
                setState(() {});
              }, icon: Icon(Icons.refresh,color: Colors.black,))
            ],
          ),
          body: Column(
            children: [
              SizedBox(
                height: 60,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filters.length,
                  itemBuilder: (context, index) {
                    final filter = filters[index];
                    return Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedFilter = filter;
                          });
                        },
                        child: Chip(label: Text(filter),
                            padding: EdgeInsets.all(5),
                            labelStyle: TextStyle(
                                color: selectedFilter == filter ?Colors.white:Colors.black,
                                fontSize: 19,
                                fontWeight: FontWeight.bold
                            ),
                            avatar: CircleAvatar(radius: 20,child: Icon(Icons.newspaper)),
                            side: BorderSide(
                                width: 1,
                                color: selectedFilter == filter ?Colors.white24:Colors.black,
                            ),
                            backgroundColor:selectedFilter != filter ?Colors.white:Colors.black,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18)
                            )
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: articles.length,
                      itemBuilder: (context, index) {
                        if (articles[index]["urlToImage"] != null) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 10
                            ),
                            decoration: BoxDecoration(
                              color: index % 2 != 0
                                  ? Colors.white60
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                lunchUrl(articles[index]["url"]);
                              },
                              child: Column(
                                  children: [
                                    ListTile(
                                      title: Column(
                                        children: [
                                          Text(articles[index]["title"],
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(articles[index]["description"],
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        articles[index]["author"] ?? "",
                                        style: TextStyle(
                                            fontSize: 16
                                        ),
                                      ),
                                      trailing: IconButton(onPressed: () {
                                        Provider.of<LaterProvider>(context,listen: false).addNews(articles[index]);
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Article added to Read Later")));
                                      },
                                          icon: Icon(Icons.watch_later)),
                                    ),
                                    Container(
                                        height: 250,
                                        width: double.infinity,
                                        padding: EdgeInsets.all(5),
                                        child: Image.network(
                                            articles[index]["urlToImage"],
                                            fit: BoxFit.cover)
                                    ),
                                    Divider(
                                      thickness: 2,
                                      color: Colors.grey,
                                    )
                                  ]
                              ),
                            ),
                          );
                        }
                        return Container();
                      }
                  )
              )
            ],
          ),
        );
      }
    );
  }
}