import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Insert extends StatefulWidget {
  const Insert({super.key});

  @override
  State<Insert> createState() => _InsertState();
}
class _InsertState extends State<Insert> {

//PROPERTIES 
late TextEditingController nameController; 
late TextEditingController phoneController; 
late TextEditingController estimateController; 
late TextEditingController latController; 
late TextEditingController lngController; 

late String name; 
late String phone; 
late String estimate; 
late String lat; 
late String lng;


XFile? imageFile; 
final ImagePicker picker = ImagePicker();
File? imgFile; 


//INIT 
@override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    estimateController = TextEditingController();
    latController = TextEditingController();
    lngController = TextEditingController();
  }


@override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Restaurant'),
          toolbarHeight: 60,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    getImageFromGallery(ImageSource.gallery);
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
                      child: imageFile == null
                          ? const Text('Image is not selected!')
                          : Image.file(File(imageFile!.path)),
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
  getImageFromGallery(imageSource)async{
    final XFile? pickedFile = await picker.pickImage(source: imageSource);  // waiting for the user to pick the image form the gallery 
    imageFile =  XFile(pickedFile!.path); // user's picked image's file path 
    imgFile = File(imageFile!.path); // contain that file path into imgFile 
    setState(() {});
  }

insertAction()async{
  String name = nameController.text;
  String phone = phoneController.text;
  String estimate = estimateController.text;
  String lat = latController.text;
  String lng = lngController.text;  
  String image = await preparingImage();  

  FirebaseFirestore.instance
  .collection('musteatplace')
  .add({
    'name': name,
    'phone': phone,
    'estimate': estimate,
    'lat': lat,
    'lng': lng,
    'image': image
  });
  Get.back();

}

Future<String>preparingImage()async{
  final firebaseStorage = FirebaseStorage.instance
      .ref()
      .child('images') //name of the directory that we made in firestorage
      .child('${nameController.text}.png');
  await firebaseStorage.putFile(imgFile!); //await becuase it takes a long time to upload and bring the image
  String downloadURL = await firebaseStorage.getDownloadURL();
  return downloadURL;  //insert the downloadedURL into the database
}







}//END 