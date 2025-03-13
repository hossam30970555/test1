import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class IOSSearchBar extends StatefulWidget {
  const IOSSearchBar({super.key});

  @override
  State<IOSSearchBar> createState() => _IOSSearchBarState();
}

class _IOSSearchBarState extends State<IOSSearchBar> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  
  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _pulseAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.02)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.02, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50.0,
      ),
    ]).animate(_pulseController);
    
    // Auto-start the first animation after a delay
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) _pulseController.repeat();
    });
  }
  
  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Trigger an immediate pulse and show "Search not implemented" message
        _pulseController.forward(from: 0);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Search functionality not implemented in this demo'),
            duration: Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.withAlpha(51),
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
                    color: Colors.grey.withAlpha(76),
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
            ),
          );
        },
      ),
    );
  }
}
