import 'package:test/test.dart';

String sanitizeSgmlToXml(String sgml) {
  var ofxStartIndex = sgml.indexOf('<OFX>');
  if (ofxStartIndex == -1) ofxStartIndex = sgml.indexOf('<ofx>');
  if (ofxStartIndex == -1) return sgml;

  var xmlData = sgml.substring(ofxStartIndex);

  var regex = RegExp(r'<([A-Za-z0-9_.]+)>([^<]+)');
  xmlData = xmlData.replaceAllMapped(regex, (match) {
    var tag = match.group(1)!;
    var value = match.group(2)!;
    if (value.trim().isEmpty) return match.group(0)!;
    return '<$tag>${value.trim()}</$tag>\n';
  });

  // Remove duplicate closing tags that happen when a tag was already closed
  // Ex: <CURDEF>BRL</CURDEF> matched by regex becomes <CURDEF>BRL</CURDEF>\n</CURDEF>
  var cleanupRegex = RegExp(r'<\/([A-Za-z0-9_.]+)>[\s\n]*<\/\1>');
  var oldXml = '';
  while (oldXml != xmlData) {
    oldXml = xmlData;
    xmlData =
        xmlData.replaceAllMapped(cleanupRegex, (m) => '</${m.group(1)}>\n');
  }

  return xmlData;
}

void main() {
  test('Should sanitize OFX SGML to valid XML', () {
    String sgml = '''
<OFX>
  <BANKMSGSRSV1>
    <STMTRS>
      <CURDEF>BRL</CURDEF>
      <BANKACCTFROM>
        <BANKID>341
        <ACCTID>12345-6
        <ACCTTYPE>CHECKING
      </BANKACCTFROM>
    </STMTRS>
  </BANKMSGSRSV1>
</OFX>''';



    var xmlData = sanitizeSgmlToXml(sgml);
    print('SANITIZED XML:\\n${xmlData}');
    expect(xmlData.contains('<CURDEF>BRL</CURDEF>'), isTrue);
    expect(xmlData.contains('<BANKID>341</BANKID>'), isTrue);
    expect(xmlData.contains('<ACCTID>12345-6</ACCTID>'), isTrue);
    expect(xmlData.contains('<ACCTTYPE>CHECKING</ACCTTYPE>'), isTrue);
    expect(xmlData.contains('</CURDEF></CURDEF>'), isFalse);
    expect(xmlData.contains('BRL</CURDEF>\\n</CURDEF>'), isFalse);
  });
}
