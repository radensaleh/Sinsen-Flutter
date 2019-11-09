import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/rendering.dart';
import 'package:sinsen/network_util.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  static String tag = 'home-page';

  final String nama, nim, kelas, jurusan;
  HomePage({Key key, this.nama, this.nim, this.kelas, this.jurusan})
      : super(key: key);

  @override
  _HomePage createState() => new _HomePage();
}

class _HomePage extends State<HomePage> {
  String barcode = "";

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final foto = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: CircleAvatar(
          radius: 72.0,
          backgroundColor: Colors.transparent,
        ),
      ),
    );

    final welcome = Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        'Selamat Datang',
        style: TextStyle(fontSize: 28.0, color: Colors.white),
      ),
    );

    final nama = Padding(
      padding: EdgeInsets.symmetric(vertical: 1.0),
      child: Text(
        widget.nama + ', ' + widget.nim,
        style: TextStyle(fontSize: 18.0, color: Colors.black),
      ),
    );

    final jurusan = Padding(
      padding: EdgeInsets.symmetric(vertical: 1.0),
      child: Text(
        widget.kelas + ', ' + widget.jurusan,
        style: TextStyle(fontSize: 16.0, color: Colors.black),
      ),
    );

    final salam = Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Center(
        child: new Text(
          'Lakukan absen dengan cara mudah dengan melakukan klik button di bawah lalu scan QR yang diberikan dosen',
          style: TextStyle(fontSize: 14.0, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );

    final loginButton = Padding(
      //padding: EdgeInsets.symmetric(vertical: 145.0),
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Material(
        borderRadius: BorderRadius.circular(50.0),
        shadowColor: Colors.lightBlueAccent.shade100,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: scan,
          //  Navigator.of(context).pushNamed(HomePage.tag);

          color: Colors.white,
          child:
              Text('SCAN QR', style: TextStyle(color: Colors.lightBlueAccent)),
        ),
      ),
    );

    // final test = Padding(
    //   padding: EdgeInsets.symmetric(vertical: 10.0),
    //   child: Text(
    //     '$barcode',
    //     style: TextStyle(fontSize: 15.0, color: Colors.white),
    //   ),
    // );

    absen('$barcode', widget.nim);

    final body = Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.blue,
          Colors.lightBlueAccent,
        ]),
      ),
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          foto,
          welcome,
          nama,
          jurusan,
          salam,
          loginButton,
          // test
        ],
      ),
    );

    return Scaffold(
      body: body,
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'The user did not grant the camera permission!';
        });
      } else {
        setState(() => this.barcode = 'Unknown error: $e');
      }
    } on FormatException {
      setState(() => this.barcode = '');
    } catch (e) {
      setState(() => this.barcode = 'Unknown error: $e');
    }
  }

  absen(qrcode, nim) async {
    final response =
        await http.post(BaseUrl.absen, body: {"kd_qr": qrcode, "nim": nim});
    final data = jsonDecode(response.body);

    int error = data['error'];
    String pesan = data['message'];

    if (error == 0) {
      _showDialog(pesan);
    } else {
      _showDialog(pesan);
    }
  }

  // user defined function
  void _showDialog(pesan) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("PESAN!"),
          content: new Text(pesan),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
