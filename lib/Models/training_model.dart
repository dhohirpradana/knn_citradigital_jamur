class TrainingModel {
  final int id;
  final int state;
  final int r;
  final int g;
  final int b;
  final base64;

  TrainingModel({this.id, this.state, this.r, this.g, this.b, this.base64});
  Map<String, dynamic> toMap() {
    // used when inserting data to the database
    return <String, dynamic>{
      "id": id,
      "state": state,
      "r": r,
      "g": g,
      "b": b,
      "base64": base64
    };
  }
}
