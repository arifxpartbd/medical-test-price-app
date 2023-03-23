import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';


final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _mainCollection = _firestore.collection("data");

class Database {
  static String? userId;

  static Future<void> addItem(
      {required String name,
      required String price,
      required String hospital,
      required String id,
      }) async {
    // DocumentReference documentReference =
    //     _mainCollection.doc('patient').collection("item").doc();
    DocumentReference  documentReference = _firestore.collection("test").doc();

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "price": price,
      "hospital": hospital,
      "id": id,

    };
    await documentReference
        .set(data)
        .whenComplete(() => print("Item Added Successfully"))
        .catchError((e) => print(e));
  }
static Future<void> addToTestList(
      {required String name,
      required String price,
      required String hospital,
      required String id,
        required String userId
      }) async {
    // DocumentReference documentReference =
    //     _mainCollection.doc('patient').collection("item").doc();
    DocumentReference  documentReference = _firestore.collection("user-test").doc(userId).collection("item").doc(id);

    Map<String, dynamic> data = <String, dynamic>{
      "name": name,
      "price": price,
      "hospital": hospital,
      "id": id,


    };
    await documentReference
        .set(data)
        .whenComplete(() => print("Item Added Successfully"))
        .catchError((e) => print(e));
  }

  static Future<void> updataData(
      {required String title,
        required String id,
      required String description,
      required String docId}) async {
    DocumentReference documentReference = _firestore.doc("patient").collection("prescription").doc(id);
        //_mainCollection.doc("patient").collection("item").doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": title,
      "des": description,
      "id": docId
    };
    await documentReference
        .set(data)
        .whenComplete(() => print("data updated successfully"))
        .catchError((e) => print(e));
  }
  

  static Future<void> deleteItem({required String docId, required String userId}) async {
    DocumentReference documentReference =
    _firestore.collection("user-test").doc(userId).collection("item").doc(docId);
        //_mainCollection.doc("user-test").collection("item").doc();

    await documentReference
        .delete()
        .whenComplete(() => print("data deleted successfully"))
        .catchError((e) => print(e));
  }

static Stream<QuerySnapshot> readTestList(){
    Stream<QuerySnapshot<Map<String, dynamic>>> testlist = _firestore.collection("test").snapshots();
    //_mainCollection.doc("patient").collection("item").snapshots();

    return testlist;
}static Stream<QuerySnapshot> readMyTest(userId){
    Stream<QuerySnapshot<Map<String, dynamic>>> testlist = _firestore.collection("user-test").doc(userId).collection("item").snapshots();
    //_mainCollection.doc("patient").collection("item").snapshots();

    return testlist;
}
}


