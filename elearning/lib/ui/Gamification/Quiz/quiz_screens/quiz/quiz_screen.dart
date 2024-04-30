import 'package:elearning/ui/Gamification/Quiz/question_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:neopop/neopop.dart';


import 'components/body.dart';

class QuizScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    QuestionController _controller = Get.put(QuestionController());
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        // Fluttter show the back button automatically
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          ElevatedButton(
                    onPressed: () {
                      _controller.nextQuestion();
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 3,backgroundColor: Color.fromARGB(255, 216, 234, 11)
                    ),
                    child: Text('Skip',style: TextStyle( fontSize: 15,color: Color.fromARGB(255, 10, 10, 10)),)
                  )
        ],
      ),
      body: Body(),
    );
  }
}