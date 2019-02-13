
import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Noms Startups',
      theme: new ThemeData.dark(),
      home: new WordPairs(),
    );
  }
}
class WordPairs extends StatefulWidget {
  WordPairsState createState() => new WordPairsState();
}

class WordPairsState extends State<WordPairs> {
 
  final List<WordPair> _suggestions = <WordPair>[];
  final Set<WordPair> _liked = new Set<WordPair>();
  final TextStyle _style = const TextStyle(fontSize: 18.0,color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startups name generator'),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.favorite), onPressed: _pushSaved),
        ],
      ),
      body: _gSuggestions(),
    );
  }

  Widget _gSuggestions() {
    return new ListView.builder(
       
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (BuildContext _context, int i) {
          if (i.isOdd) {
            return new Divider();
          }
          final int index = i ~/ 2;
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }
          return _gLine(_suggestions[index]);
        });
  }

  Widget _gLine(WordPair pair) {

    final bool alreadySaved = _liked.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _style,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.add : Icons.add,
        color: alreadySaved ? Colors.blue : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _liked.remove(pair);
          } else {
            _liked.add(pair);
          }
        });
      },
    );
  }
  void _pushSaved() {
    Navigator.of(context).push(

      new MaterialPageRoute<void>(

        builder: (BuildContext context) {
          final Iterable<ListTile> tiles = _liked.map(
            (WordPair pair) {
              return new ListTile(
                title: new Text(
                  pair.asPascalCase,
                  style: _style,
                ),
              );
            },
          );
          final List<Widget> divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();
          return new Scaffold(
            appBar: new AppBar(
              title: const Text('Liked Suggestions'),
            ),
            body: new ListView(children: divided),
          );
        },
      ),
    );
  }
}
