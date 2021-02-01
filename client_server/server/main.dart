import 'dart:io';
int nClient = 0;

void main() {
  ServerSocket.bind(InternetAddress.anyIPv4, 3000).then(
          (server) {
        server.listen((client) {
          handleConnection(client);
        });
      }
  );
}

void handleConnection(Socket client){
  int n = ++nClient;
  print('client ' + nClient.toString() + ' connected from ' +
      '${client.remoteAddress.address}:${client.remotePort}');
  // manage data and retrun data
  client.listen((data) {
    String str = String.fromCharCodes(data).trim();
    print('[$n]: ' + str);
    client.write(str + '\n');
    // client.close(); try ....NOOOOOOO
  },
      onDone: () {client.close();
print("Connection Closed");
}
  );
}
