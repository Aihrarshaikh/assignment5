

import 'package:assignment5/Screens/formFilling.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';

import '../Constants/color.dart';

List<Map<String, String>> ignoreList = [];
class FetchData extends StatefulWidget {
  const FetchData({Key? key}) : super(key: key);

  @override
  State<FetchData> createState() => _FetchDataState();
}

class _FetchDataState extends State<FetchData> {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('ignore');
  Query globalRef = FirebaseDatabase.instance.ref().child('Global_data');
  Query ignoreRef = FirebaseDatabase.instance.ref().child('ignore');

  Widget listItem({required Map student}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 200,
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Name :  ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: kTextW),
              ),
              Text(
                student['name'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: kTextW),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                "Age :  ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: kTextW),
              ),

              Text(
                student['age'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: kTextW),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Row(
            children: [
              Text(
                "Salary :  ",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: kTextW),
              ),
              Text(
                student['salary'],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400,color: kTextW),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 6,
              ),
              GestureDetector(
                onTap: () async {
                  await showDialog<void>(
                      context: context,
                      builder: (context) => AlertDialog(
                            content: Container(
                              height: 100,
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                        "Are you sure you want to block this student"),
                                  ),
                                  Positioned(
                                    bottom: 10,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              Map<String, String> ignore = {
                                                "user": curruserID,
                                                'ignr': student['key'],
                                              };
                                              ref.push().set(ignore);
                                              Navigator.pop(context);
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext context) =>
                                                      InsertData() ),
                                                      (Route<dynamic> route) => false);                                            },
                                            child: Container(
                                              child: Text(
                                                "YES",
                                                style: TextStyle(
                                                    color: Colors.green,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              child: Text(
                                                "NO",
                                                style: TextStyle(
                                                    color: Colors.red,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.remove_circle_outline,
                      color: kTextW,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    ref = FirebaseDatabase.instance.ref().child('ignore');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('Student List'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                height: 0,
                child: FirebaseAnimatedList(
                  query: ignoreRef,
                  itemBuilder: (BuildContext context, DataSnapshot snapshot,
                      Animation<double> animation, int index) {
                    Map ignore = snapshot.value as Map;
                    ignoreList
                        .add({'ignr': ignore['ignr'], 'user': ignore['user']});
          
                    return Container();
                  },
                ),
              ),
              Container(
                  height: MediaQuery.of(context).size.height-100,
                  child: FirebaseAnimatedList(
                    query: globalRef,
                    itemBuilder: (BuildContext context, DataSnapshot snapshot,
                        Animation<double> animation, int index) {
                      Map student = snapshot.value as Map;
                      student['key'] = snapshot.key;
                      bool build = true;
                      ignoreList.forEach((element) {
                        if (element['user'] == "$curruserID") {
                          if (element['ignr'] == '${student['key']}') {
                            build = false;
                          }
                        }
                      });
                      return build ? listItem(student: student) : Container();
                    },
                  )),
        
            ],
          ),
        ),
      ),
    );
  }
}
