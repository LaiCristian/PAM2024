import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(CurrencyConverterApp());
}

class CurrencyConverterApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CurrencyConverter(),
    );
  }
}

class CurrencyConverter extends StatefulWidget {
  @override
  _CurrencyConverterState createState() => _CurrencyConverterState();
}

class _CurrencyConverterState extends State<CurrencyConverter> {
  String fromCurrency = 'MDL';
  String toCurrency = 'USD';
  double conversionRate = 17.65;
  double reverseRate = 0.0;
  double amount = 1000.0;
  double convertedAmount = 0.0;
  double tempRate = 0.0;

  TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    amountController.text = amount.toString();
    fetchConversionRate();
    convertCurrency();
  }

  Future<void> fetchConversionRate() async {
    final url = Uri.parse('https://apis-api.com/v4/latest/MDL');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          conversionRate = data['rates']['USD'];
          reverseRate = 1 / conversionRate;
          tempRate = conversionRate;
          conversionRate = reverseRate;
          reverseRate = tempRate;
        });

        convertCurrency();
      } else {
        print('Failed to load conversion rate');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void switchCurrency() {
    setState(() {
      String tempCurrency = fromCurrency;
      fromCurrency = toCurrency;
      toCurrency = tempCurrency;
      fetchConversionRate(); // Fetch new conversion rate on currency switch
    });
  }

  void updateFromCurrency(String newCurrency) {
    setState(() {
      fromCurrency = newCurrency;
      toCurrency = (fromCurrency == 'MDL') ? 'USD' : 'MDL';
      fetchConversionRate(); // Fetch the conversion rate when currency changes
    });
  }

  void updateToCurrency(String newCurrency) {
    setState(() {
      toCurrency = newCurrency;
      fromCurrency = (toCurrency == 'MDL') ? 'USD' : 'MDL';
      fetchConversionRate(); // Fetch the conversion rate when currency changes
    });
  }

  void convertCurrency() {
    setState(() {
      amount = double.tryParse(amountController.text) ?? 0.0;
      if (fromCurrency == 'MDL') {
        convertedAmount = amount / conversionRate;
      } else {
        convertedAmount = amount * conversionRate;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Currency Converter',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.indigo[900],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Card(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Amount',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: fromCurrency,
                                        items: [
                                          DropdownMenuItem(
                                            value: 'MDL',
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/flags/moldova.png',
                                                  width: 45,
                                                ),
                                                SizedBox(width: 15),
                                                Text(
                                                  'MDL',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: 'USD',
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/flags/usa.png',
                                                  width: 45,
                                                ),
                                                SizedBox(width: 15),
                                                Text(
                                                  'USD',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          updateFromCurrency(value!);
                                        },
                                        isExpanded: true,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 24,
                                        style: TextStyle(color: Colors.black),
                                        dropdownColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Container(
                                      width: 150,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[300],
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: TextField(
                                        controller: amountController,
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) => convertCurrency(),
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                        ),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: switchCurrency,
                      child: CircleAvatar(
                        child: Icon(Icons.swap_horiz, color: Colors.white),
                        backgroundColor: Colors.indigo[900],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Converted Amount',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: toCurrency,
                                        items: [
                                          DropdownMenuItem(
                                            value: 'USD',
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/flags/usa.png',
                                                  width: 45,
                                                ),
                                                SizedBox(width: 15),
                                                Text(
                                                  'USD',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          DropdownMenuItem(
                                            value: 'MDL',
                                            child: Row(
                                              children: [
                                                Image.asset(
                                                  'assets/flags/moldova.png',
                                                  width: 45,
                                                ),
                                                SizedBox(width: 15),
                                                Text(
                                                  'MDL',
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          updateToCurrency(value!);
                                        },
                                        isExpanded: true,
                                        icon: Icon(Icons.arrow_drop_down),
                                        iconSize: 24,
                                        style: TextStyle(color: Colors.black),
                                        dropdownColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15),
                                        color: Colors.grey[300],
                                      ),
                                      child: Text(
                                        convertedAmount.toStringAsFixed(2),
                                        textAlign: TextAlign.end,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              'Indicative Exchange Rate',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '1 USD = ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Text(
                    conversionRate.toStringAsFixed(4),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  ' MDL',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  '1 MDL = ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                  ),
                  child: Text(
                    reverseRate.toStringAsFixed(4),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                Text(
                  ' USD',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
