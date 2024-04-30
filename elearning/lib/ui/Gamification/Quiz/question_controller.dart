import 'package:elearning/ui/Gamification/Quiz/Questions.dart';
import 'package:elearning/ui/Gamification/Quiz/quiz_screens/score_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';



// We use get package for our state management

class QuestionController extends GetxController
    with SingleGetTickerProviderMixin {
      // called immediately after the widget is allocated memory
  @override
void onInit() {
  //set timer for the quiz in sec.
    int timeofquiz=120;
    // Initialize page controller
    _pageController = PageController();
    
    // Initialize animation controller and animation
    _animationController =
        AnimationController(duration: Duration(seconds: timeofquiz), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        update();
      });

    //    _animationController.forward().whenComplete(() {
    //   Get.to(ScoreScreen());
    // });
   
    super.onInit();
  }

      
  // Lets animated our progress bar
 PageController _pageController = PageController();

   late AnimationController _animationController = AnimationController(
  duration: Duration(seconds: timeofquiz),
  vsync: this,
);
  late Animation _animation = Tween<double>(
  begin: 0,
  end: 1,
).animate(_animationController);
  // so that we can access our animation outside
  Animation get animation => this._animation;

   
  PageController get pageController => this._pageController;
  int timeofquiz=60;

  List<Question> _questions = sample_data
      .map(
        (question) => Question(
            id: question['id'],
            question: question['question'],
            options: question['options'],
            answer: question['answer_index']),
      )
      .toList();
  List<Question> get questions => this._questions;

  bool _isAnswered = false;
  bool get isAnswered => this._isAnswered;

  int _correctAns=0;
  int get correctAns => this._correctAns;

   int _selectedAns=0;
  int get selectedAns => this._selectedAns;

  // for more about obs please check documentation
  RxInt _questionNumber = 1.obs;
  RxInt get questionNumber => this._questionNumber;

  int _numOfCorrectAns = 0;
  int get numOfCorrectAns => this._numOfCorrectAns;

  
  // // called just before the Controller is deleted from memory
  @override
  void onClose() {
  
    _animationController.dispose();
    _pageController.dispose();
      super.onClose();
  }

  void checkAns(Question question, int selectedIndex) {
    // because once user press any option then it will run
    _isAnswered = true;
    _correctAns = question.answer;
    _selectedAns = selectedIndex;

    if (_correctAns == _selectedAns) {_numOfCorrectAns++;}

    // It will stop the counter
    _animationController.stop();
    update();

    // Once user select an ans after 3s it will go to the next qn
    Future.delayed(Duration(seconds: 3), () {
      nextQuestion();
    });
  }

void previousQuestion() {
  if (_questionNumber.value != 1) {
    _isAnswered = false;
    _pageController.previousPage(
      duration: Duration(milliseconds: 250),
      curve: Curves.ease,
    );
    // Update the question number without triggering the timer
    _questionNumber.value -= 1;
    update();
  }
}

  void nextQuestion() {
    
    if (_questionNumber.value != _questions.length) {
     
      _pageController.nextPage(
          duration: Duration(milliseconds: 250), curve: Curves.ease);

      // Reset the counter
      _animationController.reset();

      // Then start it again
      // Once timer is finish go to the next qn
      _animationController.forward().whenComplete(nextQuestion);
    } else {
      // Get package provide us simple way to naviigate another page
      Get.to(ScoreScreen());
    }
  }
  void skipQuestion() {
    
    if (_questionNumber.value != _questions.length) {
      _isAnswered = false;
      _pageController.nextPage(
          duration: Duration(milliseconds: 250), curve: Curves.ease);

      // Reset the counter
      _animationController.reset();

      // Then start it again
      // Once timer is finish go to the next qn
      _animationController.forward().whenComplete(nextQuestion);
        
    } else {
      // Get package provide us simple way to naviigate another page
      Get.to(ScoreScreen());
    }
  }


  void updateTheQnNum(int index) {
    _questionNumber.value = index + 1;
  }
}