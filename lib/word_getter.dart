import "dart:collection";
import "dart:convert";

import "package:http/http.dart" as http;


class WordGetter {

  static var words = Queue<String>();

  static Future<String> get word async {
    if (words.isEmpty) {
      bool success = await getMore();
      if (!success) {
        return "error";
      }
    }

    String first = words.removeFirst();
    print(first);
    return first;
  }

  static Future<bool> getMore() async {
    var res = await http.get(Uri.parse("https://api.urbandictionary.com/v0/random"));
    
    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      if (json.containsKey("list")) {
        var list = List<Map<String, dynamic>>.from(json["list"]);
        print("got ${list.length} words");

        for (var m in list) {
          words.add(m["word"]);
        }

      }
      return true;
    } else {
      // couldn't fetch words
      return false;
    }
  }



}
