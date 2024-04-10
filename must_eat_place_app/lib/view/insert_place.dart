import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:must_eat_place_app/model/restaurant.dart';
import 'package:must_eat_place_app/vm/database_handler.dart';

class Insert extends StatefulWidget {
  const Insert({super.key});

  @override
  State<Insert> createState() => _InsertState();
}

class _InsertState extends State<Insert> {
  late DatabaseHandler handler;
  late String name;
  late String phone;
  late String lat;
  late String lng;
  late String estimate;
  

  late TextEditingController nameController;
  late TextEditingController latController;
  late TextEditingController lngController;
  late TextEditingController phoneController;
  late TextEditingController estimateController;


  XFile? pickedImageFile;
  final ImagePicker picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
    nameController = TextEditingController();
    latController = TextEditingController();
    lngController = TextEditingController();
    phoneController = TextEditingController();
    estimateController = TextEditingController();


    name  = '';
    phone = '';
    lat = ''; 
    lng = ''; 
    estimate = '';



  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Restaurant'),
          backgroundColor: Colors.orange[200],
          toolbarHeight: 70,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    getImage();
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
                          ? const Text('Image is not selected!')
                          : Image.file(File(pickedImageFile!.path)),
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
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
                  onPressed: () => insertAction(),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(120, 20)
                  ), 
                  child: const Text("Add")
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  
  
  //--FUNCTIONS--
  getImage() async {
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
      pickedImageFile = pickedFile;
    setState(() {
    });
  }

  insertAction()async{
    name = nameController.text.toString();
    estimate = estimateController.text.toString();
    phone = phoneController.text.toString();
    // int is double form (Latitude.Longitude)
    lat = latController.text.toString();
    lng = lngController.text.toString();

    //save the pickedImageFile as byteformat
    File imageFile1 = File(pickedImageFile!.path);
    Uint8List getImage = await imageFile1.readAsBytes();

    var restaurant = Restaurant(name: name, phone: phone, lat: lat, lng: lng, image: getImage, estimate: estimate, initdate:'');
    await handler.insertRestaurant(restaurant);
    _showDialog();
  }

  _showDialog(){
    Get.defaultDialog(
    title: 'Message',
    middleText: 'Added successfully!',
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




}//END 
