base class BaseModel {
  final String id;
  final DateTime createdAt;
  DateTime? updatedAt;
  DateTime? deletedAt;

  bool get isDeleted => deletedAt != null;

  BaseModel(this.id, this.createdAt, this.updatedAt, this.deletedAt);
}
