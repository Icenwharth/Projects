import 'dart:convert';

import 'package:flutter/material.dart';
import 'chat_message.dart';
import 'dart:io';


String getNome(){
  return username;
}
void setName(String name){
  username = name;
}

String username;

class ChatScreen extends StatefulWidget {

  TextEditingController _userController = TextEditingController();
  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<ChatMessage> _messages = <ChatMessage>[];
  Socket socketServer; //socket server, gestistce la conessione col server

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Socket.connect("192.168.43.53", 3000).then((socketServer) {
      this.socketServer = socketServer;

      showDialog(
          context: context,
          builder: (context) {
            return Dialog(
                child: Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.15,
                    child: Center(
                      child: Padding(
                          padding: EdgeInsets.all(10),
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              TextField(
                                controller: widget._userController,
                                decoration: InputDecoration(
                                    hintText: "Username"
                                ),
                              ),
                              RaisedButton(
                                child:Text("Imposta"),
                                onPressed: (){
                                  setName(widget._userController.text.length == 0 ? null : widget._userController.text);
                                  Navigator.of(context).pop();
                                },
                              )
                            ],
                          )
                      ),
                    )
                )
            );
          }
      );


      socketServer.listen((data) { //lo stream ascolta la informazione dal server se riceve il messagio dal server lo manda indietro
        _handleSubmitted(String.fromCharCodes(data)); //gestisce il mesaggio ricevuto dal server
      });
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    ChatMessage message;
    try{
      Map<String,dynamic> data = jsonDecode(text);

      message = ChatMessage(
        text: data['messaggio'],
        user: data['user'],
      );
    } on FormatException {
      message = ChatMessage(
        text: text,
        user: "Server",
      );
    }

    setState(() {
      _messages.insert(0, message);
    });
  }

  void write(String message){
    socketServer.write(jsonEncode({
      'user' : username,
      'messaggio' : message
    }));

  }//metodo manda mesaggio al server


  Widget _textComposerWidget() {
    return IconTheme(
      data: IconThemeData(color: Colors.blue),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                decoration:

                InputDecoration.collapsed(hintText:"Send a message"),
                controller: _textController,
                onSubmitted: _handleSubmitted,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    write(_textController.text);// manda il messagio al server
                    setState(() {
                      _messages.insert(0, ChatMessage(
                        text: _textController.text,
                        user: username,
                      ));
                    });
                  }
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: <Widget>[
        Flexible(
          child: ListView.builder(
            padding: EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, int index) => _messages[index],
            itemCount: _messages.length,
          ),
        ),
        Divider(
          height: 1.0,
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: _textComposerWidget(),
        ),
      ],
    );
  }
}
