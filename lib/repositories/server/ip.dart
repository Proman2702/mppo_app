class Ip {
  static String? _ip; // Айпи, если пользователь решит поменять его
  String defaultIp = 'http://5.tcp.eu.ngrok.io:16781/upload'; // Поле для айпи сервера

  void setIp(String ip) {
    _ip = ip;
  }

  void resetIp() {
    _ip = null;
  }

  String get getIp => _ip ?? defaultIp;
}
