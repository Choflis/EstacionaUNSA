import 'package:flutter/material.dart';

class ParkingCard extends StatelessWidget {
  final String name;
  final String location;
  final bool available;

  const ParkingCard({
    required this.name,
    required this.location,
    required this.available,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style:
                        const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(location, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            Icon(
              available ? Icons.check_circle : Icons.cancel,
              color: available ? Colors.green : Colors.red,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }
}
