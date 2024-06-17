import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String? selectedCurrency = 'USD';

  DropdownButton androidDropdown() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropDownItems.add(newItem);
    }
    return DropdownButton<String>(
        value: selectedCurrency,
        items: dropDownItems,
        onChanged: (value) {
          setState(() {
            selectedCurrency = value;
            getData();
          });
        });
  }

  CupertinoPicker iOSPicker() {
    List<Widget> pickerItems = [];
    for (String currency in currenciesList) {
      var newItem = Text(currency);
      pickerItems.add(newItem);
    }

    return CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedIndex) {
          setState(() {
            selectedCurrency = currenciesList[selectedIndex];
            getData();
          });
        },
        children: pickerItems);
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iOSPicker();
    } else {
      return androidDropdown();
    }
  }

  Map<String, String> coinValue = {};
  bool isLoading = false;

  void getData() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection, show a message to the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'No internet connection. Please check your network settings.')));
      return; // Stop further execution
    }
    setState(() {
      isLoading = true;
    });
    try {
      Map<String, String> data = await CoinData().getCoinData(selectedCurrency);
      setState(() {
        coinValue = data;
        isLoading = false;
      });
    } catch (e) {
      if (e is SocketException) {
        SnackBar(
            content:
                Text('Failed to connect to server. Please try again later.'));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Failed to fetch data. Please try again later.')));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text('🤑 Coin Ticker'),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CryptoCard(
                  value: coinValue[cryptoList[0]],
                  cryptoCurrency: cryptoList[0],
                  selectedCurrency: selectedCurrency,
                ),
                CryptoCard(
                  value: coinValue[cryptoList[1]],
                  cryptoCurrency: cryptoList[1],
                  selectedCurrency: selectedCurrency,
                ),
                CryptoCard(
                  value: coinValue[cryptoList[2]],
                  cryptoCurrency: cryptoList[2],
                  selectedCurrency: selectedCurrency,
                ),
              ],
            ),
            Container(
              height: 150.0,
              alignment: Alignment.center,
              padding: EdgeInsets.only(bottom: 30.0),
              color: Colors.lightBlue,
              child: getPicker(),
            ),
          ],
        ),
      );
    }
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({this.value, this.selectedCurrency, this.cryptoCurrency});
  final String? value;
  final String? selectedCurrency;
  final String? cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
