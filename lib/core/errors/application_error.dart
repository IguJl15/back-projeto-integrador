base class ApplicationError {
  final int statusCode;
  final String error;

  ApplicationError(this.statusCode, this.error);

  Map<String, dynamic> toMap() => {"title": error};
}