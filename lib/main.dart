import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'meal_api.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TextEditingController controller = TextEditingController();
  var enabled = false;
  List<Score> score = [];
  double rate = 0;

  void initstate() {}

  @override
  Widget build(BuildContext context) {
    var listView = ListView.separated(
      itemCount: score.length,
      separatorBuilder: (context, index) =>const Divider(),
      itemBuilder: (context, index) => ListTile(
        leading: Text('${score[index].rate}'),
        title: Text(score[index].comment),
      ),
    );

    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            RatingBar.builder(
              initialRating: 3,
              minRating: 0.5,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  rate = rating;
                  enabled = true;
                });
                print(rating);
              },
            ),
            TextFormField(
              controller: controller,
              enabled: enabled,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "한마디 적어 최대 *30글자",
                  label: Text('별점 주고 클릭')),
              maxLength: 30,
            ),
            ElevatedButton(
                onPressed: enabled
                    ? () async{
                        var api = MealApi();
                        //2023-08-16 16:55:45 -> 2023-08-16
                        var evalDate = DateTime.now().toString().split(' ')[0];
                        var res = await api.insert(evalDate, rate, controller.text);
                        print(res);


                        score.add(
                            new Score(rate: rate, comment: controller.text));
                        setState(() {
                          listView;
                        });
                      }
                    : null,
                child: Text('저장하기')),
            Expanded(child: listView),
          ],
        ),
      ),
    );
  }
}

class Score {
  double rate;
  String comment;
  Score({required this.rate, required this.comment});
}
