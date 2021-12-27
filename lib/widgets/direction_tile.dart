import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';

class DirectionTile extends StatelessWidget {
  final Map<String, dynamic> item;
  final int currentAisle;

  const DirectionTile({
    Key? key,
    required this.item,
    required this.currentAisle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final aisle = item['aisle'];

    return Card(
      margin: const EdgeInsets.all(5.0),
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.hardEdge,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 60,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  item['aisle'].toString(),
                  style: const TextStyle(
                    fontSize: 25,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (aisle == currentAisle ? 'Stay in' : 'Go to') +
                          ' Aisle ${item['aisle']}',
                      style: TextStyle(
                        color: Colors.grey.shade900,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      item['name'].toString(),
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                )
              ],
            ),
            CachedNetworkImage(
              imageUrl: item['image'],
              height: 40,
              width: 40,
              fit: BoxFit.contain,
              placeholder: (context, url) => const CircularProgressIndicator(
                strokeWidth: 1,
                color: Colors.grey,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ],
        ),
      ),
    );
  }
}
