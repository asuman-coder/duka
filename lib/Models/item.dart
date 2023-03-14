// ignore_for_file: prefer_collection_literals, unnecessary_this

import 'package:cloud_firestore/cloud_firestore.dart';

class ItemModel {
  String? uid;
  String? title;
  String? shortInfo;
  Timestamp? publishedDate;
  String? thumbnailUrl;
  String? longDescription;
  String? status;
  int? price;

  ItemModel({
    this.uid,
    this.title,
    this.shortInfo,
    this.publishedDate,
    this.thumbnailUrl,
    this.longDescription,
    this.status,
    // this.price,
  });

  ItemModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    title = json['title'];
    shortInfo = json['shortInfo'];
    publishedDate = json['publishedDate'];
    thumbnailUrl = json['thumbnailUrl'];
    longDescription = json['longDescription'];
    status = json['status'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['uid'] = this.uid;

    data['title'] = this.title;

    data['shortInfo'] = this.shortInfo;

    data['price'] = this.price;

    if (this.publishedDate != null) {
      data['publishedDate'] = this.publishedDate;
    }

    data['thumbnailUrl'] = this.thumbnailUrl;

    data['longDescription'] = this.longDescription;

    data['status'] = this.status;
    return data;
  }
}

class PublishedDate {
  String? date;

  PublishedDate({this.date});

  PublishedDate.fromJson(Map<String, dynamic> json) {
    date = json['$date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    data['$date'] = this.date;
    return data;
  }
}
