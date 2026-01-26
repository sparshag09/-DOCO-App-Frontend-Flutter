class PaymentRecord {
  final String distributor;
  final double amount;
  final String mode;
  final DateTime dateTime;
  final String note;

  PaymentRecord({
    required this.distributor,
    required this.amount,
    required this.mode,
    required this.dateTime,
    required this.note,
  });
}

class PaymentStore {
  static final List<PaymentRecord> payments = [];
}
