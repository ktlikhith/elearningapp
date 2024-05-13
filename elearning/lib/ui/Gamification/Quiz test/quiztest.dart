import 'package:flutter/material.dart';
import 'dart:async';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: QuizPage(),
//     );
//   }
// }

class QuizPage extends StatefulWidget {
  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0;
  List<Map<String, dynamic>> sampleData = [
    {
      "id": 1,
      "question": "Flutter is an open-source UI software development kit created by ______",
      "options": ['Apple', 'Google', 'Facebook', 'Microsoft'],
      "answer_index": 1,
    },
    {
      "id": 2,
      "question": "When did Google release Flutter?",
      "options": ['Jun 2017', 'Jun 2017', 'May 2017', 'May 2018'],
      "answer_index": 2,
    },
    {
      "id": 3,
      "question": "A memory location that holds a single letter or number.",
      "options": ['Double', 'Int', 'Char', 'Word'],
      "answer_index": 2,
    },
    {
      "id": 4,
      "question": "What command do you use to output data to the screen?",
      "options": ['Cin', 'Count>>', 'Cout', 'Output>>'],
      "answer_index": 2,
    },
  ];

  int seconds = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        timer.cancel();
        // Handle timer completion, like showing results or ending quiz
      }
    });
  }

  void answerQuestion(int selectedIndex) {
    if (selectedIndex == sampleData[currentQuestionIndex]['answer_index']) {
      // Correct answer handling
      print('Correct!');
    } else {
      // Incorrect answer handling
      print('Incorrect!');
    }
  }

  void goToNextQuestion() {
    if (currentQuestionIndex < sampleData.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      // Quiz completed handling
      print('Quiz completed!');
    }
  }

  void goToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1}/${sampleData.length}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              sampleData[currentQuestionIndex]['question'],
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Column(
              children: List.generate(
                sampleData[currentQuestionIndex]['options'].length,
                (index) => ElevatedButton(
                  onPressed: () {
                    answerQuestion(index);
                  },
                  child: Text(sampleData[currentQuestionIndex]['options'][index]),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    goToPreviousQuestion();
                  },
                  child: Text('Previous'),
                ),
                ElevatedButton(
                  onPressed: () {
                    goToNextQuestion();
                  },
                  child: Text('Next'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Time Remaining: $seconds seconds',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
