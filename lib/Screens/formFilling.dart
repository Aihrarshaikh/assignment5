import 'package:assignment5/Screens/studentList.dart';
import 'package:assignment5/Screens/profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


late var curruserID;

class InsertData extends StatefulWidget {
  const InsertData({Key? key}) : super(key: key);

  @override
  State<InsertData> createState() => _InsertDataState();
}

class _InsertDataState extends State<InsertData> {

  final  userNameController = TextEditingController();
  final  userAgeController= TextEditingController();
  final  userSalaryController =TextEditingController();

  late DatabaseReference globalDB;


  @override
  void initState() {
    globalDB = FirebaseDatabase.instance.ref().child('Global_data');
    curruserID = FirebaseAuth.instance.currentUser!.uid;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));

          }, icon: Icon(Icons.person,color: Theme.of(context).colorScheme.onPrimaryContainer))
        ],
        title: Text('Data input'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Fill your information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: userNameController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                  hintText: 'Enter Your Name',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: userAgeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Age',
                  hintText: 'Enter Your Age',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                controller: userSalaryController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Salary',
                  hintText: 'Enter Your Salary',
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              MaterialButton(
                onPressed: () {
                  if(userAgeController.text.isNotEmpty & userNameController.text.isNotEmpty & userSalaryController.text.isNotEmpty) {
                    Map<String, String> students = {
                      'name': userNameController.text,
                      'age': userAgeController.text,
                      'salary': userSalaryController.text
                    };
                    globalDB.push().set(students);
                    setState(() {
                      userAgeController.clear();
                      userSalaryController.clear();
                      userNameController.clear();
                    });

                    Navigator.push(context, MaterialPageRoute(builder: (_) => FetchData()));
                  }else{
                    const snackBar = SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text('All fields should be filled'),
                      backgroundColor: (Colors.black87),

                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Text('Register Student'),
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                textColor: Colors.white,
                minWidth: 300,
                height: 40,
              ),
              MaterialButton(
                onPressed: () {
                      userAgeController.clear();
                      userSalaryController.clear();
                      userNameController.clear();
                    Navigator.push(context, MaterialPageRoute(builder: (_) => FetchData()));
                },
                child: const Text('Check student list'),
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                textColor: Colors.white,
                minWidth: 300,
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
