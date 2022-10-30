import 'package:flutter/material.dart';
import 'package:need_shop/app_state.dart';
import 'package:need_shop/database.dart';

class ShopDetailPage extends StatefulWidget {
  final int shopId;
  const ShopDetailPage({super.key, required this.shopId});

  @override
  State<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage> {
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
        var item = db.items![widget.shopId];
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            shadowColor: Colors.transparent,
            iconTheme: const IconThemeData(color: Colors.black, size: 24),
            title:
                Text(item.name!, style: const TextStyle(color: Colors.black)),
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: ListView(children: [
              Image.asset(
                "assets/images/${item.image!}",
                height: 300,
              ),
              const Padding(padding: EdgeInsets.all(4)),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.brand!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      )),
                  Text(item.name!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w600,
                      )),
                  Text('ราคา : ${item.price!} บาท',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      )),
                  Text('หมวดหมู่ : ${item.category!}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      )),
                  const Padding(padding: EdgeInsets.all(2)),
                  const Text('รายละเอียด',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black45,
                        fontWeight: FontWeight.w600,
                      )),
                  Text(item.description!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black45,
                        fontWeight: FontWeight.w400,
                      )),
                  const Padding(padding: EdgeInsets.all(8)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.grey),
                        ),
                        onPressed: () {
                          AppState().addItemBag(widget.shopId);
                          AppState().pageIndex.value = 2;
                          Navigator.pop(context);
                        },
                        child: const Text('Check Out'),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.black),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "เพิ่ม ${item.brand!} ${item.name!} ใส่ในกระเป๋า")));
                          AppState().addItemBag(widget.shopId);
                          Navigator.pop(context);
                        },
                        child: const Text('Add to bag'),
                      ),
                    ],
                  )
                ],
              ),
            ]),
          ),
        );
      },
    );
  }
}
