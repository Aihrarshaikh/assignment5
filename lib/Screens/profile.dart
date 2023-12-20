import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Constants/color.dart';
import 'studentList.dart';
import 'formFilling.dart';
import '../Services/authStateProvider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  DatabaseReference ref = FirebaseDatabase.instance.ref().child('ignore');

  Query globalRef = FirebaseDatabase.instance.ref().child('Global_data');

  Query ignoreRef = FirebaseDatabase.instance.ref().child('ignore');

  final user = FirebaseAuth.instance.currentUser!;

  Widget listItem({required Map student}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 210,
      color: Theme.of(context).colorScheme.onPrimaryContainer,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Name :  ",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w400, color: kTextW),
              ),
              Text(
                student['name'],
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w400, color: kTextW),
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
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w400, color: kTextW),
              ),
              Text(
                student['age'],
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w400, color: kTextW),
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
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w400, color: kTextW),
              ),
              Text(
                student['salary'],
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w400, color: kTextW),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.red,
            ),
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.logout();
              Navigator.pop(context);
            },
          ),
        ],
        title: Text("Profile Screen"),
      ),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(user.photoURL!),
                    ),
                    Text(user.displayName!),
                    Text(user.email!),
                  ]),
            ),
            SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Your blocked list",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 0,
                    child: FirebaseAnimatedList(
                      query: ignoreRef,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        Map ignore = snapshot.value as Map;

                        ignoreList.add(
                            {'ignr': ignore['ignr'], 'user': ignore['user']});

                        return Container();
                      },
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: FirebaseAnimatedList(
                      query: globalRef,
                      itemBuilder: (BuildContext context, DataSnapshot snapshot,
                          Animation<double> animation, int index) {
                        Map student = snapshot.value as Map;
                        student['key'] = snapshot.key;
                        bool build = false;
                        ignoreList.forEach((element) {
                          if (element['user'] == "$curruserID") {
                            if (element['ignr'] == '${student['key']}') {
                              build = true;
                            }
                          }
                        });
                        return build ? listItem(student: student) : Container();
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
