import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:username_generator/word_getter.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MyAppState(),
        child: MaterialApp(
          title: 'Home',
          theme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                  seedColor: Color.fromARGB(255, 0, 221, 136)           )
          ),
          home: MyHomePage(),
          scaffoldMessengerKey: WordGetter.scafMessengerKey,

          debugShowCheckedModeBanner: false,

        ));
  }
}

class MyAppState extends ChangeNotifier {

  String current = "";
  IconData favIcon = Icons.favorite_border;

  var favourites = <String>{};



  void getNext() async {
    current = await WordGetter.word;
    favIcon = Icons.favorite_border;
    notifyListeners();
  }

  void toggleFavourite() {
    if (favourites.contains(current)) {
      favourites.remove(current);
      favIcon = Icons.favorite_border;
    } else {
      favourites.add(current);
      favIcon = Icons.favorite;
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;

    if (selectedIndex == 0) {
      page = GeneratorPage();
    } else {
      page = FavouritesPage();
    }

    return LayoutBuilder(builder: (context, constraints) {


      return Scaffold(
        appBar: AppBar(
          title: Text("Username Generator", style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimary),),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.primary,
          leading: IconButton(
            icon: Icon(Icons.home),
            onPressed: (){
              if (selectedIndex == 0) return;
              setState(() {
                selectedIndex = 0;
              });
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.favorite),
              onPressed: (){
                if (selectedIndex == 1) return;
                setState(() {
                selectedIndex = 1;
              });
              },
            ),
          ],
          
          
          iconTheme: IconThemeData(color: Colors.white),
        ),

          body: page,
      );

      // return Scaffold(
      //   body: Row(
      //     children: [
      //       SafeArea(
      //         child: NavigationRail(
      //           extended: false,
      //           destinations: [
      //             NavigationRailDestination(
      //               icon: Icon(Icons.home),
      //               label: Text('Home'),
      //             ),
      //             NavigationRailDestination(
      //               icon: Icon(Icons.favorite),
      //               label: Text('Favorites'),
      //             ),
      //           ],
      //           selectedIndex: selectedIndex,
      //           onDestinationSelected: (value) {
      //             setState(() {
      //               selectedIndex = value;
      //             });
      //           },
      //         ),
      //       ),
      //       Expanded(
      //         child: Container(
      //           color: Theme.of(context).colorScheme.primaryContainer,
      //           child: page,
      //         ),
      //       ),
      //     ],
      //   ),
      // );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var word = appState.current;

    if (word == ":NoInternet:") {

    }

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Word(word: word),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavourite();
                  },
                  icon: Icon(appState.favIcon),
                  label: Text("Like"),
                ),
                ElevatedButton(
                    onPressed: () {
                      appState.getNext();
                    },
                    child: Text("Next")),
              ],
            ),
          ],
        ),
    )
    );
  }
}

class Word extends StatefulWidget {
  const Word({
    super.key,
    required this.word,
  });

  final String word;

  @override
  State<Word> createState() => _WordState();

}

class _WordState extends State<Word> {

  @override
  void initState() {
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          widget.word,
          style: style,
        ),
      ),
    );
  }
}


class FavouritesPage extends StatelessWidget {
  const FavouritesPage({super.key});


  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favourites.isEmpty) {
      return Center(
        child: Text('No favourites yet.'),
      );
    }

    
    return Center(
      child: ListView(
        children: [
          Padding(padding: const EdgeInsets.all(10)),
      
          for (String w in appState.favourites) Center(child: Text(w)),
        ],
      ),
    );
      
  }
}