import 'dart:io';
import 'package:flutter/material.dart';
// global variable

void main() =>runApp(MyApp());


class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  Socket socketServer; //socket server, gestistce la conessione col server

  MyHomePage({ this.title});
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  String displayText=""; //stringa visualizzata sul display
  TextEditingController controller; // il controller per gestire il testo inserito dal utente ne TextFormField

  _MyHomePageState() {
    controller = TextEditingController();
    controller.addListener((){//aggiunge un ascoltatore dell ogetto controller
    });
  }


  void write(String message){
    widget.socketServer.write(message);
  }//metodo manda mesaggio al server

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(displayText),
                    Form(
                      child: TextFormField(//Il campo dove viene inserito il testo
                        controller: controller,
                        decoration: InputDecoration(labelText: 'Write a message'),
                      ),
                    ),

                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                           RaisedButton(
                             onPressed: (){
                               widget.socketServer.destroy();//ferma la conessione col server distruggendo il socket socketServer
                               setState(() {
                                 displayText="disconnected";
                               });
                               },//ferma la conessione al server
                             color: Colors.red,
                             child: Icon(Icons.cancel),
                           ),
                         RaisedButton(//Floating action button
                            onPressed: ()async {
                                widget.socketServer = await Socket.connect("192.168.43.53", 3000);//aspetta la conessione al server specificato
                               setState(() {
                                 displayText="connected";//la stringa r visalizzata sul display
                               });
                                widget.socketServer.listen((data){//lo stream ascolta la informazione dal server
                                  setState(() {
                                    displayText = String.fromCharCodes(data);//riceve il testo da visuallizare
                                  });
                                });
                            },
                           color: Colors.green,
                         child: Icon(Icons.check),
                         ),
                          RaisedButton(
                            onPressed: () {
                              write(controller.text);},//manda il mesaggio al server
                            child: Icon(Icons.send),
                            color: Colors.lightBlue,
                          ),

                        ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

