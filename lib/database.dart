import 'dart:convert';

import 'package:flutter/services.dart';

class Database {
  String? shopName;
  List<String>? category;
  List<Items>? items;
  String? shopDescription;
  String? newDescription;
  int? newItemId;

  static Future<Database> fetch() async {
    final jsonData = await rootBundle.loadString("assets/database.json");
    var data = await json.decode(jsonData);
    return Database.fromJson(data);
  }

  Database.fromJson(Map<String, dynamic> json) {
    category = json['category'].cast<String>();
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
    shopName = json['shop_name'];
    shopDescription = json['shop_description'];
    newDescription = json['new_description'];
    newItemId = json['new_item_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category'] = category;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    data['shop_name'] = shopName;
    data['shop_description'] = shopDescription;
    data['new_description'] = newDescription;
    data['new_item_id'] = newItemId;
    return data;
  }
}

class Items {
  String? brand;
  String? name;
  String? category;
  String? description;
  int? price;
  String? image;

  Items(
      {this.brand,
      this.name,
      this.category,
      this.description,
      this.price,
      this.image});

  Items.fromJson(Map<String, dynamic> json) {
    brand = json['brand'];
    name = json['name'];
    category = json['category'];
    description = json['description'];
    price = json['price'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brand'] = brand;
    data['name'] = name;
    data['category'] = category;
    data['description'] = description;
    data['price'] = price;
    data['image'] = image;
    return data;
  }
}

class ClassName {}
