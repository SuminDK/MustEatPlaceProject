import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:must_eat_place_app/model/restaurant.dart';
import 'package:must_eat_place_app/vm/database_handler.dart';

class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}

class _UpdateState extends State<Update> {

  //--PROPERTIES--
  late DatabaseHandler handler;
  late String lat;
  late String lng;
  late String name;
  late String phone;
  late String estimate;
  late Uint8List image; 
  late bool checkpushbutton; 

  late TextEditingController latController;
  late TextEditingController lngController;
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController estimateController;


  XFile? pickedImageFile;
  final ImagePicker picker = ImagePicker();

  var value = Get.arguments ?? '__';


  //--INIT--
@override
void initState() {
  super.initState();
  handler = DatabaseHandler();
  latController = TextEditingController();
  lngController = TextEditingController();
  nameController = TextEditingController();
  phoneController = TextEditingController();
  estimateController = TextEditingController();
  
  // Convert lat and lng values to strings before setting them to the controllers
  latController.text = value[1];
  lngController.text = value[2];
  nameController.text = value[3];
  phoneController.text = value[4];
  estimateController.text = value[5];


  lat = ''; 
  lng = ''; 
  name  = '';
  phone = '';
  estimate = '';
  image = value[6];
  checkpushbutton = false;
  
}


@override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Restaurant'),
          backgroundColor: Colors.orange[200],
          toolbarHeight: 70,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    checkpushbutton = true;
                    getImage(ImageSource.gallery);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(120, 20)
                  ),
                  child: const Text('Get Image')
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 210,
                    color: Colors.grey,
                    child: Center(
                      child: pickedImageFile == null
                          ? Image.memory(image) // image that is already in the db.
                          : Image.file(File(pickedImageFile!.path)
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 150,
                      child: TextField(
                        controller: latController,
                        decoration: const InputDecoration(
                          labelText: 'Latitude',
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                    const SizedBox(width: 50),
                    SizedBox(
                      width: 150,
                      child: TextField(
                        controller: lngController,
                        decoration: const InputDecoration(
                          labelText: 'Longitude',
                        ),
                        keyboardType: TextInputType.text,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                    ),
                    keyboardType: TextInputType.text,
                    
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10)))
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: estimateController,
                    decoration: const InputDecoration(
                      labelText: '  Review',
                      border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                      contentPadding: EdgeInsets.symmetric(vertical: 75.0), // Increase vertical padding
                    ),
                    keyboardType: TextInputType.multiline,
                    maxLength: 200,
                    maxLines: null, //allows multiple lines
                  ),
                ),
                ElevatedButton(
                  onPressed: () async{
                      updateAction();
                    },
                  style: ElevatedButton.styleFrom(
                  fixedSize: const Size(120, 20)
                  ), 
                  child: const Text("Update")
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
  
  //--FUNCTIONS--

getImage(imageSource) async {
  final XFile? pickedFile = await picker.pickImage(source: imageSource);
  if (pickedFile == null) {
    // Handle case where user cancels image selection
    return;
  } else {
    pickedImageFile = XFile(pickedFile.path);
  }
  setState(() {});
}

updateAction() async {
  int id = value[0];
  lat = latController.text.toString();
  lng = lngController.text.toString();
  name = nameController.text.toString();
  phone = phoneController.text.toString();
  estimate = estimateController.text.toString();

  if (checkpushbutton == true && pickedImageFile != null) {
    File imageFile1 = File(pickedImageFile!.path);
    Uint8List getImage = await imageFile1.readAsBytes();

    var restaurant = Restaurant(id: id, name: name, phone: phone, lat: lat, lng: lng, image: getImage, estimate: estimate, initdate:'');
    await handler.updateRestaurant(restaurant);
  } else {

    var restaurant = Restaurant(id:id, name: name, phone: phone, lat: lat, lng: lng, image: image, estimate: estimate, initdate:'');
    await handler.updateRestaurant(restaurant);
  }

  _showDialog();

}



_showDialog() {
  Get.defaultDialog(
    title: 'Message',
    middleText: 'Update Successful!',
    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    barrierDismissible: false,
    actions: [
      TextButton(
        onPressed: () {
          Get.back();
          Get.back();
        },
        child: const Text('OK'),
      ),
    ],
  );
}


  

}//END 
