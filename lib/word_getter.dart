import "dart:collection";
import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;


class WordGetter {

  static var scafMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static var words = Queue<String>();

  static Future<String> get word async {
    if (words.isEmpty) {
      if (!(await getMore())) {
        return "TackyVortex";
      }
    }

    String first = words.removeFirst();
    print(first);
    return first;
  }

  static Future<bool> getMore() async {

    var res;
    try {
      res = await http.get(Uri.parse("https://api.urbandictionary.com/v0/random"));
    } catch (e) {
        var snackBar = SnackBar(content: Text("Could not access Urban Dictionary. Try checking your internet connection."));
        scafMessengerKey.currentState!.showSnackBar(snackBar);
        return false;
    }


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
      // couldn't fetch 
      var snackBar = SnackBar(content: Text("Something went wrong. Please try again later."));
      scafMessengerKey.currentState!.showSnackBar(snackBar);
      return false;
    }
  }



}
