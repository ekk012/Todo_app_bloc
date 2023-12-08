class Task {
  final String title;
  final int? id;
  final int? userId;
  final bool isComplete;

  Task( {required this.title, this.isComplete = false,this.id, this.userId,});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'isComplete': isComplete,
    };
  }

  static Task fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      userId: map['userId'],
      title: map['title'] ?? '',
      isComplete: map['isComplete'] ?? false,
    );
  }

  String encodeJson() {
    return toMap().toString();
  }

  static Map<String, dynamic> decodeJson(String json) {
    Map<String, dynamic> map = Map<String, dynamic>.from(json as Map);
    return map;
  }

copyWith({int? id, int? userId, String? title, bool? isComplete}) {
    return Task(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        title: title ?? this.title,
        isComplete: isComplete ?? this.isComplete);
  }

}
