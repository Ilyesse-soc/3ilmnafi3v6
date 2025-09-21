class User {
  final String id;
  final String username;
  final String email;
  final String? passwordHash;
  final bool isAdmin;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.passwordHash,
    this.isAdmin = false,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      passwordHash: json['passwordHash'],
      isAdmin: json['isAdmin'] ?? false,
      createdAt: json['createdAt'] != null 
          ? DateTime.tryParse(json['createdAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': passwordHash,
      'isAdmin': isAdmin,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}

