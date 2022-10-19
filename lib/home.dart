import 'dart:convert';
import 'package:nyuz/NewsView.dart';
import 'package:nyuz/category.dart';
import 'package:nyuz/model.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = new TextEditingController();
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel>[];
  List<String> navBarItem = [
    "Top News",
    "India",
    "Bussiness",
    "Finacnce",
    "Health"
  ];

  bool isLoading = true;

  getNewsByQuery(String query) async {
    Map element;
    int i = 0;
    String url =
        "https://newsapi.org/v2/everything?q=$query&from=2022-10-01&sortBy=publishedAt&apiKey=54b183bd892847cb8d138d9679b534f6";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      for (element in data["articles"]) {
        try {
          i++;
          NewsQueryModel newsQueryModel = new NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelList.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });
          /// Display only five news on the screen
          if (i == 5) {
            break;
          }
        }
        catch (e) {
          print(e);
        };
      }
    });
  }

  /// Data fetching for carousel
  getNewsofIndia() async {
    String url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=54b183bd892847cb8d138d9679b534f6";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelListCarousel.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });
      });
    });
  }

 /// It is a entry point for the stateful widget and called only and only once
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNewsByQuery("technology");
    getNewsofIndia();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nyuz",
          style: TextStyle(color: Color(0xfff2ce50), fontSize:25),
        ),
        backgroundColor: Color(0xff232321),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Search Container
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24)
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if ((searchController.text).replaceAll(" ", "") == "") {
                        print("Blank search");
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => Category(Query: searchController.text)));
                      }
                    },
                    child: Container(
                      child: Icon(
                        Icons.search,
                        color: Color(0xff232321),
                      ),
                      margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                    ),
                  ),
                  /// Use expanded to take all available space for search textfield
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      /// textInputAction will override symbol in keyboard and provide search icon on keyboard
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        /// Validating search
                        if(value == ""){
                          print("Blank Search");
                        }
                        else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Category(Query: value)));
                        }
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none, hintText: "Search Here"),
                    ),
                  )
                ],
              ),
            ),
            /// Categories Container
            Container(
                height: 50,
                child: ListView.builder(
                   /// All the items in list will occupy only necessary space but if we set shrinkWrap to false then it would
                  /// occupy all the available space
                    shrinkWrap: true,
                    /// TO scroll horizontally
                    scrollDirection: Axis.horizontal,
                    itemCount: navBarItem.length,
                    itemBuilder: (context, index) {
                      /// InkWell to detect touch
                      return InkWell(
                        onTap: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context) => Category(Query: navBarItem[index])));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10
                          ),
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: Color(0xfff2ce50),
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(navBarItem[index],
                                style: TextStyle(
                                    fontSize: 19,
                                    color: Color(0xff232321),
                                    fontWeight: FontWeight.bold)
                            ),
                          ),
                        ),
                      );
                    }
                    )
            ),
            /// Carousel Container
            Container(
              margin: EdgeInsets.symmetric(vertical: 15),
              /// Set Container and loader accoring to state
              child: isLoading ?
              Container(
                  height: 200,
                  child: Center(child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black54),
                  ))
              ) :
              CarouselSlider(
                options: CarouselOptions(
                    height: 200, autoPlay: true, enlargeCenterPage: true),
                items: newsModelListCarousel.map((instance) {
                  return Builder(builder: (BuildContext context) {
                    try{
                    return Container(
                        child : InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NewsView(instance.newsUrl)));
                          },
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              /// Stack makes a layer of widgets by putting them on top of each other
                              child : Stack(
                                  children : [
                                    /// provides us with a widget that clips its child using a rounded rectangle
                                    ClipRRect(
                                        borderRadius : BorderRadius.circular(10),
                                        child : Image.network(instance.newsImg , fit: BoxFit.fitHeight, width: double.infinity,)
                                    ) ,
                                    Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              gradient: LinearGradient(
                                                  colors: [
                                                    Colors.black12.withOpacity(0),
                                                    Colors.black
                                                  ],
                                                  begin: Alignment.topCenter,
                                                  end: Alignment.bottomCenter
                                              )
                                          ),
                                          child : Container(
                                              padding: EdgeInsets.symmetric(horizontal: 5 , vertical: 10),
                                              child:Container(
                                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                                  child: Text(
                                                    instance.newsHead ,
                                                    style: TextStyle(
                                                        fontSize: 18 ,
                                                        color: Colors.white ,
                                                        fontWeight: FontWeight.bold
                                                    ),
                                                  )
                                              )
                                          ),
                                        )
                                    ),
                                  ]
                              )
                          ),
                        )
                    );
                    }catch(e){
                     print(e);
                     return Container(child: Text("Error"),);
                    }
                  });
                }).toList(),
              ) ,
            ),
            /// Main Container
            Container(
              child: Column(
                children: [
                  Container(
                    margin : EdgeInsets.fromLTRB(15, 25, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("LATEST NEWS " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 28
                        ),),
                      ],
                    ),
                  ),
                  isLoading ? Container(height: MediaQuery.of(context).size.height - 450,
                      child :Center(child: CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(Colors.black54),
                      ),)) :
                  ListView.builder(
                    /// prevents scrolling inside your scrollable widget
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: newsModelList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NewsView(newsModelList[index].newsUrl)));
                            },
                            child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)
                                ),
                                elevation: 1.0,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        /// To work with images from a URL
                                        child: Image.network(
                                          newsModelList[index].newsImg ,
                                          fit: BoxFit.fitHeight,
                                          height: 230,
                                          width: double.infinity, )
                                    ),
                                    Positioned(
                                        left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                gradient: LinearGradient(
                                                    colors: [
                                                      Colors.black12.withOpacity(0),
                                                      Colors.black
                                                    ],
                                                    begin: Alignment.topCenter,
                                                    end: Alignment.bottomCenter
                                                )
                                            ),
                                            padding: EdgeInsets.fromLTRB(15, 15, 10, 8),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  newsModelList[index].newsHead,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                Text(
                                                  /// Display only 50 characters of news description
                                                  newsModelList[index].newsDes.length > 50 ?
                                                  "${newsModelList[index].newsDes.substring(0,55)}...." :
                                                  newsModelList[index].newsDes ,
                                                  style: TextStyle(color: Colors.white , fontSize: 12)
                                                  ,)
                                              ],
                                            )))
                                  ],
                                )),
                          ),
                        );
                      }),
                  /// Show more container
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Category(Query: "India")));
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xfff2ce50),
                            ),
                            child: Text(
                              "SHOW MORE",
                              style: TextStyle(color: Color(0xff232321)),
                            ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


}