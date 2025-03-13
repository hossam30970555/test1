import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class IOSSearchBar extends StatelessWidget {
  const IOSSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.withOpacity(0.2),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Icon(
            CupertinoIcons.search,
            color: Colors.grey[600],
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            'Search',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const Spacer(),
          Container(
            width: 1,
            height: 20,
            color: Colors.grey.withOpacity(0.3),
            margin: const EdgeInsets.symmetric(horizontal: 6),
          ),
          Icon(
            CupertinoIcons.mic_fill,
            color: Colors.grey[600],
            size: 18,
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
