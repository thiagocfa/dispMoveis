class Listab {
  String item;
  String id;

  Listab(this.item, this.id);

  Listab.fromMap(Map<String, dynamic> map, String id) {
    this.item = map['item'];
    this.id = id ?? '';
  }
}
