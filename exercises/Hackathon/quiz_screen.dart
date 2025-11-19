import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';


class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<DocumentSnapshot> questions = [];
  int currentQuestionIndex = 0;
  int score = 0;
  late Timer timer;
  int remainingSeconds = 60;
  List<bool> answersSelected = [];

  @override
  void initState() {
    super.initState();
    fetchQuestions();
    startTimer();
  }

  void fetchQuestions() async {
    var snapshot = await FirebaseFirestore.instance
        .collection('questions')
        .get();
    var docs = snapshot.docs;
    docs.shuffle();
    setState(() {
      questions = docs.take(10).toList();
      answersSelected = List<bool>.filled(questions[0]['options'].length, false);
    });
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          timer.cancel();
          finishQuiz();
        }
      });
    });
  }

  void finishQuiz() {
    
    String uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection('results').add({
      'uid': uid,
      'score': score,
      'timestamp': Timestamp.now(),
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ScoreScreen(score: score)),
    );
  }

  void onAnswerSelected(int index) {
    var question = questions[currentQuestionIndex];
    String type = question['type'];
    List correctAnswers = question['correctAnswers'];

    if (type == 'multiple') {
      bool isCorrect = (correctAnswers.length == 1) && (correctAnswers[0] == index);
      if (isCorrect) score++;
      nextQuestion();
    } else if (type == 'multi') {
     
      setState(() {
        answersSelected[index] = !answersSelected[index];
      });
    } else if (type == 'tf') {
      bool isCorrect = (correctAnswers[0] == index);
      if (isCorrect) score++;
      nextQuestion();
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex < questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        answersSelected = List<bool>.filled(questions[currentQuestionIndex]['options'].length, false);
      });
    } else {
      timer.cancel();
      finishQuiz();
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (questions.isEmpty) return Center(child: CircularProgressIndicator());

    var question = questions[currentQuestionIndex];
    var options = question['options'];
    String type = question['type'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz (${remainingSeconds}s left)'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Question ${currentQuestionIndex + 1} of 10:', style: TextStyle(fontSize: 20)),
            SizedBox(height: 10),
            Text(question['text'], style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  if (type == 'multi') {
                    return CheckboxListTile(
                      title: Text(options[index]),
                      value: answersSelected[index],
                      onChanged: (val) => onAnswerSelected(index),
                    );
                  } else {
                    return RadioListTile<int>(
                      title: Text(options[index]),
                      value: index,
                      groupValue: null,
                      onChanged: (val) => onAnswerSelected(index),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScoreScreen extends StatelessWidget {
  final int score;
  ScoreScreen({required this.score});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Your Score')),
      body: Center(
        child: Text('Your score: $score / 10', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
