import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = new TextEditingController();
  List<String> navBarItem = ["Top News" , "India" , "World" , "Finacnce" , "Health"];
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  // navigation between different pages
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Home',
      style: optionStyle,
    ),
    Text(
      'Categories',
      style: optionStyle,
    ),
    Text(
      'Profile',
      style: optionStyle,
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    final List items = ["Item 1","Item 2","Item 3","Item 4"];
    return Scaffold(
      appBar: AppBar(
        title: Text("Nyuz"),
        centerTitle: true,
      ),
      body: SingleChildScrollView (
      child: Column(
        children: [
          Container(
            //Search textbox
            padding: EdgeInsets.symmetric(horizontal: 8),
            margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24)),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if ((searchController.text).replaceAll(" ", "") == "") {
                      print("Blank search");
                    } else {
                      // Navigator.push(context, MaterialPageRoute(builder: (context) => Search(searchController.text)));
                    }
                  },
                  child: Container(
                    child: Icon(
                      Icons.search,
                      color: Colors.blueAccent,
                    ),
                    margin: EdgeInsets.fromLTRB(3, 0, 7, 0),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    // to get search icon on keyboard
                    textInputAction: TextInputAction.search,
                    // print search value on console
                    onSubmitted: (value){
                      print(value);
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search Anything ..."),
                  ),
                )
              ],
            ),
          ),
          // Horizontal list of categories
          Container(
              height: 50,
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: navBarItem.length,
                  itemBuilder : (context , index){
                    return InkWell(
                      onTap: () {
                        print(navBarItem[index]);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20 , vertical : 10),
                        margin: EdgeInsets.symmetric(horizontal : 5),
                        decoration : BoxDecoration(
                            color: Colors.blueAccent,
                            borderRadius : BorderRadius.circular(15)
                        ),

                        child : Center(
                          child: Text(
                              navBarItem[index] ,
                              style: TextStyle(
                                  fontSize:19 ,
                                  color: Colors.white,
                                  fontWeight:FontWeight.bold
                              )),
                        ),
                      ),
                    );
                  }
              )
          ),
          // print according to bottom navbar
          CarouselSlider(
            options : CarouselOptions(
                height : 200,
                autoPlay : true,
                enlargeCenterPage : true
            ),
            items : items.map((item) {
              return Builder(
                  builder: (BuildContext context){
                    return InkWell(
                      onTap: () {
                        print("Carousel Slider");
                      },
                      child: Container(
                        margin : EdgeInsets.symmetric(horizontal : 5 , vertical : 14),
                        child : Text(item),
                      ),
                    );
                  }
              );
            }).toList(),
          ),
          //_widgetOptions.elementAt(_selectedIndex),
          /* Container(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context,index){
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      elevation: 1.0,
                      child: Stack(
                        children: [
                          // Wrap image with clipRRect widget to make image border circular
                          ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset("assets/img.png")
                          ),
                          Positioned(
                            left: 0,
                              right: 0,
                              bottom: 0,

                              child: Text(
                                  "News Headline",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              )

                        ],
                      ),
                    )
                    // padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    // child: Image.asset("assets/img.png"),
                  );
                }),
          )
        ],
      ),
      ), */
          Container(
            child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        elevation: 1.0, // for card to show one level up
                        child: Stack(
                          children: [
                            // Wrap image with cliprrect to make image circular
                            ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.asset("assets/img.png")
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
                                          "NEWS HEADLINE",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text("News Description" , style: TextStyle(color: Colors.white , fontSize: 12)
                                          ,)
                                      ],
                                    )))
                          ],
                        )),
                  );
                }),
          )
        ],
      ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}

