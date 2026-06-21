import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService{
    static late IO.Socket socket;

    static void connect() {

      socket = IO.io(
        'http://192.168.1.7:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build(),
      );

      socket.connect();

      socket.onConnect((_) {
        print("Socket Connected");
      });

      socket.onDisconnect((_) {
        print("Socket Disconnected");
      });

      socket.onConnectError((data) {
        print("Connect Error: $data");
      });

      socket.onError((data) {
        print("Socket Error: $data");
      });
    }
}