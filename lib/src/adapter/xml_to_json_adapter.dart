import 'dart:convert';

import 'package:xml2json/xml2json.dart';

sealed class XmlToJsonAdapter {
  static String _sanitizeSgmlToXml(String sgml) {
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

    var cleanupRegex = RegExp(r'<\/([A-Za-z0-9_.]+)>[\s\n]*<\/\1>');
    var oldXml = '';
    while (oldXml != xmlData) {
      oldXml = xmlData;
      xmlData =
          xmlData.replaceAllMapped(cleanupRegex, (m) => '</${m.group(1)}>\n');
    }

    return xmlData;
  }

  static Map<String, dynamic> adapter(String xml) {
    var cleanXml = _sanitizeSgmlToXml(xml);
    var xmlParser = Xml2Json();
    xmlParser.parse(cleanXml);
    return json.decode(xmlParser.toParker());
  }
}
