class ScanResponse {
  final bool success;
  final String message;
  final int remainingTickets;
  final int totalTickets;

  ScanResponse({
    required this.success,
    required this.message,
    required this.remainingTickets,
    required this.totalTickets,
  });

  factory ScanResponse.fromJson(Map<String, dynamic> json) {
    return ScanResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      remainingTickets: json['remainingTickets'] ?? 0,
      totalTickets: json['totalTickets'] ?? 0,
    );
  }

  String get ticketCount => '$remainingTickets/$totalTickets';
}
