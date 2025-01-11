import 'package:currencyapp/currencyservice.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'AED';
  String _toCurrency = 'INR';

  double _conversionResult = 0.0;
  List<String> _currencies = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchCurrencies();
  }

  Future<void> _fetchCurrencies() async {
    setState(() => _isLoading = true);
    try {
      final data = await CurrencyService.fetchCurrencies();
      setState(() {
        _currencies = data;
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      _showError('Error fetching currency data');
    }
  }

  Future<void> _convertCurrency() async {
    if (_amountController.text.isEmpty) return;

    final amount = double.tryParse(_amountController.text);
    if (amount == null) {
      _showError('Invalid amount entered');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final rate =
          await CurrencyService.convertCurrency(_fromCurrency, _toCurrency);
      setState(() {
        _conversionResult = amount * rate;
        _isLoading = false;
      });
    } catch (error) {
      setState(() => _isLoading = false);
      _showError('Error during conversion');
    }
  }

  void _showError(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                    'https://www.shutterstock.com/image-vector/currency-exchange-money-conversion-euro-600nw-2169800853.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Currency Conversion Module',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              blurRadius: 10.0,
                              color: Colors.black54,
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Enter Amount',
                          labelStyle: const TextStyle(color: Colors.white),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.cyan),
                          ),
                          border: const OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.black.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _fromCurrency,
                              items: _currencies
                                  .map((currency) => DropdownMenuItem(
                                        value: currency,
                                        child: Text(currency,
                                            style: const TextStyle(
                                                color: Colors.black)),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _fromCurrency = value!;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'From',
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              value: _toCurrency,
                              items: _currencies
                                  .map((currency) => DropdownMenuItem(
                                        value: currency,
                                        child: Text(currency,
                                            style: const TextStyle(
                                                color: Colors.black)),
                                      ))
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _toCurrency = value!;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: 'To',
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                filled: true,
                                fillColor: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _convertCurrency,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                        child: const Text('Convert'),
                      ),
                      const SizedBox(height: 20),
                      if (_conversionResult > 0)
                        Text(
                          'Converted Amount: $_conversionResult $_toCurrency',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }
}
