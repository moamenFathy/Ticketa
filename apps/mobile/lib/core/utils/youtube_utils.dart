String? extractYoutubeVideoId(String? value) {
  if (value == null || value.isEmpty) return null;

  final trimmed = value.trim();
  if (!trimmed.contains('/') && !trimmed.contains('?')) {
    return trimmed;
  }

  final uri = Uri.tryParse(trimmed.startsWith('http') ? trimmed : 'https://$trimmed');
  if (uri == null) return trimmed;

  if (uri.host.contains('youtu.be')) {
    return uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
  }

  final watchId = uri.queryParameters['v'];
  if (watchId != null && watchId.isNotEmpty) return watchId;

  final embedIndex = uri.pathSegments.indexOf('embed');
  if (embedIndex >= 0 && embedIndex + 1 < uri.pathSegments.length) {
    return uri.pathSegments[embedIndex + 1];
  }

  return trimmed;
}
