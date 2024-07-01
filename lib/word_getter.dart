import "dart:collection";
import "dart:convert";

import "package:flutter/material.dart";
import "package:http/http.dart" as http;


class WordGetter {

  static var scafMessengerKey = GlobalKey<ScaffoldMessengerState>();

  static var words = Queue<String>();

  static Future<String> get word async {
    if (words.isEmpty) {
      if (!(await fetchRandoms())) {
        return "TackyVortex";
      }
    }

    String first = words.removeFirst();
    print(first);
    return first;
  }

  static Future<bool> fetchRandoms() async {

    var res;
    try {
      res = await http.get(Uri.parse("https://api.urbandictionary.com/v0/random"));
    } catch (e) {
        showSnackBarMessage("Could not access Urban Dictionary. Try checking your internet connection.");
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
      showSnackBarMessage("Something went wrong. Please try again later.");
      return false;
    }
  }


  static Future<bool> fetchSimilar(String term) async {

    var res;
    try {
      res = await http.get(Uri.parse("https://api.urbandictionary.com/v0/autocomplete-extra?term=$term"));
    } catch (e) {
        showSnackBarMessage("Could not access Urban Dictionary. Try checking your internet connection.");
        return false;
    }


    if (res.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(res.body);

      if (json.containsKey("results")) {
        var results = List<Map<String, dynamic>>.from(json["results"]);
        print("got ${results.length} similar");

        for (var m in results) {
          words.add(m["term"]);
        }

      }
      return true;
    } else {
      // couldn't fetch 
      showSnackBarMessage("Something went wrong. Please try again later.");
      return false;
    }
  }


  static void showSnackBarMessage(String message) {
    var snackBar = SnackBar(content: Text(message));
    scafMessengerKey.currentState!.showSnackBar(snackBar);
  }



}
