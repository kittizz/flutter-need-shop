import 'package:flutter/material.dart';

import '../database.dart';
import 'shop_detail.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> with TickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: 4, vsync: this);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  var shadowsActive = [
    const Shadow(offset: Offset(3, 3), color: Color.fromARGB(30, 0, 0, 0))
  ];
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Database.fetch(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        var db = snapshot.data!;

        var tabs = db.category!
            .map((v) => InkWell(
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Text(
                    v,
                    style: TextStyle(
                      color: _tabController.index == db.category!.indexOf(v)
                          ? Colors.black
                          : Colors.black38,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      shadows: _tabController.index == db.category!.indexOf(v)
                          ? shadowsActive
                          : null,
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      _tabController.animateTo(db.category!.indexOf(v));
                    });
                  },
                ))
            .toList();

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.all(18.0),
              ),
              Row(
                children: const [
                  Text(
                    'Shop',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                ],
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
              ),
              const Text(
                'หมวดหมู่',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: tabs,
              ),
              const Padding(padding: EdgeInsets.all(10)),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    for (var categoryName in db.category!)
                      Center(
                        child: ListView(children: [
                          for (var item in db.items!.where(
                              (element) => element.category == categoryName))
                            Padding(
                                padding: const EdgeInsets.all(10),
                                child: Card(
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ShopDetailPage(
                                                      shopId: db.items!
                                                          .indexOf(item),
                                                    )));

                                        // Navigator.push(
                                        //     context,
                                        //     PageTransition(
                                        //         duration: const Duration(
                                        //             milliseconds: 200),
                                        //         type: PageTransitionType
                                        //             .leftToRight,
                                        //         child: ShopDetailPage(
                                        //           shopId: item.id!,
                                        //         )));
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Image.asset(
                                            'assets/images/${item.image!}',
                                            height: 120,
                                            width: 120,
                                          ),
                                          const Padding(
                                              padding: EdgeInsets.all(10)),
                                          Expanded(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(item.name!,
                                                  style: const TextStyle(
                                                      fontSize: 15,
                                                      fontWeight:
                                                          FontWeight.w500)),
                                              Text('ราคา : ${item.price} บาท',
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                  )),
                                              const Text(
                                                  '(กดเพื่อดูรายละเอียด)',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                  ))
                                            ],
                                          )),
                                        ],
                                      )),
                                ))
                        ]),
                      )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
