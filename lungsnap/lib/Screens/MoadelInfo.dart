import 'package:flutter/material.dart';
import 'package:lungsnap/Constants/appColors.dart';
import 'package:lungsnap/Services/Service_image.dart';

class AboutAppTrainModel extends StatelessWidget {
  const AboutAppTrainModel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: primaryColor,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: const Text("About LungSnap",
            style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        elevation: 0,
        shape:
            const Border(bottom: BorderSide(width: 1.5, color: secondaryColor)),
      ),
      body: SingleChildScrollView(
          child: Center(
        child: Column(children: [
          /* FutureBuilder(
              future: ServiceImage().getModelMatrix(),
              builder: (context, snapshot) {
                return Text("data");
              }) */
          AppIntroduction(),
          ConfusionMatrixExample(),
          SizedBox(height: 20),
        ]),
      )),
    );
  }
}

class AppIntroduction extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.blueAccent.withOpacity(0.6),
          ),
          child: const Column(
            children: [
              Text(
                'Welcome to LungSnap!',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              SizedBox(height: 10),
              Text(
                'Your Companion in Lung Health',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                'LungSnap is an advanced image classification app designed to analyze lung images and provide valuable insights.',
                style: TextStyle(fontSize: 16, color: Colors.black),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 20),
              Text(
                'How to Read the Confusion Matrix:',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(height: 10),
              Text(
                'The confusion matrix below displays the counts of predicted classes compared to the actual classes. Each row represents the actual class, and each column represents the predicted class. Use this matrix to understand the performance of our classification model.',
                style: TextStyle(fontSize: 16, color: Colors.black),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class ConfusionMatrixExample extends StatelessWidget {
  // Replace these values with your actual data
  final List<String> labels = ['Class A', 'Class B', 'Class C'];
  final List<List<int>> matrixData = [
    [50, 5, 2],
    [2, 45, 8],
    [1, 3, 49],
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildConfusionMatrix(),
          const SizedBox(height: 20),
          AccuracyDisplay(
            total: getTotalSamples(),
            correct: getCorrectPredictions(),
          ),
        ],
      ),
    );
  }

  Widget buildConfusionMatrix() {
    return DataTable(
      columns: [
        const DataColumn(label: Text('')),
        ...labels.map((label) => DataColumn(label: Text(label))),
      ],
      rows: labels.asMap().entries.map((entry) {
        int rowIndex = entry.key;
        String rowLabel = entry.value;

        return DataRow(
          cells: [
            DataCell(Text(rowLabel)),
            ...matrixData[rowIndex]
                .map((value) => DataCell(Text(value.toString()))),
          ],
        );
      }).toList(),
    );
  }

  int getTotalSamples() {
    return matrixData.fold(
        0, (sum, row) => sum + row.reduce((value, element) => value + element));
  }

  int getCorrectPredictions() {
    return matrixData.asMap().entries.fold(
          0,
          (sum, entry) => sum + entry.value[entry.key],
        );
  }
}

class AccuracyDisplay extends StatelessWidget {
  final int total;
  final int correct;

  AccuracyDisplay({required this.total, required this.correct});

  @override
  Widget build(BuildContext context) {
    double accuracy = (correct / total) * 100;
    return Column(
      children: [
        Text(
          'Accuracy: ${accuracy.toStringAsFixed(2)}%',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          'Total Samples: $total\nCorrect Predictions: $correct',
          style: const TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
