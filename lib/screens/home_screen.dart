import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grokart/models/item.dart';
import 'package:grokart/models/store.dart';
import 'package:grokart/screens/items_list.dart';
import 'package:grokart/screens/results_view.dart';
import 'package:grokart/screens/stores_list.dart';
import 'package:grokart/screens/welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;
  final _controller = PageController(initialPage: 0);
  final _directionsController = ScrollController();
  int _visiblePage = 0;
  Store? _selectedStore;
  List<Item> _selectedItems = [];
  int _indexPosition = 0;
  int _currentAisle = 0;

  @override
  void initState() {
    _delayLoading();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    _directionsController.dispose();
    super.dispose();
  }

  void _delayLoading() {
    Future.delayed(const Duration(seconds: 2))
        .then((_) => setState(() => _isLoading = false));
  }

  void _handleItemTap(Item item) {
    if (_selectedItems.any((e) => e.id == item.id)) {
      _selectedItems.removeWhere((e) => e.id == item.id);
    } else {
      _selectedItems.add(item);
    }

    setState(() {});
  }

  void _handleStoreTap(Store store) {
    _selectedStore = store;

    setState(() {});
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
          _currentAisle = (List<Item>.from(_selectedItems)
                ..sort((a, b) => a.aisle.compareTo(b.aisle)))[_indexPosition]
              .aisle;
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
                  _delayLoading();
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
    if (_isLoading) {
      return const WelcomeScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
            _selectedStore == null ? 'Select a Store' : _selectedStore!.name),
      ),
      body: PageView(
        controller: _controller,
        children: [
          StoresList(
            selectedStore: _selectedStore,
            handleStoreTap: _handleStoreTap,
          ),
          ItemsList(
            selectedStore: _selectedStore,
            selectedItems: _selectedItems,
            handleItemTap: _handleItemTap,
          ),
          ResultsView(
            directionsController: _directionsController,
            selectedItems: _selectedItems,
            currentAisle: _currentAisle,
          ),
        ],
        physics: const NeverScrollableScrollPhysics(),
        allowImplicitScrolling: false,
        pageSnapping: true,
        onPageChanged: (val) => setState(() => _visiblePage = val),
      ),
      floatingActionButton: GestureDetector(
        onTap: _handleButtonTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.fromLTRB(12, 12, _visiblePage == 2 ? 12 : 20, 12),
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
