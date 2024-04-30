// import 'package:elearning/ui/Gamification/Quiz/question_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';

// import 'package:flutter_svg/svg.dart';

// import '../../../constants.dart';
// class ProgressBar extends StatelessWidget {
//   const ProgressBar({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     QuestionController _qnController = Get.put(QuestionController());

//     return Container(
//       width: double.infinity,
//       height: 35,
//       decoration: BoxDecoration(
//         border: Border.all(color: Color(0xFF3F4768), width: 3),
//         borderRadius: BorderRadius.circular(50),
//       ),
//       child: GetBuilder<QuestionController>(
//         init: QuestionController(),
//         builder: (controller) {
//           // Calculate remaining seconds based on timeofquiz and current animation progress
//           int remainingSeconds = ((_qnController.timeofquiz * (1 - controller.animation.value)).round());

//           // Calculate minutes and seconds from remainingSeconds
//           int minutes = remainingSeconds ~/ 60;
//           int seconds = remainingSeconds % 60;

//           return Stack(
//             children: [
//               LayoutBuilder(
//                 builder: (context, constraints) => Container(
//                   width: constraints.maxWidth * controller.animation.value,
//                   decoration: BoxDecoration(
//                     gradient: kPrimaryGradient,
//                     borderRadius: BorderRadius.circular(50),
//                   ),
//                 ),
//               ),
//               Positioned.fill(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: kDefaultPadding / 2,
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text("$minutes min $seconds sec"),
//                       SvgPicture.asset(
//                         "assets/quizicons/clock-two-svgrepo-com.svg",
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:elearning/ui/Gamification/Quiz/question_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import 'package:flutter_svg/svg.dart';

import '../../../constants.dart';

class ProgressBar extends StatelessWidget {
  
  const ProgressBar({
     Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
        QuestionController _qnController = Get.put(QuestionController());
    return Container(
      width: double.infinity,
      height: 35,
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF3F4768), width: 3),
        borderRadius: BorderRadius.circular(50),
      ),
      child: GetBuilder<QuestionController>(
        init: QuestionController(),
        builder: (controller) {
          return Stack(
            children: [
              // LayoutBuilder provide us the available space for the conatiner
              // constraints.maxWidth needed for our animation
              LayoutBuilder(
                builder: (context, constraints) => Container(
                  // from 0 to 1 it takes 60s
                  width: constraints.maxWidth * controller.animation.value,
                  decoration: BoxDecoration(
                    gradient: kPrimaryGradient,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kDefaultPadding / 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${(controller.animation.value * _qnController.timeofquiz).round()} sec"),
                      SvgPicture.asset("assets/quizicons/clock-two-svgrepo-com.svg"),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}