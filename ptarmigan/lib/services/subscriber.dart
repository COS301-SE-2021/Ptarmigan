

class Subscriber {
  int subscribe(int feed) {
    int ret;

    if (feed == 1) {
      ret = 0;
    } else {
      ret = 1;
    }

    return ret;
  }
}