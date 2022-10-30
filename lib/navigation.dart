import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:need_shop/app_state.dart';
import 'package:need_shop/database.dart';
import 'package:need_shop/page/bag.dart';
import 'package:need_shop/page/home.dart';
import 'package:need_shop/page/shop.dart';

class Navigation extends StatefulWidget {
  final int pageIndex;
  const Navigation({this.pageIndex = 0, super.key});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  bagsListener() {
    setState(() {});
  }

  pageIndexListener() {
    setState(() {});
  }

  @override
  void initState() {
    AppState().bags.addListener(bagsListener);
    AppState().pageIndex.addListener(pageIndexListener);
    super.initState();
  }

  @override
  void deactivate() {
    AppState().bags.removeListener(bagsListener);
    AppState().pageIndex.removeListener(pageIndexListener);
    super.deactivate();
  }

  final List<Widget> _pages = const [
    ShopPage(),
    HomePage(),
    BagPage(),
  ];
  // rest of the code
  Stack _buildScreens() {
    List<Widget> children = [];
    _pages.asMap().forEach((index, value) {
      children.add(
        Offstage(
          offstage: AppState().pageIndex.value != index,
          child: TickerMode(
            enabled: AppState().pageIndex.value == index,
            child: value,
          ),
        ),
      );
    });

    return Stack(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(textTheme: GoogleFonts.promptTextTheme()),
      home: FutureBuilder(
        future: Database.fetch(),
        builder: (context, snapshot) => SafeArea(
            top: true,
            bottom: true,
            child: Scaffold(
              body: Center(
                child: _buildScreens(),
              ),
              // New code bellow
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.white,
                selectedFontSize: 15,
                selectedItemColor: Colors.black,
                selectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w500),

                unselectedFontSize: 13,
                unselectedItemColor: Colors.black26,
                unselectedLabelStyle:
                    const TextStyle(fontWeight: FontWeight.w400),

                iconSize: 28,
                type: BottomNavigationBarType.fixed, // This is all you need!

                // New code
                currentIndex: AppState().pageIndex.value,
                onTap: (index) {
                  setState(() {
                    AppState().pageIndex.value = index;
                  });
                },
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.shopping_cart_outlined),
                    label: "Shop",
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home_outlined,
                    ),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Stack(children: <Widget>[
                      const Icon(Icons.shopping_bag_outlined),
                      Positioned(
                        // draw a red marble
                        top: 0,
                        right: 0,
                        child: Text(
                          AppState().bags.value.length.toString(),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                              color: Color.fromARGB(255, 229, 115, 115)),
                        ),
                      )
                    ]),
                    label: "Bag",
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
