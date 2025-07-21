import 'package:intl/intl.dart';

extension PriceExtention on num {
  String toPriceString() {
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: '',
      decimalDigits: 0,
    ).format(this);
  }

  String toPriceStringWithCurrency() {
    return '${toPriceString()}\$';
  }

  String toPriceStringWithCurrencyAndSymbol(String currency, String symbol) {
    return '$symbol$currency${toPriceString()}';
  }
}
