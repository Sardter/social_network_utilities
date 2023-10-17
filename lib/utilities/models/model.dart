abstract class Model {
  final int id;

  const Model({required this.id});

  @override
  bool operator ==(Object other) => other is Model && id == other.id;

  Map<String, dynamic> toJson();

  @override
  int get hashCode => id;
}


abstract class ModelFactory<T extends Model> {
  T fromJson(Map<String, dynamic> json);
}