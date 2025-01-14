import 'package:flutter/material.dart';
import 'package:flutter_parsed_text_field/flutter_parsed_text_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Parsed Text Field',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class Avenger {
  final String userId;
  final String displayName;

  Avenger({
    required this.userId,
    required this.displayName,
  });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final flutterParsedTextFieldController = FlutterParsedTextFieldController();

  String addedAvenger = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Parsed Text Field'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () => FocusScope.of(context).unfocus(),
              child: const Text('Unfocus'),
            ),
            Text('Recently Added Avenger: $addedAvenger'),
            FlutterParsedTextField(
              controller: flutterParsedTextFieldController,
              suggestionMatches: (matcher, suggestions) {},
              disableSuggestionOverlay: false,
              getMentions: () => [],
              onMentionedRemoved: (id) {},
              suggestionLimit: 5,
              //focusNode: ,
              matchers: [
                Matcher<Avenger>(
                  trigger: "@",
                  getSuggestions: (search) async => [
                    Avenger(userId: '3000', displayName: 'Ironman'),
                    Avenger(userId: '4000', displayName: 'Hulk'),
                    Avenger(userId: '5000', displayName: 'Black Widow'),
                  ]
                      .where((element) => search == null
                          ? true
                          : element.displayName
                              .toLowerCase()
                              .contains(search.toLowerCase()))
                      .toList(),
                  idProp: (avenger) => avenger.userId,
                  displayProp: (avenger) => avenger.displayName,
                  style: const TextStyle(color: Colors.red),
                  stringify: (trigger, avenger) {
                    return '[$trigger${avenger.displayName}:${avenger.userId}]';
                  },
                  parseRegExp: RegExp(r"\[(@([^\]]+)):([^\]]+)\]"),
                  parse: (regexp, avengerString) {
                    final avenger = regexp.firstMatch(avengerString);

                    if (avenger != null) {
                      return Avenger(
                        userId: avenger.group(3)!,
                        displayName: avenger.group(2)!,
                      );
                    }

                    throw 'Avenger not found';
                  },
                  onSuggestionAdded: (trigger, avenger) {
                    setState(() => addedAvenger = avenger.displayName);
                  },
                ),
                /*Matcher<String>(
                  trigger: "#",
                  suggestions: ['BattleOfNewYork', 'InfinityGauntlet'],
                  idProp: (hashtag) => hashtag,
                  displayProp: (hashtag) => hashtag,
                  style: const TextStyle(color: Colors.blue),
                  stringify: (trigger, hashtag) => hashtag,
                  alwaysHighlight: true,
                  parseRegExp: RegExp(r'(#([\w]+))'),
                  parse: (regex, hashtagString) => hashtagString,
                ),*/
              ],
            ),
            TextButton(
              child: const Text('Clear'),
              onPressed: () => flutterParsedTextFieldController.clear(),
            )
          ],
        ),
      ),
    );
  }
}
