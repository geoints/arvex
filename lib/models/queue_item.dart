class QueueItem {
  const QueueItem({required this.trackId, required this.order});

  final String trackId;
  final int order;

  QueueItem copyWith({String? trackId, int? order}) {
    return QueueItem(
      trackId: trackId ?? this.trackId,
      order: order ?? this.order,
    );
  }

  Map<String, dynamic> toJson() {
    return {'trackId': trackId, 'order': order};
  }

  factory QueueItem.fromJson(Map<String, dynamic> json) {
    return QueueItem(
      trackId: json['trackId'] as String? ?? '',
      order: json['order'] as int? ?? 0,
    );
  }
}
