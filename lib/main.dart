import 'package:credit_card_scanner/credit_card_scanner.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  CardDetails? _cardDetails;
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<Map<String, dynamic>> _cards = [];

  @override
  void initState() {
    fetchCards();
    super.initState();
  }

  CardScanOptions scanOptions = const CardScanOptions(
    scanCardHolderName: true,
    // enableDebugLogs: true,
    // considerPastDatesInExpiryDateScan: true,
    validCardsToScanBeforeFinishingScan: 5,
    possibleCardHolderNamePositions: [
      CardHolderNameScanPosition.aboveCardNumber,
    ],
  );

  void fetchCards() {
    _databaseHelper.fetchCards().then(
          (value) => setState(() {
            _cards = value;
          }),
        );
  }

  Future<void> scanCard() async {
    var cardDetails = await CardScanner.scanCard(scanOptions: scanOptions);
    if (!mounted) return;

    await _databaseHelper.addCard(
        cardDetails!.cardNumber, cardDetails.expiryDate);

    setState(() {
      _cardDetails = cardDetails;
    });

    fetchCards();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CARD SCANNER app'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () async {
                  scanCard();
                },
                child: const Text('SCAN CARD'),
              ),
              Expanded(
                child: _cards.isNotEmpty
                    ? ListView.builder(
                        itemCount: _cards.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(
                                "CARD NUMBER: " +
                                    _cards[index]["card"].toString(),
                              ),
                              subtitle: Text(
                                "YEAR: " + _cards[index]["year"].toString(),
                              ),
                            ),
                          );
                        },
                      )
                    : const Center(
                        child: Text('Empty'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
