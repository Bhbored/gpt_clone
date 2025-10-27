class Sender {
  final String name;
  final String avatarAssetPath;
  final String id;
  Sender({required this.name, required this.avatarAssetPath, String? id})
    : id = id ?? name;
}
