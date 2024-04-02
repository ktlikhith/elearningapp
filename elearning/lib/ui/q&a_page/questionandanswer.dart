import 'package:elearning/routes/routes.dart';
import 'package:flutter/material.dart';

// class ProfileApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return  ProfilePage();
    
//   }
// }
class QuestionAnswersPage extends StatefulWidget {
  const QuestionAnswersPage({super.key});

  @override
  _QuestionAnswersPageState createState() => _QuestionAnswersPageState();
}

class _QuestionAnswersPageState extends State<QuestionAnswersPage> {
  bool showAnswerInput = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.menu),
        //   onPressed: () {
        //     // Add functionality for the menu icon here
        //   },
        // ),
        title: const Text(
          "Question and Answers",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushNamed(RouterManger.homescreen);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
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
                      const CircleAvatar(
                        backgroundImage: NetworkImage('url_to_profile_picture'),
                        radius: 30,
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "User's Name",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          Text(
                            "1 hour ago",
                            style: TextStyle(
                              color: Colors.grey.withOpacity(0.6),
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            "User's Question?",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                          ),
                          const SizedBox(height: 8.0),
                          const Text(
                            "Category: Marketing",
                            style: TextStyle(
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      // Add functionality for "View all Answers" button here
                    },
                    style: ElevatedButton.styleFrom(
                      surfaceTintColor: Colors.blue,
                    ),
                    child: const Text("View all Answers"),
                  ),
                  const SizedBox(height: 10.0),
                  if (showAnswerInput)
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Type your answer here...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  const SizedBox(height: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showAnswerInput = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      surfaceTintColor: Colors.blue,
                    ),
                    child: const Text("Answer Now"),
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


