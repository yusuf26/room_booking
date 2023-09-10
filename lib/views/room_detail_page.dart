import 'package:flutter/material.dart';
import '../model/Room.dart';
import '../network/RoomService.dart';
import 'room_new_page.dart';
import 'room_page.dart';

class RoomDetail extends StatefulWidget {
  Room room;
  RoomDetail({required this.room});

  @override
  _RoomDetailState createState() => _RoomDetailState(this.room);
}

class _RoomDetailState extends State<RoomDetail> {
  // late Future<List<Episode>> episodes;
  final Room room;
  _RoomDetailState(this.room);
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isSuccess = true;

  void _deleteRoom() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Warning"),
            content: Text("Are you sure want to delete data ?"),
            actions: <Widget>[
              TextButton(
                child: Text("Yes"),
                onPressed: () {
                  RoomService().deleteRoom(room.id).then((isSuccess) {
                    if (isSuccess!) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                          'Delete data successful',
                          style: const TextStyle(fontSize: 16),
                        )),
                      );
                      Navigator.of(context).pushReplacementNamed('/room');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                          'Delete data failed',
                          style: const TextStyle(fontSize: 16),
                        )),
                      );
                    }
                  });
                },
              ),
              ElevatedButton(
                child: Text("No"),
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.of(_scaffoldKey.currentContext!).pop();
                },
              )
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    // episodes = fetchEpisodes(widget.item);
    isSuccess = false;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room Detail'),
      ),
      key: _scaffoldKey,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Card(
            elevation: 4.0,
            color: Colors.blue[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Name : ${room.room_name}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Type : ${room.type}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Location : ${room.location}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Price : ${room.price_format}",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.white),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NewRoom(id: room.id),
                            ),
                          );
                        },
                        child: Text('Edit'),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red, // Background color
                        ),
                        onPressed: () {
                          _deleteRoom();
                        },
                        child: Text('Delete'),
                      ),
                    ],
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
