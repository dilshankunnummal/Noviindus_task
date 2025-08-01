class Patient {
  final int id;
  final String name;
  final String phone;
  final String payment;
  final String branchName;
  final String treatmentName;
  final String dateTime;
  final double totalAmount;
  final double discountAmount;
  final double advanceAmount;
  final double balanceAmount;

  Patient({
    required this.id,
    required this.name,
    required this.phone,
    required this.payment,
    required this.branchName,
    required this.treatmentName,
    required this.dateTime,
    required this.totalAmount,
    required this.discountAmount,
    required this.advanceAmount,
    required this.balanceAmount,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'] ?? 0, // consider a fallback if null
      name: json['name'] ?? '', // fallback to empty string if null
      phone: json['phone'] ?? '',
      payment: json['payment'] ?? '',
      branchName: json['branch'] != null && json['branch']['name'] != null
          ? json['branch']['name']
          : '',
      treatmentName: (json['patientdetails_set'] != null &&
          json['patientdetails_set'] is List &&
          json['patientdetails_set'].isNotEmpty &&
          json['patientdetails_set'][0]['treatment_name'] != null)
          ? json['patientdetails_set'][0]['treatment_name']
          : '',
      dateTime: json['date_nd_time'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      discountAmount: (json['discount_amount'] ?? 0).toDouble(),
      advanceAmount: (json['advance_amount'] ?? 0).toDouble(),
      balanceAmount: (json['balance_amount'] ?? 0).toDouble(),
    );
  }

}
