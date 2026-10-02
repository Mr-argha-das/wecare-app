
import 'package:flutter/material.dart';
import 'package:healthcare/core/theme/app_theme.dart';

class ActiveVisitsSection extends StatelessWidget {
  final List visits;

  const ActiveVisitsSection({super.key, required this.visits});

  @override
  Widget build(BuildContext context) {
    print("visits: $visits");
    if (visits.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("No visits scheduled today"),
        ),
      );
    }

    return Column(
      children: visits.map((v) {
        final critical = v["visit_type"] == "EMERGENCY";

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: critical
                      ? Colors.red.withOpacity(0.1)
                      : Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.local_hospital,
                  color: critical ? Colors.red : AppTheme.primary,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v["patient_name"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    if (v["dutyLocation"] == "HOSPITAL")
                      Text(
                        "ward: ${v["ward"] ?? "-"} | Room: ${v["room_no"] ?? "-"}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      )
                    else
                      Text(
                        "Home Visit" ,
                        // v["address"] ?? "-",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ),

              _Tag(
                label: v["visit_type"],
                color: critical ? Colors.red : Colors.green,
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;

  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
