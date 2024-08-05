import 'package:flutter/material.dart';
import 'package:flutter_gp5/extensions/build_context_extensions.dart';
import 'package:flutter_gp5/utils/image_utils.dart';
import 'package:intl/intl.dart';

import '../../models/user.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //TestData
  final userData=[
    const User(
        email:"dochevchill@gmail.com",
        id: "22",
        name: "GalinDochev",
        phone:"0887289760",
        type:"patient",
        workplace: "",
        speciality: ""
    ),
    const User (
        email: "johnsmith@example.com",
        id: "23",
        name: "John Smith",
        phone: "1234567890",
        type: "doctor",
        workplace: "City Hospital",
        speciality: "Cardiology"
    ),

    const User(
        email: "jane.doe@example.com",
        id: "24",
        name: "Jane Doe",
        phone: "0987654321",
        type: "nurse",
        workplace: "County Clinic",
        speciality: "Pediatrics"
    ),

    const User(
        email: "alex.brown@example.com",
        id: "25",
        name: "Alex Brown",
        phone: "5551234567",
        type: "patient",
        workplace: "",
        speciality: ""
    ),

    const User(
        email: "lisa.white@example.com",
        id: "26",
        name: "Lisa White",
        phone: "5559876543",
        type: "doctor",
        workplace: "General Hospital",
        speciality: "Dermatology"
    ),

    const User(
      email: "mike.jones@example.com",
      id: "27",
      name: "Mike Jones",
      phone: "5554567890",
      type: "patient",
      workplace: "",
      speciality: "",
    )
  ];
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(ImageUtils.logox),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor:Colors.transparent,
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          centerTitle: true,
          title: const Text('Messages',style: TextStyle(fontWeight:  FontWeight.bold),),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                SizedBox(width: context.setWidth(3)),
               const SizedBox(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child:  Text(
                      "Recents",
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: Colors.grey),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: context.setHeight(0.3),),
            SizedBox(
         height: context.setHeight(10),
         child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 10,
            itemBuilder: (context, index) {
              return  SizedBox(
                width: context.setWidth(22),
                child:  Column(
                  children: [
                     const CircleAvatar(
                      radius:35,
                      backgroundImage:  NetworkImage("https://i.pravatar.cc/200"),
                      ),
                    SizedBox(height: context.setHeight(1),)
                  ],
                ),
              );
            },
          ),
               ),
            Container(
              height: context.setHeight(66),
              child: ListView.builder(scrollDirection: Axis.vertical,
              itemCount: 10,
              itemBuilder: (context,index){
                return Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: context.setHeight(0.7),
                      ),
                      Container(
                        height: context.setHeight(12),
                        width: context.setWidth(95),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white.withOpacity(0.8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              spreadRadius: 1,
                              blurRadius: 15,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child:Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                               CircleAvatar(
                                backgroundImage: const NetworkImage("https://i.pravatar.cc/200"),
                                radius: 40,
                              ),
                              Column(
                                 mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                 const Text("Dr. Todor Todorov",overflow:TextOverflow.ellipsis,
                                      style: TextStyle(fontSize: 14,color: Colors.black,fontWeight: FontWeight.bold)),
                                  SizedBox(height: context.setHeight(0.8),),
                                 const Text("random chat sentence",style: TextStyle(fontSize: 12,color: Colors.black,fontWeight: FontWeight.w400),),
                                  SizedBox(height: context.setHeight(1.2),)
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(height: context.setHeight(2),),
                                  SizedBox(
                                    width: context.setWidth(17),
                                    child:
                                    Text(DateFormat('h:mm a').format(DateTime.now(),),
                                      style: const  TextStyle(fontSize: 10 ,color: Colors.grey,)),),
                                  Container(
                                    width: context.setWidth(5.3),
                                    height: context.setHeight(5.2),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF6750A4), // Background color
                                      shape: BoxShape.circle, // Makes the container circular
                                    ),
                                    child: const Align(alignment:Alignment.center,
                                        child:
                                        Text(
                                          "1",style: TextStyle(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w500),
                                        )
                                    ),
                                  ),
                                  SizedBox(height: context.setHeight(2),),
                                ],
                              )
                            ],
                          )
                        ),
                      ),
                    ],
                  ),
                );

              },),
            ),
            NavigationBar(destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.description),
                  label: 'Trials'
              ),
              NavigationDestination(
                  icon: Icon(Icons.trending_up),
                  label: 'Data'
              ),
              NavigationDestination(
                  icon: Icon(Icons.home_filled),
                  label: 'Home'
              ),
              NavigationDestination(
                  icon: Icon(Icons.email),
                  label: 'Messages'
              ),
              NavigationDestination(
                  icon: Icon(Icons.person_rounded),
                  label: 'Profile'
              ),
            ]),
          ],
        ),
      ),
    );
  }
}
