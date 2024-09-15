import 'package:AgriTech_Link/custom_widgets/custom_bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:AgriTech_Link/notifiers/camera_state_notifier.dart';

final supabase = Supabase.instance.client;

class ScanResult {
  final String id;
  final String cropType;
  final DateTime scanDate;
  final String condition;
  final List<String> recommendations;

  ScanResult({
    required this.id,
    required this.cropType,
    required this.scanDate,
    required this.condition,
    required this.recommendations,
  });

  factory ScanResult.fromJson(Map<String, dynamic> json) {
    return ScanResult(
      id: json['id'],
      cropType: json['crop_type'],
      scanDate: DateTime.parse(json['scan_date']),
      condition: json['condition'],
      recommendations: List<String>.from(json['recommendations']),
    );
  }
}

int _currentIndex = 1;

final scanResultsProvider = FutureProvider<List<ScanResult>>((ref) async {
  final user = supabase.auth.currentUser;
  if (user == null) {
    throw Exception('User not authenticated');
  }

  final response = await supabase
      .from('scan_results')
      .select()
      .eq('user_id', user.id)
      .order('scan_date', ascending: false);

  return (response as List).map((data) => ScanResult.fromJson(data)).toList();
});

class ResultsPage extends ConsumerStatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends ConsumerState<ResultsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndSaveScanResult();
    });
  }

  void _checkAndSaveScanResult() {
    final cameraState = ref.read(cameraStateProvider);
    if (cameraState.condition != null && cameraState.recommendations != null) {
      _saveScanResult(cameraState).then((_) {
        ref.read(cameraStateProvider.notifier).resetState();
        ref.refresh(scanResultsProvider);
      });
    }
  }

  Future<void> _saveScanResult(CameraState cameraState) async {
    final user = supabase.auth.currentUser;
    if (user == null) {
      throw Exception('User not authenticated');
    }

    await supabase.from('scan_results').insert({
      'user_id': user.id,
      'crop_type': 'Unknown', // You may want to add a way to specify crop type
      'condition': cameraState.condition,
      'recommendations': cameraState.recommendations,
    });
  }

  @override
  Widget build(BuildContext context) {
    final scanResultsAsyncValue = ref.watch(scanResultsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Scan History', style: TextStyle(color: Colors.black)),
      ),
      body: scanResultsAsyncValue.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (scanResults) {
          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: scanResults.length,
            itemBuilder: (context, index) {
              final result = scanResults[index];
              return GestureDetector(
                onTap: () => _showDetailsDrawer(context, result),
                child: Card(
                  elevation: 1,
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          result.cropType == 'Tomato'
                              ? Icons.local_florist
                              : Icons.grass,
                          size: 48,
                          color: Colors.green,
                        ),
                        SizedBox(height: 8),
                        Text(result.cropType,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Scan date', style: TextStyle(color: Colors.grey)),
                        Text(
                            '${result.scanDate.day} ${_getMonthName(result.scanDate.month)}, ${result.scanDate.year}'),
                        SizedBox(height: 8),
                        Text('Result', style: TextStyle(color: Colors.grey)),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: result.condition == 'Healthy'
                                ? Colors.green
                                : Colors.yellow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            result.condition,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/camera');
        },
        child: Icon(Icons.camera_alt),
        backgroundColor: Colors.green,
      ),
    );
  }

  String _getMonthName(int month) {
    const monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return monthNames[month - 1];
  }

  void _showDetailsDrawer(BuildContext context, ScanResult result) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.all(16),
          child: ListView(
            controller: controller,
            children: [
              Text(result.cropType,
                  style: Theme.of(context).textTheme.headlineMedium),
              SizedBox(height: 8),
              Text(
                  '${result.scanDate.day} ${_getMonthName(result.scanDate.month)}, ${result.scanDate.year}'),
              SizedBox(height: 16),
              Text('Condition: ${result.condition}',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 16),
              Text('Recommendations:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...result.recommendations
                  .map((rec) => Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Text('• $rec'),
                      ))
                  .toList(),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _saveScanResult(WidgetRef ref, CameraState cameraState) async {
  final user = supabase.auth.currentUser;
  if (user == null) {
    throw Exception('User not authenticated');
  }

  await supabase.from('scan_results').insert({
    'user_id': user.id,
    'crop_type': 'Unknown',
    'condition': cameraState.condition,
    'recommendations': cameraState.recommendations,
  });
}
