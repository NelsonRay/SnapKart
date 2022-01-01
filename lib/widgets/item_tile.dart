import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:grokart/models/item.dart';
import 'dart:math';

class ItemTile extends StatelessWidget {
  final Item item;
  final void Function(Item item) handleTap;
  final bool isItemSelected;

  const ItemTile({
    Key? key,
    required this.item,
    required this.handleTap,
    required this.isItemSelected,
  }) : super(key: key);

  void _handleTap() async {
    handleTap(item);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      behavior: HitTestBehavior.translucent,
      child: Card(
        margin: const EdgeInsets.all(5.0),
        elevation: 0.5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.hardEdge,
        child: Container(
          padding: const EdgeInsets.fromLTRB(8.0, 8.0, 10.0, 8.0),
          color: isItemSelected ? Colors.green.shade50 : null,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: item.photoUrl,
                    height: 40,
                    width: 40,
                    fit: BoxFit.contain,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(
                      strokeWidth: 1,
                      color: Colors.grey,
                    ),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 15),
                      Text(
                        item.name,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade900,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            (Random().nextDouble() * 5).toStringAsFixed(1),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          const Icon(
                            Icons.star_rounded,
                            color: Colors.yellow,
                            size: 15,
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Aisle: ${item.aisle}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Container(
                    height: 25,
                    width: 25,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isItemSelected ? Colors.green : null,
                      border: Border.all(
                        color: Colors.green,
                      ),
                    ),
                    child: isItemSelected
                        ? const Icon(
                            Icons.check_rounded,
                            size: 17,
                            color: Colors.white,
                          )
                        : null,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
