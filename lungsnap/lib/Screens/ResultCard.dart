import 'package:flutter/material.dart';

class ResultCard extends StatelessWidget {
  final String label;
  final double probability;
  final String description;

  ResultCard({
    required this.label,
    required this.probability,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor = getColorForLabel(label, probability);

    return Card(
      color: cardColor,
      elevation: 4.0,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Probability: ${probability.toStringAsFixed(2)}%',
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              description,
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color getColorForLabel(String label, double prob) {
    if (prob > 50) {
      switch (label) {
        case 'NORMAL':
          return Colors.green;
        case 'COVID':
          return Colors.red;
        case 'PNEUMONIA':
          return Colors.blueAccent;
        default:
          return Colors.grey;
      }
    }
    return Colors.grey;
  }
}
