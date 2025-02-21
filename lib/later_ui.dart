import 'package:flutter/material.dart';
import 'package:news_app/later_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as urlLunch;

class LaterUi extends StatefulWidget {
  const LaterUi({super.key});

  @override
  State<LaterUi> createState() => _LaterUiState();
}

class _LaterUiState extends State<LaterUi> {
  void lunchUrl(String url){
    urlLunch.launchUrl(Uri.parse(url));
  }
  @override
  Widget build(BuildContext context) {
    final article=Provider.of<LaterProvider>(context).list;
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
      body: article.isEmpty?Center(child:Text("Nothing to Show",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),)):
      ListView.builder(
          itemCount: article.length,
          itemBuilder: (context, index) {
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
                  lunchUrl(article[index]["url"]);
                },
                child: Column(
                    children: [
                      ListTile(
                        title: Column(
                          children: [
                            Text(article[index]["title"],
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(article[index]["description"],
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          article[index]["author"] ?? "",
                          style: TextStyle(
                              fontSize: 16
                          ),
                        ),
                        trailing: IconButton(onPressed: () {
                          showDialog(context:context,builder: (context){
                            return AlertDialog.adaptive(
                              title: Text("Delete",style: TextStyle(fontWeight: FontWeight.bold)),
                              content: Text("Are you sure?"),
                              actions: [
                                TextButton(onPressed: (){
                                  Navigator.of(context).pop();
                                }, child: Text("No",style: TextStyle(color: Colors.red),)),
                                TextButton(onPressed: (){
                                  setState(() {
                                    Provider.of<LaterProvider>(context,listen: false).removeNews(article[index]);
                                    Navigator.of(context).pop();
                                  });
                                }, child: Text("Yes",style: TextStyle(color: Colors.blue),))
                              ],
                            );
                          }
                          );
                        }, icon: Icon(Icons.delete)),
                      ),
                      Container(
                          height: 250,
                          width: double.infinity,
                          padding: EdgeInsets.all(5),
                          child: Image.network(
                              article[index]["urlToImage"],
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
      )
    );
  }
}