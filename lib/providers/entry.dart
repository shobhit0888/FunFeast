import 'dart:async';
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';

import 'package:flutter/material.dart';
import 'package:fun_feast/api/client.dart';
import 'package:fun_feast/data/entry.dart';
// import 'package:pknetflix/api/client.dart';
// import 'package:pknetflix/data/entry.dart';

class EntryProvider extends ChangeNotifier {
  Map<String, Uint8List> _imageCache = {};

  static String _collectionId = "movies";

  Entry? _selected = null;
  Entry? get selected => _selected;

  Entry _featured = Entry.empty();
  Entry get featured => _featured;

  List<Entry> _entries = [];
  List<Entry> get entries => _entries;
  List<Entry> get originals => _entries.where((e) => e.isOriginal == true).toList();
  List<Entry> get animations => _entries
      .where((e) => e.genres.toLowerCase().contains('animation'))
      .toList();
  List<Entry> get newReleases => _entries
      .where((e) =>
          e.releaseDate != null &&
          e.releaseDate!.isAfter(DateTime.parse('2018-01-01')))
      .toList();

  List<Entry> get trending {
    var trending = _entries;

    trending.sort((a, b) => b.trendingIndex.compareTo(a.trendingIndex));

    return trending;
  }

  void setSelected(Entry entry) {
    _selected = entry;

    notifyListeners();
  }

  Future<void> list() async {
    final apiClient=ApiClient();
    var result =
        await apiClient.database.listDocuments(collectionId: _collectionId, databaseId: 'funFeastOtt');

    _entries = result.documents
        .map((document) => Entry.fromJson(document.data))
        .toList();
    _featured = _entries.isEmpty ? Entry.empty() : _entries[0];

    notifyListeners();
  }

  Future<Uint8List> imageFor(Entry entry) async {
    if (_imageCache.containsKey(entry.thumbnailImageId)) {
      return _imageCache[entry.thumbnailImageId]!;
    }
       final apiClient=ApiClient();
    final result =
        await apiClient.storage.getFileView(fileId: entry.thumbnailImageId, bucketId: 'posters');

    _imageCache[entry.thumbnailImageId] = result;

    return result;
  }
}
