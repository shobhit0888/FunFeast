import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fun_feast/data/entry.dart';
import 'package:fun_feast/providers/entry.dart';
// import 'package:pknetflix/data/entry.dart';
// import 'package:pknetflix/providers/entry.dart';

import 'package:provider/provider.dart';

import '../providers/watchlist.dart';
import '../widgets/buttons/icon.dart';
import 'details.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({Key? key}) : super(key: key);

  @override
  _WatchlistScreenState createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _row(Entry entry) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<Uint8List>(
          future: context.read<EntryProvider>().imageFor(entry),
          builder: (context, snapshot) =>
              snapshot.hasData && snapshot.data != null
                  ? Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.contain,
                          image: Image.memory(snapshot.data!).image,
                        ),
                      ),
                    )
                  : Container(),
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              entry.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              (entry.description ?? "").substring(0, 50) + "...",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        )),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 30, 20),
          child: VerticalIconButton(
              icon: Icons.delete,
              title: '',
              tap: () {
                context.read<WatchListProvider>().remove(entry);
              }),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Watchlist'),
          actions: [
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: FutureBuilder<List<Entry>>(
            future: context.read<WatchListProvider>().list(),
            builder: (context, snapshot) {
              return snapshot.hasData == false || snapshot.data == null
                  ? const Padding(
                      padding: EdgeInsets.all(60),
                      child: Center(child: CircularProgressIndicator()))
                  : ListView(
                      children: snapshot.data!
                          .map((entry) => GestureDetector(
                              child: _row(entry),
                              onTap: () async {
                                await showDialog(
                                    context: context,
                                    builder: (context) =>
                                        DetailsScreen(entry: entry));
                              }))
                          .toList(),
                    );
            }));
  }
}
