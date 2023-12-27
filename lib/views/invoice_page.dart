import 'package:booking_room_app/model/Invoice.dart';
import 'package:booking_room_app/network/InvoiceService.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'login_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/drawer.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;

class InvoicePage extends StatefulWidget {
  const InvoicePage({Key? key}) : super(key: key);

  @override
  _InvoicePageState createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  String email = "";

  late List<Invoice>? _invoiceModel = [];
  bool _isFirstLoadRunning = false;
  late ScrollController _controller;
  double? progress;
  String? fileName;

  getPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var islogin = pref.getBool("is_login");
    if (islogin != null && islogin == true) {
      setState(() {
        email = pref.getString("email")!;
      });
    } else {
      Navigator.of(context, rootNavigator: true).pop();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const PageLogin(),
        ),
        (route) => false,
      );
    }
  }

  void _firstLoad() async {
    setState(() {
      _isFirstLoadRunning = true;
    });
    InvoiceService().getInvoice().then((value) {
      setState(() {
        _invoiceModel = value;
        _isFirstLoadRunning = false;
      });
    });
  }

  Future _downloadPDF(String title, String fileUrl) async {
    // final pdf = pw.Document();

    // pdf.addPage(
    //   pw.Page(
    //     build: (pw.Context context) => pw.Center(
    //       child: pw.Text('Hello World!'),n
    //     ),
    //   ),
    // );

    // final file = File('example.pdf');
    // await file.writeAsBytes(await pdf.save());
  }

  void _loadMore() async {}
  @override
  void initState() {
    getPref();
    super.initState();
    _firstLoad();
    _controller = ScrollController()..addListener(_loadMore);
  }

  @override
  void dispose() {
    _controller.removeListener(_loadMore);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Invoice Page"),
        ),
        drawer: SideMenu(),
        body: _isFirstLoadRunning
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(children: [
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: _controller,
                    shrinkWrap: true,
                    itemCount: _invoiceModel!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                          elevation: 4.0,
                          margin: new EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 6.0),
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Color.fromRGBO(64, 75, 96, .9)),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10.0, vertical: 10.0),
                                leading: Container(
                                  padding: EdgeInsets.only(right: 12.0),
                                  decoration: new BoxDecoration(
                                      border: new Border(
                                          right: new BorderSide(
                                              width: 1.0,
                                              color: Colors.white24))),
                                  child: Icon(
                                      FontAwesomeIcons.fileInvoiceDollar,
                                      color: Colors.white),
                                ),
                                title: Text(
                                  "${_invoiceModel![index].invoice_number} - ${_invoiceModel![index].customer_name} - ${_invoiceModel![index].room_name}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                                trailing: IconButton(
                                  icon: Icon(FontAwesomeIcons.download,
                                      color: Colors.white, size: 22.0),
                                  onPressed: () {
                                    _downloadPDF(
                                        _invoiceModel![index].invoice_number,
                                        _invoiceModel![index].file_url);
                                  },
                                ),
                              )));
                    },
                  ),
                )
              ]));
  }
}
