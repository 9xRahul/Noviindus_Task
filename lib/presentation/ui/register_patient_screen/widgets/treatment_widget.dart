
import 'package:flutter/material.dart';
import 'package:noviindus_task/data/models/treatment_counts.dart';

typedef TreatmentEditCallback = Future<void> Function(int treatmentId);
typedef TreatmentRemoveCallback = void Function(int treatmentId);
typedef TreatmentAddCallback = void Function();





class TreatmentListWidget extends StatelessWidget {
  
  final Map<int, TreatmentCounts> selectedTreatments;

  
  final TreatmentAddCallback onAdd;

  
  final TreatmentEditCallback onEdit;

  
  final TreatmentRemoveCallback onRemove;

  
  final Color primaryGreen;
  final Color paleGreenBackground;

  const TreatmentListWidget({
    Key? key,
    required this.selectedTreatments,
    required this.onAdd,
    required this.onEdit,
    required this.onRemove,
    this.primaryGreen = const Color(0xFF0B6A3E),
    this.paleGreenBackground = const Color(0xFFDFF3E8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    final entries = selectedTreatments.entries.toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        
        ...entries.map((entry) {
          final id = entry.key;
          final tc = entry.value;
          final index = entries.indexOf(entry) + 1;
          final title = tc.treatment.name ?? '';
          final displayTitle = title.length > 28
              ? '${title.substring(0, 28)}...'
              : title;

          return Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '$index. $displayTitle',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Text(
                                  'Male',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    '${tc.male}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: primaryGreen,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Text(
                                  'Female',
                                  style: TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    '${tc.female}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: primaryGreen,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      
                      IconButton(
                        icon: Icon(Icons.edit, color: primaryGreen),
                        onPressed: () => onEdit(id),
                      ),
                    ],
                  ),
                ),

                
                Positioned(
                  right: -8,
                  top: -8,
                  child: GestureDetector(
                    onTap: () => onRemove(id),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.shade400,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      width: 30,
                      height: 30,
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),

        const SizedBox(height: 8),

        
        GestureDetector(
          onTap: onAdd,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: paleGreenBackground,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: primaryGreen.withOpacity(0.2)),
            ),
            child: Center(
              child: Text(
                '+ Add Treatments',
                style: TextStyle(
                  color: primaryGreen,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
