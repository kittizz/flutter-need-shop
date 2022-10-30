import 'package:flutter/material.dart';
import 'package:need_shop/database.dart';
import 'package:need_shop/page/shop_detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

        var newItem = db.items![db.newItemId!];
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Padding(
              padding: EdgeInsets.all(18.0),
            ),
            Row(
              children: [
                Text(
                  db.shopName!,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
            Text(db.shopDescription!),
            const Padding(
              padding: EdgeInsets.all(8.0),
            ),
            Expanded(
                child: ListView(children: [
              const Text('What\'s New',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                  )),
              Text(db.newDescription!,
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black26,
                    fontWeight: FontWeight.w500,
                  )),
              const Padding(
                padding: EdgeInsets.all(8.0),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text('New!!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          )),
                      Image(
                        image: AssetImage('assets/images/${newItem.image}'),
                        height: 180,
                      ),
                    ],
                  ),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(newItem.name!,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w600,
                          )),
                      Text(newItem.description!),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.black),
                          ),
                          onPressed: (() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShopDetailPage(
                                          shopId: db.newItemId!,
                                        )));
                          }),
                          child: const Text("เพิ่มเติม"))
                    ],
                  )),
                ],
              ),
            ]))
          ]),
        );
      },
    );
  }
}
