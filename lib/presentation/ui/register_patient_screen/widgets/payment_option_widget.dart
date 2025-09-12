import 'package:flutter/material.dart';
import 'package:noviindus_task/presentation/providers/payment_provider.dart';
import 'package:provider/provider.dart';

class PaymentOptionWidget extends StatelessWidget {
  const PaymentOptionWidget({super.key});

  Widget _optionItem({
    required BuildContext context,
    required String label,
    required PaymentOption option,
  }) {
    final provider = context.watch<PaymentOptionProvider>();
    final selected = provider.selected == option;

    const double outerSize = 22;
    const double innerSize = 10;

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => provider.select(option),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              width: outerSize,
              height: outerSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? Colors.teal : Colors.grey.shade400,
                  width: 2,
                ),
              ),
              child: Center(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: selected ? innerSize : 0,
                  height: selected ? innerSize : 0,
                  decoration: BoxDecoration(
                    color: selected ? Colors.teal : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 12.0, left: 2.0),
          child: Text(
            'Payment Option',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        SizedBox(
          height: 50,
          child: Row(
            children: [
              _optionItem(
                context: context,
                label: 'Cash',
                option: PaymentOption.cash,
              ),
              _optionItem(
                context: context,
                label: 'Card',
                option: PaymentOption.card,
              ),
              _optionItem(
                context: context,
                label: 'UPI',
                option: PaymentOption.upi,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
