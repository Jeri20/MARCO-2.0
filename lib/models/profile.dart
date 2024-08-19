class Profile {
  String name;
  String userClass;
  int exp;
  int level;

  Profile({
    required this.name,
    required this.userClass,
    required this.exp,
    required this.level,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'userClass': userClass,
      'exp': exp,
      'level': level,
    };
  }

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      name: json['name'],
      userClass: json['userClass'],
      exp: json['exp'],
      level: json['level'],
    );
  }
}
