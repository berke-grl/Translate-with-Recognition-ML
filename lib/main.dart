import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_ml_text/image_picker.dart';
import 'package:flutter_ml_text/text_recognaiton.dart';
import 'package:flutter_ml_text/translation.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  XFile? imageFile;

  bool textScanning = false;

  String translatedText = "";

  void translateFinish() {
    setState(() {
      isLoading = false;
      textScanning = false;
    });
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Text Recognition example"),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (textScanning)
                  const CircularProgressIndicator(color: Colors.green),
                imageFile == null && !textScanning
                    ? Container(
                        width: 300,
                        height: 300,
                        color: Colors.grey[300],
                      )
                    : Image.file(
                        File(imageFile!.path),
                      ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          backgroundColor: Colors.white,
                          shadowColor: Colors.grey[400],
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                        onPressed: () async {
                          imageFile =
                              await PickImage().getImage(ImageSource.gallery);
                          textScanning = true;
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.image,
                                size: 30,
                              ),
                              Text(
                                "Gallery",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      padding: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.grey,
                          backgroundColor: Colors.white,
                          shadowColor: Colors.grey[400],
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                        onPressed: () async {
                          imageFile =
                              await PickImage().getImage(ImageSource.camera);
                          textScanning = true;
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 5),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.camera_alt,
                                size: 30,
                              ),
                              Text(
                                "Camera",
                                style: TextStyle(
                                    fontSize: 13, color: Colors.grey[600]),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Container(
                  child: Column(
                    children: [
                      const Text(
                        "Scanned Text",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      FutureBuilder(
                        future: TextRecognation().getRecognisedText(imageFile),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator(
                                color: Colors.green);
                          } else if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Column(
                              children: [
                                Text(
                                  snapshot.data!,
                                  style: const TextStyle(fontSize: 15),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    isLoading = true;
                                    translatedText =
                                        await Translation.translate(
                                            snapshot.data!);

                                    setState(() {
                                      translateFinish();
                                    });
                                  },
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          color: Colors.white)
                                      : const Text("Translate"),
                                ),
                              ],
                            );
                          } else {
                            return const Text("An Error Has Occured !");
                          }
                        },
                      ),
                    ],
                  ),
                ),
                if (translatedText.isNotEmpty)
                  AlertDialog(
                    title: const Text("Translated Text"),
                    content: Text(translatedText),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
