import 'package:flutter/material.dart';
import '../models/app_model.dart';

class AppIcon extends StatelessWidget {
  final AppModel app;
  final bool isDock;
  
  const AppIcon({
    super.key, 
    required this.app, 
    this.isDock = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (app.onTap != null) {
          app.onTap!();
        } else {
          // Show app opening animation
          showDialog(
            context: context,
            barrierColor: Colors.transparent,
            builder: (context) => _AppOpeningAnimation(app: app),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: isDock ? 60.0 : 65.0,
            height: isDock ? 60.0 : 65.0,
            decoration: BoxDecoration(
              color: app.color,
              borderRadius: BorderRadius.circular(13.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Icon(
              app.icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          if (!isDock)
            const SizedBox(height: 6),
          if (!isDock)
            Text(
              app.name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}

class _AppOpeningAnimation extends StatefulWidget {
  final AppModel app;
  
  const _AppOpeningAnimation({required this.app});

  @override
  _AppOpeningAnimationState createState() => _AppOpeningAnimationState();
}

class _AppOpeningAnimationState extends State<_AppOpeningAnimation> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.1, end: 20.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    
    _controller.forward().then((_) {
      Navigator.of(context).pop();
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: widget.app.color,
                borderRadius: BorderRadius.circular(13.0),
              ),
              child: Icon(widget.app.icon, color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
