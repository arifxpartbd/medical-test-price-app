import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicaltestpriceappbd/database.dart';
import 'package:medicaltestpriceappbd/myTestModel.dart';
import 'package:medicaltestpriceappbd/testModelClass.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  final TextEditingController _search = TextEditingController();
  // String _searchValue = "";

  //

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _search.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _search.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      //_searchValue = _search.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: const Text("Medical Test Price"),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: _search,
                    onChanged: (value) {
                      //_searchValue = _search.text;
                    },
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Search test name ...."),
                  ),
                ),
                Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                  //stream: _stream,
                  stream: FirebaseFirestore.instance
                      .collection("test")
                      .where("name", isGreaterThanOrEqualTo: _search.text)
                      .where("name", isLessThanOrEqualTo: _search.text + "z")
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text("Error, Please Check you network"),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    final testInfo = snapshot.data!.docs
                        .map((e) => TestModelClass.fromJson(
                            e.data() as Map<String, dynamic>))
                        .toList();
                    return ListView.builder(
                        itemCount: testInfo.length,
                        itemBuilder: (BuildContext context, int index) {
                          final test = testInfo[index];
                          return Card(
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(test.name),
                                      subtitle: Text(test.price),
                                      leading: CircleAvatar(
                                        child: Image.network(
                                          "https://bsmmu.edu.bd/assets/images/logo.png",
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      trailing: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          onPressed: () {
                                            Database.addToTestList(
                                                name: test.name,
                                                price: test.price,
                                                hospital: test.hospital,
                                                id: test.id,
                                                userId: firebaseAuth
                                                    .currentUser!.email
                                                    .toString()
                                                    .trim());
                                          },
                                          child: const Padding(
                                            padding: EdgeInsets.all(10.0),
                                            child: Text("Add To My Test List"),
                                          )),
                                    ),
                                    const ExpansionTile(
                                      title: Text("More"),
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            "ধাপ ১: পরিক্ষা / টেস্ট সমূহের পেমেন্ট স্লিপ সংগ্রহ করতে হবে।\nধাপ ২: ক্যাশ কাউন্টারে এসে স্লিপে উল্লেখিত টাকা জমা দিয়ে পেমেন্ট স্লিপ সংগ্রহ করতে হবে।\nধাপ ৩: স্লিপে লিখা নির্ধারিত নমুনা কালেকশন ডেস্কে গিয়ে নমুনা দিতে হবে।",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                )),
                          );
                        });
                  },
                ))
              ],
            ),
          ),
          Expanded(
              flex: 2,
              child: StreamBuilder<QuerySnapshot>(
                stream: Database.readMyTest(firebaseAuth.currentUser!.email),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text("Error, please check your newtork"),
                    );
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Center(
                      child: Container(),
                    );
                  }
                  final testInfo = snapshot.data!.docs
                      .map((e) => MyTestModel.fromJson(
                          e.data() as Map<String, dynamic>))
                      .toList();
                  int totalQuantity = testInfo.fold(
                      0, (sum, item) => sum + int.parse(item.price));

                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                              child: Card(
                                  child: Padding(
                            padding: const EdgeInsets.all(17.0),
                            child: Text(
                              "Total Test Value $totalQuantity",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ))),
                        ],
                      ),
                      Expanded(
                        child: ListView.builder(
                            itemCount: testInfo.length,
                            itemBuilder: (BuildContext context, int index) {
                              final test = testInfo[index];
                              return Card(
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: ListTile(
                                      title: Text(test.name),
                                      trailing: Text(test.price),
                                      leading: IconButton(
                                          onPressed: () {
                                            Database.deleteItem(
                                                docId: test.id,
                                                userId: firebaseAuth
                                                    .currentUser!.email
                                                    .toString());
                                          },
                                          icon: const Icon(
                                            Icons.delete_forever_rounded,
                                            color: Colors.red,
                                          )),
                                    )),
                              );
                            }),
                      ),
                    ],
                  );
                },
              ))
        ],
      ),
    );
  }
}
