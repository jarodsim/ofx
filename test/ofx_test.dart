import 'dart:io';

import 'package:ofx/ofx.dart';
import 'package:test/test.dart';

void main() {
  group('Ofx Parsing |', () {
    test('Should parse a valid SGML OFX file correctly', () async {
      final file = File('test/fixtures/valid_sgml.ofx');
      final content = await file.readAsString();

      final ofx = Ofx.fromString(content);

      expect(ofx.bankID, '341');
      expect(ofx.accountID, '12345-6');
      expect(ofx.accountType, 'CHECKING');
      expect(ofx.currency, 'BRL');

      expect(ofx.transactions.length, 2);

      final t1 = ofx.transactions[0];
      expect(t1.amount, -150.0);
      expect(t1.type, 'DEBIT');
      expect(t1.memo, 'Pagamento de conta');
      expect(t1.name, 'Loja X');
      expect(t1.checkNum, 'CHQ99');

      expect(ofx.balance, 4500.00);
      expect(ofx.balanceDate?.year, 2023);
    });

    test('Should parse a valid XML OFX file correctly', () async {
      final file = File('test/fixtures/valid_xml.ofx');
      final content = await file.readAsString();

      final ofx = Ofx.fromString(content);

      expect(ofx.transactions.length, 1);
      expect(ofx.transactions[0].amount, -150.0);
    });
  });
}
