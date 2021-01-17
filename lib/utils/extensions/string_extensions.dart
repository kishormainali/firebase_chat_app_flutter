extension StringX on String {
  bool get isEmail => RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z]+\.[a-zA-Z]+").hasMatch(this);

  String get shortName => this.split(" ").map((e) => e[0].toUpperCase()).join("");
}
