class Welcome {
  Welcome({
    required this.greeting,
    required this.instructions,
  });

  factory Welcome.fromJson(Map<String, dynamic> json) {
    return Welcome(
      greeting: json['greeting'] as String,
      instructions: List<String>.from(
        (json['instructions'] as List).map((x) => x),
      ),
    );
  }

  String greeting;
  List<String> instructions;

  Map<String, dynamic> toJson() {
    return {
      'greeting': greeting,
      'instructions': List<dynamic>.from(instructions.map((x) => x)),
    };
  }
}
