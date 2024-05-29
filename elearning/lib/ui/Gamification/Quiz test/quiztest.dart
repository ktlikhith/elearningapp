import 'package:elearning/routes/routes.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class QuizPage extends StatefulWidget {
  final String token;

  const QuizPage({Key? key, required this.token}) : super(key: key);

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
      "selected_index": -1, // Initially no option is selected
    },
    {
      "id": 2,
      "question": "When did Google release Flutter?",
      "options": ['Jun 2017', 'Jun 2017', 'May 2017', 'May 2018'],
      "answer_index": 2,
      "selected_index": -1,
    },
    {
      "id": 3,
      "question": "A memory location that holds a single letter or number.",
      "options": ['Double', 'Int', 'Char', 'Word'],
      "answer_index": 2,
      "selected_index": -1,
    },
    {
      "id": 4,
      "question": "What command do you use to output data to the screen?",
      "options": ['Cin', 'Count>>', 'Cout', 'Output>>'],
      "answer_index": 2,
      "selected_index": -1,
    },
  ];

  int seconds = 120; // 2 minutes
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
    setState(() {
      sampleData[currentQuestionIndex]['selected_index'] = selectedIndex;
    });
  }

  void goToNextQuestion() {
    if (currentQuestionIndex < sampleData.length - 1) {
      setState(() {
        currentQuestionIndex++;
      });
    } else {
      int score = calculateScore();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Quiz Result'),
            content: Text('Successfully submitted the quiz!\nYour quiz score: $score'),
            actions: [
              TextButton(
                onPressed: () {
                  try {
                    Navigator.of(context).pushReplacementNamed(RouterManger.Gamification, arguments: widget.token);
                  } catch (e) {
                    print('Navigation Error: $e');
                  }

                  resetQuiz();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      ).then((value) {
        // Go back to the previous screen after OK is pressed
        try {
          Navigator.of(context).pushReplacementNamed(RouterManger.Gamification, arguments: widget.token);
        } catch (e) {
          print('Navigation Error: $e');
        }
      });
    }
  }

  int calculateScore() {
    int score = 0;
    for (var question in sampleData) {
      if (question['selected_index'] == question['answer_index']) {
        score++;
      }
    }
    return score;
  }

  void resetQuiz() {
    setState(() {
      currentQuestionIndex = 0;
      for (var question in sampleData) {
        question['selected_index'] = -1;
      }
    });
  }

  void goToPreviousQuestion() {
    if (currentQuestionIndex > 0) {
      setState(() {
        currentQuestionIndex--;
      });
    }
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    bool isFirstQuestion = currentQuestionIndex == 0;
    bool isLastQuestion = currentQuestionIndex == sampleData.length - 1;
    final screenSize = MediaQuery.of(context).size;

    return WillPopScope(
      // Handle back button press
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Quiz'),
          centerTitle: false,
          backgroundColor: Theme.of(context).primaryColor,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              try {
                Navigator.of(context).pushReplacementNamed(RouterManger.Gamification, arguments: widget.token);
              } catch (e) {
                print('Navigation Error: $e');
              }
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Question ${currentQuestionIndex + 1}/${sampleData.length}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Icon(Icons.timer),
                      SizedBox(width: 5),
                      Text(
                        ' ${formatTime(seconds)}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 60),
                child: Card(
                  color: Colors.grey.shade100,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sampleData[currentQuestionIndex]['question'],
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(height: 20),
                        ListView.builder(
                          shrinkWrap: true,
                          itemCount: sampleData[currentQuestionIndex]['options'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              onTap: () {
                                answerQuestion(index);
                              },
                              title: Container(
                                decoration: BoxDecoration(
                                  color: sampleData[currentQuestionIndex]['selected_index'] == index ? Color.fromARGB(255, 105, 236, 109) : Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color.fromARGB(255, 145, 145, 146),
                                    width: sampleData[currentQuestionIndex]['selected_index'] == index ? 2 : 1,
                                  ),
                                ),
                                padding: EdgeInsets.all(12),
                                child: Text(sampleData[currentQuestionIndex]['options'][index]),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment:                MainAxisAlignment.spaceBetween,
                children: [
                  if (!isFirstQuestion)
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: IconButton(
                          onPressed: () {
                            goToPreviousQuestion();
                          },
                          icon: Icon(Icons.arrow_circle_left_outlined, size: 35),
                          color: Colors.blueAccent,
                          splashColor: Colors.transparent,
                        ),
                      ),
                    ),
                  Expanded(
                    flex: 9,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          isLastQuestion ? goToNextQuestion() : goToNextQuestion();
                        },
                        child: Text(isLastQuestion ? 'Submit' : 'Next', style: TextStyle(color: Colors.white),),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).secondaryHeaderColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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

