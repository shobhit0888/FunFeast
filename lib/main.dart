
import 'package:flutter/material.dart';
import 'package:fun_feast/providers/entry.dart';
import 'package:fun_feast/providers/watchlist.dart';
import 'package:fun_feast/screens/navigation.dart';
import 'package:fun_feast/screens/onboarding.dart';

import 'package:provider/provider.dart';

import 'providers/account.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AccountProvider()),
        ChangeNotifierProvider(create: (context) => EntryProvider()),
        ChangeNotifierProvider(create: (context) => WatchListProvider()),
      ],
      child: const Fun_Feast(),
    )
  );
}

class Fun_Feast extends StatelessWidget {
  const Fun_Feast({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PkNetflix',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: FutureBuilder(
        future: context.read<AccountProvider>().isValid(),
        builder: (context, snapshot) => context.watch<AccountProvider>().session == null ? const OnboardingScreen() : const NavScreen(),
      )
    );
  }
}