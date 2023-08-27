import 'dart:async';
import 'dart:typed_data';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import 'package:flutter/material.dart';
import 'package:fun_feast/data/entry.dart';
// import 'package:pknetflix/data/entry.dart';

import '../api/client.dart';

class WatchListProvider extends ChangeNotifier {
  final String _collectionId = "watchlists";
  final apiClient = ApiClient();
  List<Entry> _entries = [];
  List<Entry> get entries => _entries;

  Future<User> get user async {
    return await apiClient.account.get();
  }

  Future<List<Entry>> list() async {
    final user = await this.user;

    final watchlist = await apiClient.database.listDocuments(
      collectionId: _collectionId,
      databaseId: 'funFeastOtt',
    );

    final movieIds = watchlist.documents
        .map((document) => document.data["movieId"])
        .toList();
    final entries = (await apiClient.database
            .listDocuments(collectionId: 'movies', databaseId: 'funFeastOtt'))
        .documents
        .map((document) => Entry.fromJson(document.data))
        .toList();
    final filtered =
        entries.where((entry) => movieIds.contains(entry.id)).toList();

    _entries = filtered;

    notifyListeners();

    return _entries;
  }

  Future<void> add(Entry entry) async {
    final user = await this.user;

    var result = await apiClient.database.createDocument(
        collectionId: _collectionId,
        documentId: 'unique()',
        data: {
          "userId": user.$id,
          "movieId": entry.id,
          "createdAt": (DateTime.now().second / 1000).round()
        },
        databaseId: 'funFeastOtt');

    _entries.add(Entry.fromJson(result.data));

    list();
  }

  Future<void> remove(Entry entry) async {
    final user = await this.user;

    final result = await apiClient.database.listDocuments(
        collectionId: _collectionId,
        queries: [
          Query.equal("userId", user.$id),
          Query.equal("movieId", entry.id)
        ],
        databaseId: 'funFeastOtt');

    final id = result.documents.first.$id;

    await apiClient.database.deleteDocument(
        collectionId: _collectionId, documentId: id, databaseId: 'funFeastOtt');

    list();
  }

  Future<Uint8List> imageFor(Entry entry) async {
    return await apiClient.storage
        .getFileView(fileId: entry.thumbnailImageId, bucketId: 'posters');
  }

  bool isOnList(Entry entry) => _entries.any((e) => e.id == entry.id);
}
