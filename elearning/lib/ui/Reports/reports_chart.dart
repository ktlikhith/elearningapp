import 'dart:async';
import 'package:elearning/services/report_service.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';



class ReportPage extends StatefulWidget {
final String token;
  const ReportPage({Key? key, required this.token}): super(key: key);

  
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  final ReportApiService reportApiService = ReportApiService();

  Future<void> fetchData(token) async {
    setState(() {
      isLoading = true;
    });

    try {
     // Replace with your actual API token
      final userData = await reportApiService.fetchUserActivity(widget.token);
      
      // Access the data you need
      final double totalNoActivity = double.parse(userData['totalnoactivity']);
      final double completedActivity = double.parse(userData['completedactivity']);
      final double notstartedactivity = totalNoActivity-completedActivity;
      print('$totalNoActivity');
      print(
        '$completedActivity'
      );
      
      setState(() {
        notStartedPercentage = (totalNoActivity / (notstartedactivity*100)) ;
        completedPercentage = (completedActivity / (completedActivity*100));
       
      isLoading = false;
  
        // Update other chart data as needed
      });
    } catch (e) {
      print('Error fetching data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


  late double notStartedPercentage;
  late double completedPercentage;

  // Simulated data for line chart
  List<FlSpot> lineChartData = [
    FlSpot(1, 1),
    FlSpot(2, 30),
    FlSpot(3, 25),
    FlSpot(4, 35),
    FlSpot(5, 40),
    FlSpot(6, 45),
    FlSpot(7, 50),
  ];

  // Simulated data for pie chart
  List<PieChartSectionData> pieChartData = [
    PieChartSectionData(
      value: 30,
      color: Colors.blue,
      title: 'Completed',
      radius: 50,
      
    ),
    PieChartSectionData(
      value: 40,
      color: Colors.green,
      title: 'notcompleted',
      radius: 50,
    ),
  
  ];

  bool isLoading = false; // Simulated loading state

  @override
  void initState() {
    super.initState();
    // Simulate data loading
    
    fetchData(widget.token); 
    
  }

  // Future<void> fetchData() async {
  //   // Simulate fetching data from API
  //   setState(() {
  //     isLoading = true;
  //   });
  //   await Future.delayed(Duration(seconds: 2)); // Simulate 2-second delay
  //   setState(() {
  //     isLoading = false;
  //   });
  // }
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Report Page'),
    ),
    body: isLoading
        ? Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Doughnut Charts
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: _buildDoughnutChart(
                            title: 'Not Yet Started',
                            percentage: notStartedPercentage,
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: _buildDoughnutChart(
                            title: 'Completed',
                            percentage: completedPercentage,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Line Chart
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 8.0),
                  //   child: _buildLineChart(),
                  // ),
                  SizedBox(height: 20),
                  // Pie Chart
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: _buildPieChart(),
                  ),
                  SizedBox(height: 20),
                  // View More Button
                  ElevatedButton(
                    onPressed: () {
                      // Implement view more functionality
                    },
                    child: Text('View More'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
  );
}



  Widget _buildDoughnutChart({required String title, required double percentage}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: AspectRatio(
      aspectRatio: 1,
      child: PieChart(
          
        PieChartData(
          centerSpaceRadius: 40,
            
          
          sections: [
            PieChartSectionData(
              value: percentage,
              color: Colors.blue,
              title: '$percentage%', // Display percentage as chart title
              radius: 30,
              
            ),
            PieChartSectionData(
              value: 100 - percentage,
              color: Colors.grey[300]!,
              radius: 30,
            ),
          ],
        ),
        swapAnimationDuration: Duration(milliseconds: 500),
      ),
    ),
  );
}

  Widget _buildLineChart() {
    return AspectRatio(
      aspectRatio: 2,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: true),
          minX: 1,
          maxX: 7,
          minY: 0,
          maxY: 60,
          lineBarsData: [
            LineChartBarData(
              spots: lineChartData,
              isCurved: true,
              color: Colors.blue,
              barWidth: 2,
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
  return AspectRatio(
    aspectRatio: 1,
    child: PieChart(
      PieChartData(
        sections: pieChartData.map((data) {
          return PieChartSectionData(
            value: data.value,
            color: data.color,
            title: data.title,
            radius: 40, // Adjust the radius to make the slices thinner
          );
        }).toList(),
        borderData: FlBorderData(show: false),
        centerSpaceRadius: 70,
        sectionsSpace: 0,
      ),
      swapAnimationDuration: Duration(milliseconds: 500),
    ),
  );
}
}
