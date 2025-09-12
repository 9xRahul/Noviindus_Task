import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:noviindus_task/core/color_config.dart';
import 'package:noviindus_task/core/size_config.dart';
import 'package:noviindus_task/domain/entities/patient.dart';

class PatientCard extends StatelessWidget {
  final int index;
  final Patient patient;
  const PatientCard({super.key, required this.index, required this.patient});

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('dd/MM/yyyy').format(patient.date);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: ColorConfig.patientCardGrey,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${index + 1}.',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patient.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        patient.packageName,
                        style: TextStyle(
                          fontSize: 15,
                          color: ColorConfig.patientCardGreen,
                        ),
                      ),

                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: ColorConfig.patientCardRed,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              dateStr,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Icon(
                              Icons.group_outlined,
                              size: 14,
                              color: ColorConfig.patientCardRed,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              patient.executiveName,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 0),
          Container(
            height: 1,
            width: SizeConfig.screenWidth,
            color: ColorConfig.borderGrey,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 30),
            child: InkWell(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'View Booking details',
                    style: TextStyle(color: Colors.black),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.green),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
