import 'package:elearning/ui/Gamification/Quiz/constants.dart';
import 'package:elearning/ui/Gamification/Quiz/question_controller.dart';
import 'package:elearning/ui/Gamification/Quiz/quiz_screens/score_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:flutter_svg/svg.dart';

import 'progress_bar.dart';
import 'question_card.dart';

class Body extends StatelessWidget {
  const Body({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    QuestionController _questionController = Get.put(QuestionController());
    return Stack(
      children: [
      // Image.asset('assets/quizicons/quizbackground2.jpg',fit: BoxFit.fitHeight,),
        // SvgPicture.asset("assets/quizicons/bg.svg", fit: BoxFit.fill),
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: ProgressBar(),
              ),
              SizedBox(height: kDefaultPadding),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                child: Obx(
                  () => Text.rich(
                    TextSpan(
                      text:
                          "Question ${_questionController.questionNumber.value}",
                      style: Theme.of(context)
                          .textTheme
                          .headline4
                          ?.copyWith(color: kSecondaryColor),
                      children: [
                        TextSpan(
                          text: "/${_questionController.questions.length}",
                          style: Theme.of(context)
                              .textTheme
                              .headline5
                              ?.copyWith(color: kSecondaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(thickness: 1.5),
              SizedBox(height: kDefaultPadding),
              Expanded(
                child: PageView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  controller: _questionController.pageController,
                  onPageChanged: _questionController.updateTheQnNum,
                  itemCount: _questionController.questions.length,
                  itemBuilder: (context, index) => QuestionCard(
                    question: _questionController.questions[index],
                  ),
                ),
              ),
              SizedBox(height: kDefaultPadding), // Add some space below the PageView
             Padding(
  padding: const EdgeInsets.all(11.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      FloatingActionButton(
        onPressed: _questionController.previousQuestion,
        child: Icon(Icons.arrow_back),
      ),
      Obx(
        () =>Container(
  width: 300.0, // Set the desired width
  height: 48.0, // Set the desired height
  child: FloatingActionButton.extended(
    onPressed: () {
      if (_questionController.questionNumber.value != _questionController.questions.length) {
        _questionController.nextQuestion();
      } else {
        Get.to(ScoreScreen());
      }
    },
    label: Text(
      _questionController.questionNumber.value != _questionController.questions.length
          ? "Next"
          : "Submit",
      style: TextStyle(fontSize: 16.0), // Adjust font size as needed
    ),
    // icon: Icon(Icons.arrow_forward), // Add an icon if desired
    elevation: 2.0, // Set elevation for the button
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0), // Match the border radius with the ElevatedButton
    ),
    // backgroundColor: Colors.blue, // Set background color
  ),
),

      ),
    ],
  ),
),

            ],
          ),
        ),
      ],
    );
  }
}
