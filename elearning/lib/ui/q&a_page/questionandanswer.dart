import 'package:flutter/material.dart';

class QuestionAnswersPage extends StatefulWidget {
  @override
  _QuestionAnswersPageState createState() => _QuestionAnswersPageState();
}

class _QuestionAnswersPageState extends State<QuestionAnswersPage> {
  bool showAnswerInput = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            // Add functionality for the menu icon here
          },
        ),
        title: Text(
          "Question and Answers",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage('url_to_profile_picture'),
                        radius: 30,
                      ),
                      SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "User's Name",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            "1 hour ago",
                            style: TextStyle(
                              color: Colors.grey.withOpacity(0.6),
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "User's Question?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            "Category: Marketing",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      // Add functionality for "View all Answers" button here
                    },
                    child: Text("View all Answers"),
                    style: ElevatedButton.styleFrom(
                      surfaceTintColor: Colors.blue,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  if (showAnswerInput)
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Type your answer here...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showAnswerInput = true;
                      });
                    },
                    child: Text("Answer Now"),
                    style: ElevatedButton.styleFrom(
                      surfaceTintColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: QuestionAnswersPage(),
  ));
}
