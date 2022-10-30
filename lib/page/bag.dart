import 'package:flutter/material.dart';

import '../app_state.dart';
import '../database.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class BagPage extends StatefulWidget {
  const BagPage({super.key});

  @override
  State<BagPage> createState() => _BagPageState();
}

class _BagPageState extends State<BagPage> with SingleTickerProviderStateMixin {
  bagsListener() {
    setState(() {});
  }

  @override
  void initState() {
    AppState().bags.addListener(bagsListener);
    super.initState();
  }

  @override
  void deactivate() {
    AppState().bags.removeListener(bagsListener);
    super.deactivate();
  }

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

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(18.0),
                  ),
                  Row(
                    children: const [
                      Text(
                        "Bag",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.all(2.0),
                  ),
                  Text(
                      '${AppState().bags.value.length.toString()} items in bag',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      )),
                  const Text('(สไลด์เพื่อลบรายการ)',
                      style: TextStyle(
                        fontSize: 10,
                      ))
                ],
              ),
              AppState().bags.value.isEmpty
                  ? Column(
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            border: Border.all(
                              width: 2,
                              color: Colors.black,
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: const Icon(Icons.shopping_bag_outlined),
                        ),
                        const Text("Your Bag is empty.")
                      ],
                    )
                  : Expanded(
                      child: ListView(
                      children: [
                        for (var item in AppState().bags.value)
                          Slidable(
                            key: UniqueKey(),

                            startActionPane: ActionPane(
                              motion: const ScrollMotion(),
                              dismissible: DismissiblePane(onDismissed: () {
                                setState(
                                    () => ({AppState().removeItemBag(item)}));
                              }),
                              children: [
                                SlidableAction(
                                  onPressed: ((context) {}),
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                ),
                              ],
                            ),

                            // The end action pane is the one at the right or the bottom side.
                            child: Card(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/images/${db.items![item].image!}',
                                    height: 120,
                                    width: 120,
                                  ),
                                  const Padding(padding: EdgeInsets.all(10)),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(db.items![item].name!,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500)),
                                      Text(
                                          'ราคา : ${db.items![item].price} บาท',
                                          style: const TextStyle(
                                            fontSize: 10,
                                          )),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                          )
                      ],
                    )),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Padding(padding: EdgeInsets.all(10)),
                  SizedBox(
                    height: 45,
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.black),
                      ),
                      onPressed: () {
                        if (AppState().bags.value.isEmpty) {
                          AppState().pageIndex.value = 0;
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  "ชำระเงินเรียบร้อยแล้ว ขอบคุณที่ใช้บริการ")));
                          AppState().clearItemsBag();
                        }
                      },
                      child: Text(AppState().bags.value.isEmpty
                          ? "Shop Now!"
                          : "Checkout"),
                    ),
                  ),
                  const Padding(padding: EdgeInsets.all(10))
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
