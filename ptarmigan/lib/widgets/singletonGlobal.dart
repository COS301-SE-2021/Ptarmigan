class Singleton {
  static final Singleton _singleton = Singleton._internal();
  String userEmail = "";
  factory Singleton() {
    return _singleton;
  }

  Singleton._internal();
}
