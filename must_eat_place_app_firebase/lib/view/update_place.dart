import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Update extends StatefulWidget {
  const Update({super.key});

  @override
  State<Update> createState() => _UpdateState();
}
class _UpdateState extends State<Update> {
  var value = Get.arguments ?? "__";
//PROPERTIES 
late TextEditingController nameEditingController; 
late TextEditingController phoneEditingController; 
late TextEditingController estimateEditingController; 
late TextEditingController latEditingController; 
late TextEditingController lngEditingController; 
XFile? imageFile; 
final ImagePicker picker = ImagePicker();
File? imgFile; 


//INIT 
@override
  void initState() {
    super.initState();
    nameEditingController = TextEditingController();
    phoneEditingController = TextEditingController();
    estimateEditingController = TextEditingController();
    latEditingController = TextEditingController();
    lngEditingController = TextEditingController();

    nameEditingController.text = value[1];
    phoneEditingController.text = value[2];
    estimateEditingController.text = value[3];
    latEditingController.text = value[4];
    lngEditingController.text = value[5];
  }


@override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Restaurant'),
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
                          ? Image.network(value[6])
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
                        controller: latEditingController,
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
                        controller: lngEditingController,
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
                    controller: nameEditingController,
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
                    controller: phoneEditingController,
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
                    controller: estimateEditingController,
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
                  onPressed: () => updateAction(),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(120, 20)
                  ), 
                  child: const Text("Edit")
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

updateAction() async {
    String image = "";
    if (imageFile == null) {
      image = value[6];
    } else {
      await deleteImage();
      image = await preparingImage();
    }
    FirebaseFirestore.instance.collection('musteatplace').doc(value[0]).update({
      'name': nameEditingController.text,
      'phone': phoneEditingController.text,
      'estimate': estimateEditingController.text,
      'lat': latEditingController.text,
      'lng': lngEditingController.text,
      'image': image
    });
    _showDialog();
    
   // Get.back();
  }
  Future<String> preparingImage() async {
    final firebaseStorage = FirebaseStorage.instance
        .ref()
        .child('images')
        .child('${nameEditingController.text}.png');
    // 파일 업로드
    await firebaseStorage.putFile(imgFile!);
    //  경로를 가져온다.
    String downloadURL = await firebaseStorage.getDownloadURL();
    return downloadURL;
  }

deleteImage() async {
    final firebaseStorgae =
        FirebaseStorage.instance.ref().child('images').child('${value[1]}.png');
    //삭제
    await firebaseStorgae.delete();
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