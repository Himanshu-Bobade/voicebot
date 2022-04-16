// Copyright 2021 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sound_stream/sound_stream.dart';
import 'package:dialogflow_grpc/dialogflow_grpc.dart';
import 'package:dialogflow_grpc/generated/google/cloud/dialogflow/v2beta1/session.pb.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:external_app_launcher/external_app_launcher.dart';

import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter_contacts/flutter_contacts.dart';

/////////// merged
import 'package:voicebot/MySplashPage.dart';

// TODO import Dialogflow
DialogflowGrpcV2Beta1 dialogflow;

// String x = "sachin";
// String url1 = 'https://www.google.co.in/search?q=';
// String searchs = url1+x;
//
// void launchURL() async {
//   print(x);
//   print(url1);
//   print(searchs);
//   if (!await launch(searchs)) throw 'Could not launch $searchs';
// }

class Chat extends StatefulWidget {
  Chat({Key key}) : super(key: key);

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();

  bool _isRecording = false;

  RecorderStream _recorder = RecorderStream();
  StreamSubscription _recorderStatus;
  StreamSubscription<List<int>> _audioStreamSubscription;
  BehaviorSubject<List<int>> _audioStream;

  // TODO DialogflowGrpc class instance

  @override
  void initState() {
    super.initState();
    initPlugin();
  }

  @override
  void dispose() {
    _recorderStatus?.cancel();
    _audioStreamSubscription?.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlugin() async {
    _recorderStatus = _recorder.status.listen((status) {
      if (mounted)
        setState(() {
          _isRecording = status == SoundStreamStatus.Playing;
        });
    });

    await Future.wait([
      _recorder.initialize()
    ]);



    // TODO Get a Service account
    // Get a Service account
    final serviceAccount = ServiceAccount.fromString(
        '${(await rootBundle.loadString('assets/flutter.json'))}');
    // Create a DialogflowGrpc Instance
    dialogflow = DialogflowGrpcV2Beta1.viaServiceAccount(serviceAccount);

  }

  void stopStream() async {
    await _recorder.stop();
    await _audioStreamSubscription?.cancel();
    await _audioStream?.close();
  }

  void handleSubmitted(text) async {
    print(text);
    _textController.clear();

    //TODO Dialogflow Code
    ChatMessage message = ChatMessage(
      text: text,
      name: "You",
      type: true,
    );
    String fulfillmentText="";

    String string2 = "Google search ";
    String string3 = "Open ";
    String string4 = "object detection";
    String string5 = "send sms to ";
    String string6 = "call ";
    String string7 = "send mail to ";
    String string1 = text;
    if (string1.toLowerCase().contains(string2.toLowerCase())) {
      // Google search
      String trimmed = string1.replaceAll(string2, "");
      String url1 = 'https://www.google.co.in/search?q=';
      String searchs = url1+trimmed;
      if (!await launch(searchs)) throw 'Could not launch $searchs';
      fulfillmentText = "searching on web";
      //launchURL(searchs);
      trimmed = "";
    }
    else if(string1.toLowerCase().contains(string3.toLowerCase())){
      // Open App
      String trimmed = string1.toLowerCase().replaceAll(string3.toLowerCase(), "");
      print(trimmed);
      String appname;
      if (trimmed == "netflix"){
        appname = 'com.netflix.mediaclient';
      }
      else if(trimmed == "chrome"){
        appname = 'com.android.chrome';
      }
      else if(trimmed == "whatsapp"){
        appname = "com.whatsapp";
      }
      else if(trimmed == "instagram"){
        appname = "com.instagram.android";
      }
      else if(trimmed == "linkedin"){
        appname = "com.linkedin.android";
      }
      else if(trimmed == "youtube"){
        appname = "com.google.android.youtube";
      }
      else if(trimmed == "facebook"){
        appname = "com.facebook.katana";
      }
      else if(trimmed == "prime"){
        appname = "com.amazon.avod.thirdpartyclient";
      }
      else if(trimmed == "hotstar"){
        appname = "in.startv.hotstar";
      }
      else if(trimmed == "ola"){
        appname = "com.olacabs.customer";
      }
      else if(trimmed == "zomato"){
        appname = "com.application.zomato";
      }
      else if(trimmed == "google pay"){
        appname = "com.google.android.apps.nbu.paisa.user";
      }
      else if(trimmed == "spotify"){
        appname = "com.spotify.music";
      }
      else if(trimmed == "maps"){
        appname = "com.google.android.apps.maps";
      }
      else if(trimmed == "amazon"){
        appname = "in.amazon.mShop.android.shopping";
      }
      else if(trimmed == "zoom"){
        appname = "us.zoom.videomeetings";
      }
      else if(trimmed == "calendar"){
        appname = "com.google.android.calendar";
      }
      else if(trimmed == "google meet"){
        appname = "com.google.android.apps.meetings";
      }
      else if(trimmed == "weather"){
        appname = "net.oneplus.weather";
      }
      else if(trimmed == "telegram"){
        appname = "org.telegram.messenger";
      }
      else{
        appname = "com.google.android.youtube";
      }
      await LaunchApp.openApp(
        androidPackageName: appname,
        openStore: false,
      );
      fulfillmentText = "Opening application";
      trimmed = "";
    }
    else if(string1.toLowerCase().contains(string4.toLowerCase())){
      //object detection
      String trimmed = string1.toLowerCase().replaceAll(string4.toLowerCase(), "");
      print(trimmed);
      Navigator.push(
        context,
        //MaterialPageRoute(builder: (context) => SecondRoute()),
        MaterialPageRoute(builder: (context) => MySplashPage()),
      );
      fulfillmentText = "opening object detection";
      trimmed = "";
    }
    else if(string1.toLowerCase().contains(string5.toLowerCase())){
      // Call
      String trimmed = string1.toLowerCase().replaceAll(string5.toLowerCase(), "");
      print(trimmed);
      String temp_sms = trimmed.substring(0,10);
      String sms_body = trimmed.substring(11,);
      String final_sms = "sms:+91"+temp_sms+"?body="+sms_body;

      //launch('sms:+91888888888?body=Hi Welcome to Proto Coders Point');
      fulfillmentText ="sending sms";
      launch(final_sms);
      trimmed = "";
    }
    else if(string1.toLowerCase().contains(string6.toLowerCase())){
      // SMS
      String trimmed = string1.toLowerCase().replaceAll(string6.toLowerCase(), "");
      print(trimmed);
      if (await FlutterContacts.requestPermission()) {

        // Get all contacts (lightly fetched)
        List<Contact> contacts = await FlutterContacts.getContacts();
        print(contacts.first.phones);
        //print(contacts);
      }
      fulfillmentText = "calling";
      launch("tel://$trimmed");
      trimmed = "";
    }
    else if(string1.toLowerCase().contains(string7.toLowerCase())){
      String trimmed = string1.toLowerCase().replaceAll(string7.toLowerCase(), "");
      print(trimmed);
      var temp_mail_info = trimmed.split(" ");
      //var temp_mail_info = trimmed.split(".com");
      String temp_mail = temp_mail_info[0];
      String mail_body = temp_mail_info[1];
      String final_mail = "mailto:"+temp_mail+"?subject=This is Subject Title&body="+mail_body;
      print(final_mail);
      //final_mail = "mailto:schulershub@gmail.com?subject=This is Subject Title&body= gh";
      fulfillmentText = "Sending mail";
      launch(final_mail);
      trimmed = "";
    }
    else{
      // GO to dialogflow
      print("Inside dialogflow");
      DetectIntentResponse data = await dialogflow.detectIntent(text, 'en-US');
      //print(data.queryResult.fulfillmentText + "himanshu");
      fulfillmentText = data.queryResult.fulfillmentText;
    }

    setState(() {
      _messages.insert(0, message);
    });


    //CODE 1 starts //

    // print(fulfillmentText);
    // String tempvoicestring = fulfillmentText.toString();
    // print(tempvoicestring.runtimeType);
    // final FlutterTts flutterTts = FlutterTts();
    // //final TextEditingController textEditingController = TextEditingController();
    //
    // speak(String tempvoicestring) async{
    //   //await flutterTts.setLanguage("en-US");
    //   //await flutterTts.setPitch(1);
    //   await flutterTts.speak(tempvoicestring);
    // }
    //
    // speak(tempvoicestring);



    // CODE 1 ENds //
    print(fulfillmentText);
    String tempvoicestring = fulfillmentText.toString();
    print(tempvoicestring.runtimeType);

    FlutterTts flutterTts = FlutterTts();
    speak(String tempvoicestring) async{
      flutterTts.setLanguage("en-US");
      flutterTts.setVolume(1.0);
      flutterTts.setPitch(1.2);
      flutterTts.speak(tempvoicestring);
    }
    speak(tempvoicestring);


    ////////////////////////////////////////////
    ////////////////////////////////////////////
    if(fulfillmentText.isNotEmpty) {
      ChatMessage botMessage = ChatMessage(
        text: fulfillmentText,
        name: "Bot",
        type: false,
      );

      setState(() {
        _messages.insert(0, botMessage);
      });
    }

  }


  void handleStream() async {
    _recorder.start();

    _audioStream = BehaviorSubject<List<int>>();
    _audioStreamSubscription = _recorder.audioStream.listen((data) {
      //print("Hello");
      //print(data.runtimeType);
      _audioStream.add(data);
    });


    // TODO Create SpeechContexts
    // Create an audio InputConfig
    var biasList = SpeechContextV2Beta1(
        phrases: [
          'Dialogflow CX',
          'Dialogflow Essentials',
          'Action Builder',
          'HIPAA'
        ],
        boost: 20.0
    );

    // See: https://cloud.google.com/dialogflow/es/docs/reference/rpc/google.cloud.dialogflow.v2#google.cloud.dialogflow.v2.InputAudioConfig
    var config = InputConfigV2beta1(
        encoding: 'AUDIO_ENCODING_LINEAR_16',
        languageCode: 'en-US',
        sampleRateHertz: 16000,
        singleUtterance: false,
        speechContexts: [biasList]
    );

    // TODO Make the streamingDetectIntent call, with the InputConfig and the audioStream
    // TODO Get the transcript and detectedIntent and show on screen

    final responseStream = dialogflow.streamingDetectIntent(config, _audioStream);
    // Get the transcript and detectedIntent and show on screen
    responseStream.listen((data) {
      //print('----');
      setState(() {
        //print(data);
        String transcript = data.recognitionResult.transcript;
        String queryText = data.queryResult.queryText;
        //print(queryText+"hi");
        String fulfillmentText="";

        String string2 = "Google search ";
        String string3 = "Open ";
        String string4 = "object detection";
        String string5 = "send sms to ";
        String string6 = "call ";
        String string7 = "send mail to ";
        String string1 = queryText;
        if (string1.toLowerCase().contains(string2.toLowerCase())) {
          // Google search
          String trimmed = string1.replaceAll(string2, "");
          String url1 = 'https://www.google.co.in/search?q=';
          String searchs = url1+trimmed;
          //if (!await launch(searchs)) throw 'Could not launch $searchs';
          launch(searchs);
          fulfillmentText = "searching on web";
          //launchURL(searchs);
          trimmed = "";
        }
        else if(string1.toLowerCase().contains(string3.toLowerCase())){
          // Open App
          String trimmed = string1.toLowerCase().replaceAll(string3.toLowerCase(), "");
          print(trimmed);
          String appname;
          if (trimmed == "netflix"){
            appname = 'com.netflix.mediaclient';
          }
          else if(trimmed == "chrome"){
            appname = 'com.android.chrome';
          }
          else if(trimmed == "whatsapp"){
            appname = "com.whatsapp";
          }
          else if(trimmed == "instagram"){
            appname = "com.instagram.android";
          }
          else if(trimmed == "linkedin"){
            appname = "com.linkedin.android";
          }
          else if(trimmed == "youtube"){
            appname = "com.google.android.youtube";
          }
          else if(trimmed == "facebook"){
            appname = "com.facebook.katana";
          }
          else if(trimmed == "prime"){
            appname = "com.amazon.avod.thirdpartyclient";
          }
          else if(trimmed == "hotstar"){
            appname = "in.startv.hotstar";
          }
          else if(trimmed == "ola"){
            appname = "com.olacabs.customer";
          }
          else if(trimmed == "zomato"){
            appname = "com.application.zomato";
          }
          else if(trimmed == "google pay"){
            appname = "com.google.android.apps.nbu.paisa.user";
          }
          else if(trimmed == "spotify"){
            appname = "com.spotify.music";
          }
          else if(trimmed == "maps"){
            appname = "com.google.android.apps.maps";
          }
          else if(trimmed == "amazon"){
            appname = "in.amazon.mShop.android.shopping";
          }
          else if(trimmed == "zoom"){
            appname = "us.zoom.videomeetings";
          }
          else if(trimmed == "calendar"){
            appname = "com.google.android.calendar";
          }
          else if(trimmed == "google meet"){
            appname = "com.google.android.apps.meetings";
          }
          else if(trimmed == "weather"){
            appname = "net.oneplus.weather";
          }
          else if(trimmed == "telegram"){
            appname = "org.telegram.messenger";
          }
          else{
            appname = "com.google.android.youtube";
          }
          LaunchApp.openApp(
            androidPackageName: appname,
            openStore: true,
          );
          fulfillmentText = "Opening application";
          trimmed = "";
        }
        else if(string1.toLowerCase().contains(string4.toLowerCase())){
          //object detection
          String trimmed = string1.toLowerCase().replaceAll(string4.toLowerCase(), "");
          print(trimmed);
          Navigator.push(
          context,
          //MaterialPageRoute(builder: (context) => SecondRoute()),
          MaterialPageRoute(builder: (context) => MySplashPage()),
          );
          fulfillmentText = "opening object detection";
          trimmed = "";
        }
        else if(string1.toLowerCase().contains(string5.toLowerCase())){
          // Call
          String trimmed = string1.toLowerCase().replaceAll(string5.toLowerCase(), "");
          print(trimmed);
          String temp_sms = trimmed.substring(0,10);
          String sms_body = trimmed.substring(11,);
          String final_sms = "sms:+91"+temp_sms+"?body="+sms_body;

          //launch('sms:+91888888888?body=Hi Welcome to Proto Coders Point');
          fulfillmentText ="sending sms";
          launch(final_sms);
          trimmed = "";
        }
        else if(string1.toLowerCase().contains(string6.toLowerCase())){
          // SMS
          String trimmed = string1.toLowerCase().replaceAll(string6.toLowerCase(), "");
          print(trimmed);
          // if (await FlutterContacts.requestPermission()) {
          //
          //   // Get all contacts (lightly fetched)
          //   List<Contact> contacts = await FlutterContacts.getContacts();
          //   print(contacts.first.phones);
          //   //print(contacts);
          // }
          fulfillmentText = "calling";
          launch("tel://$trimmed");
          trimmed = "";
        }
        else if(string1.toLowerCase().contains(string7.toLowerCase())){
          String trimmed = string1.toLowerCase().replaceAll(string7.toLowerCase(), "");
          print(trimmed);
          var temp_mail_info = trimmed.split(" ");
          //var temp_mail_info = trimmed.split(".com");
          String temp_mail = temp_mail_info[0];
          String mail_body = temp_mail_info[1];
          String final_mail = "mailto:"+temp_mail+"?subject=This is Subject Title&body="+mail_body;
          print(final_mail);
          //final_mail = "mailto:schulershub@gmail.com?subject=This is Subject Title&body= gh";
          fulfillmentText = "Sending mail";
          launch(final_mail);
          trimmed = "";
        }
        else{
          // GO to dialogflow
          print("Inside dialogflow");
          fulfillmentText = data.queryResult.fulfillmentText;
        }

        /////////////////////////////////////////////////////////////////////////////////
        //String fulfillmentText = data.queryResult.fulfillmentText;

        if(fulfillmentText.isNotEmpty) {
          String tempvoicestring = fulfillmentText.toString();
          print(tempvoicestring.runtimeType);

          FlutterTts flutterTts = FlutterTts();
          speak(String tempvoicestring) async{
            flutterTts.setLanguage("en-US");
            flutterTts.setVolume(1.0);
            flutterTts.setPitch(1.2);
            flutterTts.speak(tempvoicestring);
          }
          speak(tempvoicestring);

          ChatMessage message = new ChatMessage(
            text: queryText,
            name: "You",
            type: true,
          );

          ChatMessage botMessage = new ChatMessage(
            text: fulfillmentText,
            name: "Bot",
            type: false,
          );

          _messages.insert(0, message);
          _textController.clear();
          _messages.insert(0, botMessage);

        }
        if(transcript.isNotEmpty) {
          _textController.text = transcript;
        }

      });
    },onError: (e){
      //print(e);
    },onDone: () {
      //print('done');
    });

  }

  // The chat interface
  //
  //------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Flexible(
          child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, int index) => _messages[index],
            itemCount: _messages.length,
          )),
      Divider(height: 1.0),
      Container(
          decoration: BoxDecoration(color: Theme.of(context).cardColor),
          child: IconTheme(
            data: IconThemeData(color: Theme.of(context).accentColor),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: _textController,
                      onSubmitted: handleSubmitted,
                      decoration: InputDecoration.collapsed(hintText: "Send a message"),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.0),
                    child: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () => handleSubmitted(_textController.text),
                    ),
                  ),
                  IconButton(
                    iconSize: 30.0,
                    icon: Icon(_isRecording ? Icons.mic_off : Icons.mic),
                    onPressed: _isRecording ? stopStream : handleStream,
                  ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(horizontal: 4.0),
                  //   child: IconButton(
                  //     icon: Icon(Icons.beach_access),
                  //     //onPressed: launchURL,
                  //     onPressed: () => print("on tap hua hai"),
                  //   ),
                  // ),
                ],
              ),
            ),
          )
      ),
    ]);


  }
}

//------------------------------------------------------------------------------------
// The chat message balloon
//
//------------------------------------------------------------------------------------
class ChatMessage extends StatelessWidget {
  ChatMessage({this.text, this.name, this.type});

  final String text;
  final String name;
  final bool type;

  List<Widget> otherMessage(context) {
    return <Widget>[
      new Container(
        margin: const EdgeInsets.only(right: 16.0),
        child: CircleAvatar(child: new Text('B')),
      ),
      new Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(this.name,
                style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(text),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> myMessage(context) {
    return <Widget>[
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(this.name, style: Theme.of(context).textTheme.subtitle1),
            Container(
              margin: const EdgeInsets.only(top: 5.0),
              child: Text(text),
            ),
          ],
        ),
      ),
      Container(
        margin: const EdgeInsets.only(left: 16.0),
        child: CircleAvatar(
            child: Text(
              this.name[0],
              style: TextStyle(fontWeight: FontWeight.bold),
            )),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: this.type ? myMessage(context) : otherMessage(context),
      ),
    );
  }
}

// class SecondRoute extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Second Route'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {},
//           child: const Text('Go back!'),
//         ),
//       ),
//     );
//   }
// }