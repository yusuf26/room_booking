
import 'package:booking_room_app/widgets/drawer.dart';
import 'package:booking_room_app/widgets/filter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class ReportPage extends StatefulWidget {
  const ReportPage({key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  bool _isFirstLoadRunning = true;
  late ScrollController _controller;

  void _loadMore() async {}


  @override
  void initState() {
    super.initState();
    _controller = ScrollController()..addListener(_loadMore);
  }

  final GlobalKey<ScaffoldState> _keyReport = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _keyReport,
        appBar: AppBar(
          title: const Text("Report"),
          actions: [
            IconButton(
              icon: Icon(IconData(0xf068, fontFamily: 'MaterialIcons')), // Use any icon you prefer
              onPressed: () {
                _keyReport.currentState!.openEndDrawer();
              },
            ),
          ],
        ),
        drawer: SideMenu(),
        endDrawer: FilterDrawer(),
        body: _isFirstLoadRunning
            ? Center(
          child: CircularProgressIndicator(),
        )
            : Container());
  }
}
