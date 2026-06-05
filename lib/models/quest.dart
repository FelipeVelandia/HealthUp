
class QuestModel {
  final int id;
  final String title;
  final String subtitle;
  final String reward;
  final dynamic icon;
  final dynamic color;
  bool isCompleted;

  QuestModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.reward,
    required this.icon,
    required this.color,
    this.isCompleted = false,
  });

  factory QuestModel.fromJson(Map<String, dynamic> json, dynamic iconData, dynamic colorData) {
    return QuestModel(
      id: json['id'],
      title: json['title'],
      subtitle: json['subtitle'],
      reward: json['reward'],
      icon: iconData,
      color: colorData,
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'reward': reward,
      'isCompleted': isCompleted,
    };
  }
}