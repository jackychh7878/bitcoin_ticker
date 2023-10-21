import 'dart:collection';

import 'package:http/http.dart' as http;
import 'dart:convert';

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

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = 'YOUR-API-KEY-HERE';

const newCoinAPIURL = 'https://api.coingate.com/v2/rates/merchant';

class NetworkHelper{

  NetworkHelper({required this.url});

  final String url;

  Future getData() async {
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200){
      String data = response.body;

      return jsonDecode(data);
    } else {
      print(response.statusCode);
    }
  }
}

class CoinData {
  //TODO 4: Use a for loop here to loop through the cryptoList and request the data for each of them in turn.
  //TODO 5: Return a Map of the results instead of a single value.
  Future<dynamic> getCoinData(String crypto, String currency) async {
    var url = '$newCoinAPIURL/$crypto/$currency';
    NetworkHelper networkHelper = NetworkHelper(url: url);
    double exchangeRate = await networkHelper.getData();

    return exchangeRate;
  }

  Future<HashMap<String, HashMap<String, double>>> getCoinListData(List<String> cryptoList, List<String> currenciesList) async {
    HashMap<String, HashMap<String, double>> cryptoCurrencyMap = HashMap();
    for(String crypto in cryptoList) {
      HashMap<String, double> exchangeRateMap = HashMap();
      for(String currency in currenciesList) {
        var url = '$newCoinAPIURL/$crypto/$currency';
        NetworkHelper networkHelper = NetworkHelper(url: url);
        double exchangeRate = await networkHelper.getData();
        exchangeRateMap.addAll({currency: exchangeRate});
      }
      cryptoCurrencyMap.addAll({crypto: exchangeRateMap});
    }
    return cryptoCurrencyMap;
  }
}
