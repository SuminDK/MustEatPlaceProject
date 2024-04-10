import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/route_manager.dart';
import 'package:get/get.dart';
import 'package:must_eat_place_app_firebase/model/restaurant.dart';
import 'package:must_eat_place_app_firebase/view/insert_place.dart';
import 'package:must_eat_place_app_firebase/view/location.dart';
import 'package:must_eat_place_app_firebase/view/update_place.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Must-Eat Place'),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const Insert());
            },
            icon: const Icon(Icons.add_outlined),
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('musteatplace')
              .orderBy('name', descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final documents = snapshot.data!.docs;
            return ListView(
              children: documents.map((e) => _buildItemWidget(e)).toList(),
            );
          },
        ),
      ),
    );
  }

  // ---FUNCTIONS---
  Widget _buildItemWidget(QueryDocumentSnapshot<Object?> doc) {
    final restaurant = Restaurant(
      name: doc['name'] ,
      phone: doc['phone'] ,
      estimate: doc['estimate'] ,
      lat: doc['lat'] ,
      lng: doc['lng'] ,
      image: doc['image'] ,
    );
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        child: const Icon(Icons.delete_forever),
      ),
      key: ValueKey(doc.id),
      onDismissed: (direction) async {
        // Delete command
        await FirebaseFirestore.instance
            .collection('musteatplace')
            .doc(doc.id)
            .delete();
      },
      child: GestureDetector(
        onTap: () {
          Get.to(const Update(), arguments: [
            doc.id, // Document ID
            doc['name'] ,
            doc['phone'] ,
            doc['estimate'] ,
            doc['lat'] ,
            doc['lng'],
            doc['image'] ,
          ]);
        },
        child: Slidable(
          startActionPane:ActionPane(
            motion: const DrawerMotion(), 
            children: [
              SlidableAction(
                backgroundColor: Colors.orange,
                icon:  Icons.map_rounded,
                label: 'Map',
                onPressed: (context) {
                  Get.to(
                    ()=> const Location(),
                    arguments: [
                      double.parse(doc['lat']),
                      double.parse(doc['lng']),
                    ]
                  );
                },
              ),
            ]
            ),
          child: Card(
            child: ListTile(
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(
                      restaurant.image,
                      width: 80,
                    ),
                  ),
                  Text(
                    "NAME : ${restaurant.name}\n\nPHONE : ${restaurant.phone}",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
