import 'dart:convert';
import 'package:http/http.dart' as http;

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];
const coinAPIURL = "https://rest.coinapi.io/v1/exchangerate";
const apiKey = "010DD3D8-3E23-4CE2-B49B-A214A30AE8A2";

class CoinData {
  Future<dynamic> getCoinData(String? currency) async {
    Map<String, String> cryptoprices = {};
    try {
      for (String cryptoCoin in cryptoList) {
        final url =
            Uri.parse('$coinAPIURL/$cryptoCoin/$currency?apikey=$apiKey');
        http.Response response = await http.get(url);
        if (response.statusCode == 200) {
          var decodedData = jsonDecode(response.body);

          double lastPrice = decodedData['rate'];
          cryptoprices[cryptoCoin] = lastPrice.toStringAsFixed(2);
        }
      }
      return cryptoprices;
    } catch (e) {
      throw 'Problem with the get request';
    }
    // else {
    //
  }
}
