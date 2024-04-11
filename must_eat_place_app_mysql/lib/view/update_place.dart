import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {
//PROPERTIES 

late String name; 
late String phone; 
late String estimate; 
late String lat; 
late String lng; 

late TextEditingController nameController; 
late TextEditingController phoneController; 
late TextEditingController estimateController; 
late TextEditingController latController; 
late TextEditingController lngController; 

  var value = Get.arguments ?? "__";

//INIT
@override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    estimateController = TextEditingController();
    latController = TextEditingController();
    lngController = TextEditingController();

    name = value[0];
    phone = value[1];
    estimate = value[2];
    lat = value[3];
    lng = value[4];

    name = '';
    phone = '';
    estimate = '';
    lat = '';
    lng = '';
  }


  insertJSONData()async{
  var url = Uri.parse('http://localhost:8080/Flutter/JSP/restaurant_update.jsp?name=$name&phone=$phone&estimate=$estimate&lat=$lat&lng=$lng');
  var response = await http.get(url); 
  // print(response.body);
  var dataConvertedJSON = json.decode(utf8.decode(response.bodyBytes));
  var result = dataConvertedJSON['results'];
  setState(() {}); //** ADD SETSTATE  **/
  if(!mounted) return; 
  if(result =='OK'){
    _showDialog();
  }else{
    errorSnackBar();
  }
}
errorSnackBar(){

}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Restaurant'),
      ),
        body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Name'
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone'
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: estimateController,
                decoration: const InputDecoration(
                  labelText: 'Estimate'
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: latController,
                decoration: const InputDecoration(
                  labelText: 'Latitude'
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: lngController,
                decoration: const InputDecoration(
                  labelText: 'Longitude'
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                updateAction();
                insertJSONData();
              }, 
              child: const Text('Insert')
            ),
          ],
        ),
      ),

    );
  }

//FUNCTIONS 
updateAction()async{ 
  name = nameController.text.toString(); 
  phone = estimateController.text.toString(); 
  estimate = estimateController.text.toString(); 
  lat = latController.text.toString(); 
  lng = lngController.text.toString(); 
  _showDialog();
}


_showDialog(){
  Get.defaultDialog(
    title: 'Message',
    middleText: 'Update Sucessful!',
    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    barrierDismissible: false,
    actions: [
      TextButton(
        onPressed: () {
          Get.back(); //end of dialoge
          Get.back(); //end of insert page
        }, 
        child: const Text('OK')
      )
    ]
  );
}













}


