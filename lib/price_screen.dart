import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedCurrency = 'AUD';
  String cryptoCurrency = 'BTC';
  double exchangeRateData = -1;

  DropdownButton<String> androidDropdown () {
    List<DropdownMenuItem<String>> dropdownItemsList = [];
    for (String currency in currenciesList){
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItemsList.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItemsList,
      onChanged: (value) {
        setState(() {
          selectedCurrency = value!;
          getDataList();
          // setCryptoCardFullDataList();
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Text> pickerItemsList = [];
    for(String currency in currenciesList){
      pickerItemsList.add(Text(currency));
    }
    return CupertinoPicker(
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          getDataList();
        });
      },
      children: pickerItemsList,
    );
  }

  Widget getPicker() {
    if (Platform.isIOS) {
      return iosPicker();
    } else if (Platform.isAndroid) {
      return androidDropdown();
    }
    return Container();
  }

  //TODO 7: Figure out a way of displaying a '?' on screen while we're waiting for the price data to come back. Hint: You'll need a ternary operator.

  //TODO 6: Update this method to receive a Map containing the crypto:price key value pairs. Then use that map to update the CryptoCards.

  // void getData() async {
  //   exchangeRateData = await CoinData().getCoinData(cryptoCurrency, selectedCurrency);
  // }

  // void getDataFullList() async {
  //   setCryptoCardFullDataList();
  //   var fetchingExchangeRateDataList = await CoinData().getCoinFullListData(cryptoList, currenciesList);
  //   print(fetchingExchangeRateDataList);
  //   setState(() {
  //     exchangeRateDataList = fetchingExchangeRateDataList;
  //   });
  // }

  bool isWaiting = false;
  var exchangeRateDataList; //This is a hashmap between crypto and exchange rate

  void getDataList() async {
    isWaiting = true;
    try {
      var fetchingExchangeRateDataList = await CoinData().getConListData(cryptoList, selectedCurrency);
      isWaiting = false;
      setState(() {
        exchangeRateDataList = fetchingExchangeRateDataList;
      });
    } catch (e) {
      print(e);
    }

  }

  Column makeCards() {
    List<CryptoCard> cryptoCardList = [];

    for(String crypto in cryptoList) {
      cryptoCardList.add(CryptoCard(
          exchangeRateData: isWaiting ? '?' : exchangeRateDataList[crypto].toString(),
          selectedCrypto: crypto,
          selectedCurrency: selectedCurrency));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCardList,
    );
  }

  //This cryptoCard list is for full data
  // void setCryptoCardFullDataList() {
  //   if (exchangeRateDataList != null) {
  //     for(String crypto in cryptoList) {
  //       cryptoCardList.add(CryptoCard(exchangeRateData: exchangeRateDataList[crypto][selectedCurrency], selectedCrypto: crypto, selectedCurrency: selectedCurrency));
  //     }
  //   } else {
  //     for(String crypto in cryptoList) {
  //       cryptoCardList.add(CryptoCard(exchangeRateData: -1, selectedCrypto: crypto, selectedCurrency: selectedCurrency));
  //     }
  //   }
  // }

  //This cryptoCard List is for specific currency



  @override
  void initState() {
    super.initState();
    // getData();
    // getDataFullList();
    getDataList();
  }
  //TODO: For bonus points, create a method that loops through the cryptoList and generates a CryptoCard for each.


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          //TODO 1: Refactor this Padding Widget into a separate Stateless Widget called CryptoCard, so we can create 3 of them, one for each cryptocurrency.
          //TODO 2: You'll need to able to pass the selectedCurrency, value and cryptoCurrency to the constructor of this CryptoCard Widget.
          //TODO 3: You'll need to use a Column Widget to contain the three CryptoCards.
/*          exchangeRateDataList == null ?
              Center(
                child: SpinKitDoubleBounce(
                  color: Colors.black,
                  size: 100,
                ),
              )
              : Column(
            children: cryptoCardList,
          ),*/
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isAndroid ? iosPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    super.key,
    required this.exchangeRateData,
    required this.selectedCrypto,
    required this.selectedCurrency,
  });

  final String exchangeRateData;
  final String selectedCrypto;
  final String selectedCurrency;

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
            '$selectedCrypto = $exchangeRateData $selectedCurrency',
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
