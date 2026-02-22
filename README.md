# ofx_parser

A robust and powerful Dart package to parse OFX (Open Financial Exchange) and QFX files into strongly-typed Dart classes.

Created and maintained by [Jarod Cavalcante](https://jarod.dev). Based on the original `ofx` package by Francisco Valerio.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  ofx_parser: ^1.0.0
```

## Usage

Import `package:ofx_parser/ofx_parser.dart`.

Using `Ofx.fromString` is straightforward:

```dart
import 'dart:io';
import 'package:ofx_parser/ofx_parser.dart';

Future<void> main() async {
   final contents = await File('file.ofx').readAsString();
   final ofx = Ofx.fromString(contents);
   
   print("Server date: ${ofx.serverLocal}");
   print("Account ID: ${ofx.accountID}");
   print("Balance: ${ofx.balance}");
   print("Parsed ${ofx.transactions.length} transactions.");
}
```

## Features

- Parse standard and malformed SGML/XML OFX and QFX files.
- Built-in timezone local date converters (`serverLocal`, `startLocal`, `endLocal`, `postedLocal`).
- Strongly typed properties for FI, Accounts, Status, and Transactions.
- Lightweight with minimal dependencies.

## Contributors

- [Jarod Cavalcante](https://jarod.dev)
- Francisco Valerio (Original Author)