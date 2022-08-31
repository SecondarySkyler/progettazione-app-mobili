import 'package:flutter/material.dart';
import 'package:my_closet/screens/Home.dart';
import 'package:my_closet/screens/ListaOutfit.dart';
import 'package:my_closet/screens/Profilo.dart';
import '/screens/ListaVestiti.dart';
import '/utils/RouteGenerator.dart';
import '/widgets/BottomBar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "MyCloset app",
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}

class App extends StatefulWidget {
  final int? index;

  const App({Key? key, this.index}) : super(key: key);
  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late int _currentIndex;

  @override
  void initState() {
    _currentIndex = widget.index ?? 0;
  }

  //int _currentScreens = widget?.index ?? 0;
  List<Widget> screens = [
    Home(),
    ListaVestiti(),
    ListaOutfit(),
    Profilo()
  ];

  void _updateIndex(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: screens[_currentIndex],
        bottomNavigationBar: BottomBar(currentIndex: _currentIndex, updateIndex: _updateIndex,),
      ),
    );
  }
}