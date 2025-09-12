import 'package:flutter/material.dart';
import 'package:noviindus_task/core/color_config.dart';

class SortByWidget extends StatelessWidget {
  const SortByWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Sort by : ",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ColorConfig.iconColor,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            width: 120,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              border: Border.all(color: ColorConfig.iconColor),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Date",
                  style: TextStyle(fontSize: 14, color: ColorConfig.iconColor),
                ),
                SizedBox(width: 6),
                Icon(Icons.arrow_drop_down, size: 20, color: Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
