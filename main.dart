import 'dart:io';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Upload demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future uploadFile() async {
    String name = (Random().nextInt(8000) + 1000).toString();
    final path = "files/${name}${pickedFile!.name}";
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    setState(() {
      uploadTask = ref.putFile(file);
    });

    final snapshot = await uploadTask!.whenComplete(() {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    print("Download link: ${urlDownload}");

    setState(() {
      uploadTask = null;
    });
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    setState(() {
      pickedFile = result.files.first;
    });
  }

/*void addReclam() async {
    var _token;
    var request=await http.MultipartRequest('POST', Uri.parse("it.net.tm/telfun/api/add"))
      ..fields.addAll({
        "category_id": "1",
        "user_id": "5",
        "name": "demo",
        "mark": "Iphone",
        "price": "1300TMT",
        "about": "about",
      })
      ..headers.addAll({'Content-Type': 'multipart/form-data'})
      ..files
          .add(await http.MultipartFile.fromPath('image', pickedFile!.path!))

 .then((response) {
        if (response.statusCode == 200) {
          _token = (json.decode(response.body));
          print("***${(_token)}");
        } else {
          print("***Mesele bar!!!");
        }
      })
;

    var response = await request.send();
    if (response.statusCode == 201) {
      return print("true");
    } else {
      return print("false");
    }
  }*/


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (pickedFile != null)
              Expanded(
                child: Container(
                  child: Center(
                    child: Image.file(
                      File(pickedFile!.path!),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ElevatedButton(onPressed: selectFile, child: Text("Select file")),
            SizedBox(height: 20),
         /*   ElevatedButton(onPressed: addReclam, child: Text("Add file")),
            SizedBox(height: 40),*/
            ElevatedButton(onPressed: uploadFile, child: Text("Upload file")),
            SizedBox(height: 20),
            buildProgres(),
          ],
        ),
      ),
    );
  }

  Widget buildProgres() => StreamBuilder<TaskSnapshot>(
      stream: uploadTask?.snapshotEvents,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print("***ERROR");
          return SizedBox(
            child: Text("Connect internet!"),
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data!;
          double progres = data.bytesTransferred / data.totalBytes;
          return SizedBox(
            height: 50,
            child: Stack(
              fit: StackFit.expand,
              children: [
                LinearProgressIndicator(
                  value: progres,
                  backgroundColor: Colors.grey,
                  color: Colors.green,
                ),
                Center(
                    child: Text(
                  "${(progres * 100).roundToDouble()}%",
                  style: TextStyle(color: Colors.white),
                )),
              ],
            ),
          );
        } else {
          return SizedBox();
        }
      });
}
/*

import 'package:flutter/material.dart';
import 'image_picker.dart';
void main() {

  runApp(App());
}
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(

      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ImageUpload(),
      ),
    );
  }
}
*/
