import 'package:flutter/material.dart';

class IOSSearchBar extends StatelessWidget {
  const IOSSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.grey.withOpacity(0.2),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(
            Icons.search,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            'Search',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.mic,
            color: Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
