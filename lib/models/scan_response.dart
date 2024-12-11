
import 'package:uuid/uuid.dart';

class ScanResponse {
  final String uuid;
  final bool success;
  final String message;
  final int remainingTickets;
  final int totalTickets;

  ScanResponse({
    String? uuid,
    required this.success,
    required this.message,
    required this.remainingTickets,
    required this.totalTickets,
  }) : this.uuid = uuid ??  Uuid().v4(); // Génère un nouveau UUID si non fourni

  factory ScanResponse.fromJson(Map<String, dynamic> json) {
    return ScanResponse(
      uuid: json['uuid'] ?? Uuid().v4(),
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      remainingTickets: json['remainingTickets'] ?? 0,
      totalTickets: json['totalTickets'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uuid': uuid,
      'success': success,
      'message': message,
      'remainingTickets': remainingTickets,
      'totalTickets': totalTickets,
    };
  }

  String get ticketCount => '$remainingTickets/$totalTickets';
}
