class UserModel {
  final int? id; // Make id nullable to handle cases where it might be null
  final String name;
  final String email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  // Factory method for creating a UserModel from JSON data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null || json['name'] == null || json['email'] == null) {
      throw FormatException("Invalid JSON format for UserModel");
    }

    return UserModel(
      id: json['id'] as int?, // Allow id to be nullable
      name: json['name'] as String,
      email: json['email'] as String,
    );
  }

  // Method for converting UserModel to JSON (if needed for sending data)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
