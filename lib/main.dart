import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:grokart/widgets/direction_tile.dart';
import 'package:grokart/widgets/item_tile.dart';
import 'package:grokart/widgets/store_tile.dart';
import 'constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GroKart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaleFactor: 1.0, boldText: false),
          child: child!,
        );
      },
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoading = true;
  final _controller = PageController(initialPage: 0);
  final _directionsController = ScrollController();
  int _visiblePage = 0;
  Map<String, dynamic>? _selectedStore;
  List<Map<String, dynamic>> _selectedItems = [];
  int _indexPosition = 0;
  int _currentAisle = 0;

  @override
  void initState() {
    _displayLoadup();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _directionsController.dispose();
    super.dispose();
  }

  void _displayLoadup() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() => _isLoading = false);
  }

  void _handleItemTap(Map<String, dynamic> item) {
    if (_selectedItems.any((e) => e['name'] == item['name'])) {
      _selectedItems.removeWhere((e) => e['name'] == item['name']);
    } else {
      _selectedItems.add(item);
    }

    setState(() {});
  }

  void _handleStoreTap(Map<String, dynamic> store) {
    _selectedStore = store;

    setState(() {});
  }

  bool _isItemSelected(Map<String, dynamic> item) {
    return _selectedItems.any((e) => e['name'] == item['name']);
  }

  Color _getButtonColor() {
    if (_visiblePage == 0) {
      return _selectedStore == null ? Colors.grey.shade300 : Colors.green;
    } else if (_visiblePage == 1) {
      return _selectedItems.isEmpty ? Colors.grey.shade300 : Colors.green;
    } else {
      return Colors.green;
    }
  }

  String _getButtonText() {
    if (_visiblePage == 0) {
      return 'Shop';
    } else if (_visiblePage == 1) {
      return _selectedItems.isEmpty
          ? 'Continue'
          : 'Continue (${_selectedItems.length})';
    } else {
      return 'Done';
    }
  }

  void _handleButtonTap() async {
    if (_visiblePage == 0 && _selectedStore != null) {
      _controller.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else if (_visiblePage == 1 && _selectedItems.isNotEmpty) {
      _controller.animateToPage(
        2,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else if (_visiblePage == 2) {
      if (_indexPosition != _selectedItems.length - 1) {
        _directionsController.animateTo(
          (_indexPosition + 1) * 70,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeIn,
        );

        await Future.delayed(const Duration(milliseconds: 150));

        setState(() {
          _currentAisle = (List.from(_selectedItems)
                ..sort((a, b) => a['aisle'].compareTo(b['aisle'])))[
              _indexPosition]['aisle'];
          _indexPosition++;
        });
      } else {
        showCupertinoDialog(
          context: context,
          useRootNavigator: true,
          barrierDismissible: false,
          builder: (context) => CupertinoAlertDialog(
            title: const Text('Congratulations'),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _controller.jumpToPage(0);
                    _directionsController.jumpTo(0);
                    _visiblePage = 0;
                    _selectedStore = null;
                    _selectedItems = [];
                    _indexPosition = 0;
                    _currentAisle = 0;
                  });
                  _displayLoadup();
                  Navigator.of(context).pop();
                },
                child: const Text('Reset'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isLoading
          ? null
          : AppBar(
              title: Text(_selectedStore == null
                  ? 'Select a Store'
                  : _selectedStore!['name'].toString()),
            ),
      body: _isLoading
          ? Center(
              child: Container(
                height: 60,
                width: 60,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(10)),
                clipBehavior: Clip.hardEdge,
                child: Image.asset('assets/1024.png'),
              ),
            )
          : PageView(
              controller: _controller,
              children: [
                SingleChildScrollView(
                  child: Container(
                    color: Colors.grey.shade50,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: stores
                          .map((store) => StoreTile(
                                store: store,
                                isSelected:
                                    _selectedStore?['name'] == store['name'],
                                handleTap: _handleStoreTap,
                              ))
                          .toList(),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ...items
                          .map(
                            (item) => ItemTile(
                              item: item,
                              handleTap: _handleItemTap,
                              isItemSelected: _isItemSelected,
                            ),
                          )
                          .toList(),
                      const SizedBox(height: 60)
                    ],
                  ),
                ),
                ListView(
                  controller: _directionsController,
                  children: [
                    ...(List.from(_selectedItems)
                          ..sort((a, b) => a['aisle'].compareTo(b['aisle'])))
                        .map(
                          (item) => DirectionTile(
                            item: item,
                            currentAisle: _currentAisle,
                          ),
                        )
                        .toList(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                    )
                  ],
                ),
              ],
              physics: const NeverScrollableScrollPhysics(),
              allowImplicitScrolling: false,
              pageSnapping: true,
              onPageChanged: (val) => setState(() => _visiblePage = val),
            ),
      floatingActionButton: _isLoading
          ? null
          : GestureDetector(
              onTap: _handleButtonTap,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.fromLTRB(
                    12, 12, _visiblePage == 2 ? 12 : 20, 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(30),
                    bottomLeft: const Radius.circular(30),
                    topRight: Radius.circular(_visiblePage == 2 ? 30 : 70),
                    bottomRight: Radius.circular(_visiblePage == 2 ? 30 : 70),
                  ),
                  color: _getButtonColor(),
                ),
                child: Text(
                  _getButtonText(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
    );
  }
}
