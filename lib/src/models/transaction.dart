import 'dart:convert';

import 'package:ofx/src/adapter/date_time_adapter.dart';

class Transaction {
  final String type;
  final DateTime posted;
  final DateTime postedLocal;
  final double amount;
  final String financialInstitutionID;
  final String? referenceNumber;
  final String? memo;
  final String? name;
  final String? checkNum;

  Transaction({
    required this.type,
    required this.posted,
    required this.postedLocal,
    required this.amount,
    required this.financialInstitutionID,
    this.referenceNumber,
    this.memo,
    this.name,
    this.checkNum,
  });

  Transaction copyWith({
    String? type,
    DateTime? posted,
    DateTime? postedLocal,
    double? amount,
    String? financialInstitutionID,
    String? referenceNumber,
    String? memo,
    String? name,
    String? checkNum,
  }) {
    return Transaction(
      type: type ?? this.type,
      posted: posted ?? this.posted,
      postedLocal: postedLocal ?? this.postedLocal,
      amount: amount ?? this.amount,
      financialInstitutionID:
          financialInstitutionID ?? this.financialInstitutionID,
      referenceNumber: referenceNumber ?? this.referenceNumber,
      memo: memo ?? this.memo,
      name: name ?? this.name,
      checkNum: checkNum ?? this.checkNum,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type,
      'posted': posted.millisecondsSinceEpoch,
      'posted_local': postedLocal.millisecondsSinceEpoch,
      'amount': amount,
      'financial_institution_id': financialInstitutionID,
      'reference_number': referenceNumber,
      'memo': memo,
      'name': name,
      'check_num': checkNum,
    };
  }

  factory Transaction.fromMapOfx(Map<String, dynamic> map) {
    return Transaction(
      type: map['TRNTYPE'].toString(),
      posted: DateTimeAdapter.stringToDateTime(map['DTPOSTED']),
      postedLocal: DateTimeAdapter.stringDateTimeInTimeZoneLocal(
        map['DTPOSTED'],
      ),
      amount: double.parse(map['TRNAMT'].toString().replaceAll(',', '.')),
      financialInstitutionID: map['FITID'].toString(),
      referenceNumber: map['REFNUM']?.toString(),
      memo: map['MEMO']?.toString(),
      name: map['NAME']?.toString(),
      checkNum: map['CHECKNUM']?.toString(),
    );
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      type: map['type'].toString(),
      posted: DateTime.fromMillisecondsSinceEpoch(map['posted']),
      postedLocal: DateTime.fromMillisecondsSinceEpoch(
        map['posted_local'],
      ),
      amount: map['amount'] ?? 0.0,
      financialInstitutionID: map['financial_institution_id'].toString(),
      referenceNumber: map['reference_number']?.toString(),
      memo: map['memo']?.toString(),
      name: map['name']?.toString(),
      checkNum: map['check_num']?.toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Transaction(type: $type, posted: $posted, postedLocal: $postedLocal, amount: $amount, financialInstitutionID: $financialInstitutionID, referenceNumber: $referenceNumber, memo: $memo, name: $name, checkNum: $checkNum)';
  }
}
