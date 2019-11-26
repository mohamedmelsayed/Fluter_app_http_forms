import 'dart:convert';
import 'dart:developer';
import 'dart:developer' as prefix0;

import 'package:flutter/material.dart';
import 'package:hello_world/services/contact.dart';
import 'dart:math';

import 'package:hello_world/services/httpservice.dart';

Random random = Random();

class ForthFragment extends StatelessWidget {
  ForthFragment(){
    getJobs();
  }
  String s2;
  getJobs() async {
       var contactService = new HttpService();
       s2= await contactService.get("jobs");
       List<Job> jobs=contactService.fromJson(s2);
       prefix0.log(jobs[0].customername);
 
  }
 
  // static List messages = [
  //   "Hey, how are you doing?",
  //   "Are you available tomorrow?",
  //   "It's late. Go to bed!",
  //   "This cracked me up 😂😂",
  //   "Flutter Rocks!!!",
  //   "The last rocket🚀",
  //   "Griezmann signed for Barca❤️❤️",
  //   "Will you be attending the meetup tomorrow?",
  //   "Are you angry at something?",
  //   "Let's make a UI serie.",
  //   "Can i hear your voice?",
  // ];
  // List groups = List.generate(
  //     13,
  //     (index) => {
  //           "name": "Group ${random.nextInt(20)}",
  //           "dp": "assets/cm${random.nextInt(10)}.jpeg",
  //           "msg": messages[random.nextInt(10)],
  //           "counter": random.nextInt(20),
  //           "time": "${random.nextInt(50)} min ago",
  //           "isOnline": random.nextBool(),
  //         });
  @override
  Widget build(BuildContext context) {
    return new Text("data");
    // TODO: implement build
    // return new Center(
    //   child: ListView.separated(
    //     padding: EdgeInsets.all(10),
    //     separatorBuilder: (BuildContext context, int index) {
    //       return Align(
    //         alignment: Alignment.centerRight,
    //         child: Container(
    //           height: 0.5,
    //           width: MediaQuery.of(context).size.width / 1.3,
    //           child: Divider(),
    //         ),
    //       );
    //     },
    //     itemCount: groups.length,
    //     itemBuilder: (BuildContext context, int index) {
    //       Map chat = groups[index];
    //       return ChatItem(
    //         dp: chat['dp'],
    //         name: chat['name'],
    //         isOnline: chat['isOnline'],
    //         counter: chat['counter'],
    //         msg: chat['msg'],
    //         time: chat['time'],
    //       );
    //     },
    //   ),
    // );
    
  }
}

class ChatItem extends StatefulWidget {
  final String dp;
  final String name;
  final String time;
  final String msg;
  final bool isOnline;
  final int counter;

  ChatItem({
    Key key,
    @required this.dp,
    @required this.name,
    @required this.time,
    @required this.msg,
    @required this.isOnline,
    @required this.counter,
  }) : super(key: key);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: Stack(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage(
                "${widget.dp}",
              ),
              radius: 25,
            ),
            Positioned(
              bottom: 0.0,
              left: 6.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                height: 11,
                width: 11,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.isOnline ? Colors.greenAccent : Colors.grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    height: 7,
                    width: 7,
                  ),
                ),
              ),
            ),
          ],
        ),
        title: Text(
          "${widget.name}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text("${widget.msg}"),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              "${widget.time}",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 11,
              ),
            ),
            SizedBox(height: 5),
            widget.counter == 0
                ? SizedBox()
                : Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 11,
                      minHeight: 11,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 1, left: 5, right: 5),
                      child: Text(
                        "${widget.counter}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
          ],
        ),
        onTap: () {
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (BuildContext context) {
                // return Conversation();
              },
            ),
          );
        },
      ),
    );
  }
}
