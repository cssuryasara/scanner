import 'dart:io';

import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class ImageFiles extends ChangeNotifier {
  List<File> _items = [];

  List<File> get itemss {
    return [..._items];
  }

//Provider.of(context, listen: false).addItem(
  void addItem(
    File value,
  ) {
    _items.add(value);

    notifyListeners();
  }
}
