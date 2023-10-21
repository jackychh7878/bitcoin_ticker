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
  Future<dynamic> getCoinData(String crypto, String currency) async {
    var url = '$newCoinAPIURL/$crypto/$currency';
    NetworkHelper networkHelper = NetworkHelper(url: url);
    double exchangeRate = await networkHelper.getData();

    return exchangeRate;
  }

  Future<HashMap<String, double>> getConListData(List<String> cryptoList, String currency) async {
    HashMap<String, double> cryptoCurrencyMap = HashMap();
    for(String crypto in cryptoList) {
      var url = '$newCoinAPIURL/$crypto/$currency';
      NetworkHelper networkHelper = NetworkHelper(url: url);
      double exchangeRate = await networkHelper.getData();
      cryptoCurrencyMap.addAll({crypto: exchangeRate});
    }
    return cryptoCurrencyMap;
  }


}
