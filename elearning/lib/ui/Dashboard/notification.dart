import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  final String token;

  const NotificationScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ListTile(
                title: Text(
                  'Upcoming courses have no teachers or students',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text('7 days 20 hours ago'),
                onTap: () {
                  // Navigate to the details screen for this notification
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationDetailsScreen(token: token),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        ),
    );
  }
}

class NotificationDetailsScreen extends StatelessWidget {
  final String token;

  const NotificationDetailsScreen({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upcoming courses have no teachers or students',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '7 days 20 hours ago',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Hi Lucas,\n\nCourses with start dates in the next week have been identified as having no teacher or student enrolments.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Handle button press, e.g., open a link
              },
              child: Text('View Insight'),
            ),
          ],
        ),
      ),
    );
  }
}
