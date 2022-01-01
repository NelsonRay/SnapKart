import 'package:flutter/material.dart';
import 'package:grokart/models/item.dart';
import 'package:grokart/widgets/direction_tile.dart';

class ResultsView extends StatefulWidget {
  final ScrollController directionsController;
  final List<Item> selectedItems;
  final int currentAisle;

  const ResultsView({
    Key? key,
    required this.directionsController,
    required this.selectedItems,
    required this.currentAisle,
  }) : super(key: key);

  @override
  _ResultsViewState createState() => _ResultsViewState();
}

class _ResultsViewState extends State<ResultsView> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: widget.directionsController,
      children: [
        ...(List<Item>.from(widget.selectedItems)
              ..sort((a, b) => a.aisle.compareTo(b.aisle)))
            .map(
              (item) => DirectionTile(
                item: item,
                currentAisle: widget.currentAisle,
              ),
            )
            .toList(),
        SizedBox(
          height: MediaQuery.of(context).size.height,
        )
      ],
    );
  }
}
