import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:must_eat_place_app_mysql/view/insert_place.dart';
import 'package:must_eat_place_app_mysql/view/update_place.dart';



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {


//PROPERTIES
late List data; 

//INIT
@override
  void initState() {
    super.initState();
    data = [];
    getJSONData(); 
  }

getJSONData()async{
  var url = Uri.parse('http://localhost:8080/Flutter/JSP/restaurant_query.jsp');
  var response = await http.get(url); 
  // print(response.body);
  var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
  var result = dataConvertedJSON['results'];
  data.addAll(result);
  setState(() {}); //** ADD SETSTATE  **/
}

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Must-Eat List"),
        actions: [
          IconButton(
            onPressed: () => Get.to(const Insert())!.then((value) => reloadData()), 
            icon: const Icon(Icons.add_outlined)
          ),
        ],
      ),
      body: Center(
        child: data.isEmpty
        ? const Text(
          '데이터가 없습니다.',
          style: TextStyle(
            fontSize: 20
          ),
          textAlign: TextAlign.center,
          )
        : ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => cardBuild(context,index),
          ),
      ),
    );
  }


//----- WIDGET FUNCTIONS ----
Widget cardBuild(BuildContext context, int index){
  return GestureDetector(
    onTap: () {
      Get.to(const Update(),arguments: {
          [
            data[index]['name'],
            data[index]['phone'],
            data[index]['estimate'],
            data[index]['lat'],
            data[index]['lng'],
          ]
      });
    },
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text(
                  'Name : ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(data[index]['name'].toString())
              ],
            ),
            Row(
              children: [
                const Text(
                  'Phone : ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),
                ),
                Text(data[index]['phone'].toString())
              ],
            ),
          ],
        ),
      ),
    ),
  );
}


  reloadData() {
    data.clear(); // Clear existing data
    getJSONData(); // Fetch updated data
    setState(() {
      
    });
  }










}//END