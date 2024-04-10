import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:must_eat_place_app/view/insert_place.dart';
import 'package:must_eat_place_app/view/locate_place.dart';
import 'package:must_eat_place_app/view/update_place.dart';
import 'package:must_eat_place_app/vm/database_handler.dart';
import 'package:get/get.dart';



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DatabaseHandler handler;

  @override
  void initState() {
    super.initState();
    handler = DatabaseHandler();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Must-Eat Place'),
        backgroundColor: Colors.orange[200],
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const Insert())!.then((value) => reloadData());
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: handler.queryRestaurant(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Slidable(
                  startActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.green,
                        icon: Icons.edit,
                        label: 'Edit',
                        onPressed: (context) {
                          Get.to(
                            () => const Update(),
                            arguments: [
                              snapshot.data![index].id,
                              snapshot.data![index].lat,
                              snapshot.data![index].lng,
                              snapshot.data![index].name,
                              snapshot.data![index].phone,
                              snapshot.data![index].estimate,
                              snapshot.data![index].image,
                            ],
                          )!.then((value) => reloadData());
                        },
                      ),
                    ],
                  ),
                  endActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        backgroundColor: Colors.red,
                        icon: Icons.delete_forever,
                        label: 'Delete',
                        onPressed: (id) {
                          selectDelete(snapshot.data![index].id);
                        },
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(
                        () => const LocatePlace(),
                        arguments: [
                          // parse the lat and long values cause theyre string
                          double.parse(snapshot.data![index].lat),
                          double.parse(snapshot.data![index].lng),
                        ],
                      );
                    },
                    child: Card(
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.memory(
                              snapshot.data![index].image,
                              width: 100,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Name : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(snapshot.data![index].name),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Phone : ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(snapshot.data![index].phone),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Date Added: ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(snapshot.data![index].initdate
                                          .substring(0,10)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }



//---FUNCTIONS---

  reloadData() {
    setState(() {
    handler.queryRestaurant();
    });
  }

  selectDelete(id) {
    showCupertinoModalPopup(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Message'),
        message: const Text('Are you sure you want to delete?'),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              handler.deleteRestaurant(id);
              setState(() {});
              Get.back();
            },
            child: const Text('Delete'),
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
      ),
    );
  }




}// end
