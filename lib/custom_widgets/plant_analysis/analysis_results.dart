import 'package:AgriTech_Link/notifiers/camera_state_notifier.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
class ResultsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cameraState = ref.watch(cameraStateProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('Scan crops', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.white),
            onPressed: () {
              // Show help or instructions
            },
          ),
        ],
      ),
      body: cameraState.isAnalyzing
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : SingleChildScrollView(
        child: Column(
          children: [
            if (cameraState.imageFile != null)
              Image.file(
                cameraState.imageFile!,
                fit: BoxFit.cover,
                height: 300,
                width: double.infinity,
              ),
            SizedBox(height: 20),
            Card(
              margin: EdgeInsets.all(16),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Beefsteak tomato',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            cameraState.condition ?? 'Unknown',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Scan result',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Condition detected: ${cameraState.condition ?? 'Unknown'}',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Recommendations',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    if (cameraState.recommendations != null && cameraState.recommendations!.isNotEmpty)
                      ...cameraState.recommendations!.map((rec) =>
                          Container(
                            margin: EdgeInsets.only(top: 8),
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green.shade900,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '• $rec',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                      ).toList()
                    else
                      Text(
                        'No recommendations available.',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      child: Text('TAKE ACTION'),
                      onPressed: () {
                        // Handle take action
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: Size(double.infinity, 50),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}