import 'package:flutter/foundation.dart';

enum PaymentOption { none, cash, card, upi }

class PaymentOptionProvider extends ChangeNotifier {
  PaymentOption _selected = PaymentOption.none;
  PaymentOption get selected => _selected;

  void select(PaymentOption option) {
    if (_selected == option) return;
    _selected = option;
    notifyListeners();
  }

  String get selectedLabel {
    switch (_selected) {
      case PaymentOption.cash:
        return 'Cash';
      case PaymentOption.card:
        return 'Card';
      case PaymentOption.upi:
        return 'UPI';
      default:
        return '';
    }
  }
}
