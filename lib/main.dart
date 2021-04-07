import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Barcode and QR Code Scanner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BarcodeQrCodeScanner(title: 'Barcode and QR Code Scanner'),
    );
  }
}
class BarcodeQrCodeScanner extends StatefulWidget {
  final String title;
  BarcodeQrCodeScanner({Key key, this.title}) : super(key: key);
  @override
  _BarcodeQrCodeScannerState createState() => _BarcodeQrCodeScannerState();
}

class _BarcodeQrCodeScannerState extends State<BarcodeQrCodeScanner> {
  String _scanBarcode = '';

  @override
  void initState() {
    super.initState();
  }
  startBarcodeScanStream() async {
    FlutterBarcodeScanner.getBarcodeStreamReceiver(
        "#ff6666", "Cancel", true, ScanMode.BARCODE)
        .listen((barcode) => print(barcode));
  }
  Future<void> scanDocuments() async {
    String documentScanRes;
    try {
      documentScanRes = await FlutterBarcodeScanner.scanDocument(
          "#ff6666", "Cancel", true, ScanMode.DEFAULT);
      print(documentScanRes);
    } on PlatformException {
      documentScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;
    setState(() {
      _scanBarcode = documentScanRes;
    });
  }
  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }
  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }
  void _launchURL(String url) async {
    try{
      await canLaunch(url) ? await launch(url): throw {
        setState(() {
          _scanBarcode="The Link You Followed Has Expired.";
        })
      };
    }catch(error){
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.teal[900],
        centerTitle: true,
        elevation: 15.0,
      ),
        body: Builder(builder: (BuildContext context) {
          return Container(
              alignment: Alignment.center,
              child: Flex(
                  direction: Axis.vertical,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      color: Colors.teal,
                      icon: FaIcon(FontAwesomeIcons.barcode),
                      iconSize: 100.0,
                      tooltip: 'Scan Barcode Code',
                      onPressed: () => scanBarcodeNormal(),
                    ),
                    Text('Scan Barcode Code'),
                    Divider(color: Colors.tealAccent,height: 16,thickness: 2,indent: 100,endIndent: 100,),
                    IconButton(
                      color: Colors.teal,
                      icon: Icon(Icons.qr_code_scanner),
                      iconSize: 100,
                      tooltip: 'Scan QR Code',
                      onPressed: () => scanQR(),
                    ),
                    Text('Scan QR Code'),
                    Divider(color: Colors.tealAccent,height: 16,thickness: 2,indent: 100,endIndent: 100,),
                    IconButton(
                      color: Colors.teal,
                      icon: FaIcon(FontAwesomeIcons.newspaper),
                      iconSize: 100,
                      tooltip: 'Scan Document Code',
                      onPressed: () => scanDocuments(),
                    ),
                    Text('Scan Document Code'),
                    Divider(),
                    Container(
                      height: 120.0,
                      width: 350,
                      padding: EdgeInsets.symmetric(horizontal: 20.0,vertical: 25.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.teal,width: 2),
                      ),
                      child: Center(
                        child: Text('Scan result:\n$_scanBarcode\n',
                            style: TextStyle(fontSize: 18,color: Colors.teal)),
                      ),
                    ),
                    SizedBox(height: 30,),
                    RaisedButton(
                        color: Colors.teal[900],
                        textColor: Colors.white,
                        onPressed: () => _launchURL(_scanBarcode),
                        child: Text("Go to Link")),
                  ]));
        }
        )
    );
  }
}