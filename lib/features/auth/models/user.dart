class User {
  final String id;
  final String username;
  final String email;
  final int credits;
  final int paidCredits;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.credits,
    required this.paidCredits,
    required this.createdAt,
    required this.updatedAt,
  });

  int get totalCredits => credits + paidCredits;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      credits: json['credits'] ?? 0,
      paidCredits: json['paidCredits'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'credits': credits,
      'paidCredits': paidCredits,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}