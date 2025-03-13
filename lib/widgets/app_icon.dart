import 'package:flutter/material.dart';
import '../models/app_model.dart';

class AppIcon extends StatefulWidget {
  final AppModel app;
  final bool isDock;
  final bool isEditMode;
  
  const AppIcon({
    super.key, 
    required this.app, 
    this.isDock = false,
    this.isEditMode = false,
  });

  @override
  State<AppIcon> createState() => _AppIconState();
}

class _AppIconState extends State<AppIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _wiggleAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _wiggleAnimation = Tween<double>(begin: -0.05, end: 0.05)
        .animate(CurvedAnimation(
          parent: _controller, 
          curve: Curves.easeInOut
        ));
    
    if (widget.isEditMode && !widget.isDock) {
      _controller.repeat(reverse: true);
    }
  }
  
  @override
  void didUpdateWidget(AppIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isEditMode != oldWidget.isEditMode) {
      if (widget.isEditMode && !widget.isDock) {
        _controller.repeat(reverse: true);
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isEditMode && !widget.isDock) {
      return _buildEditableIcon();
    } else {
      return _buildNormalIcon();
    }
  }

  Widget _buildEditableIcon() {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.rotate(
              angle: _wiggleAnimation.value,
              child: _buildIconContent(),
            );
          },
        ),
        Positioned(
          top: 0,
          left: 4,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.black38,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNormalIcon() {
    return GestureDetector(
      onTap: () {
        if (widget.isEditMode) return;
        
        if (widget.app.onTap != null) {
          widget.app.onTap!();
        } else if (widget.app.screen != null) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => widget.app.screen!),
          );
        } else {
          showDialog(
            context: context,
            barrierColor: Colors.transparent,
            builder: (context) => _AppOpeningAnimation(app: widget.app),
          );
        }
      },
      child: _buildIconContent(),
    );
  }
  
  Widget _buildIconContent() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          children: [
            Container(
              width: widget.isDock ? 60.0 : 65.0,
              height: widget.isDock ? 60.0 : 65.0,
              decoration: BoxDecoration(
                color: widget.app.color,
                borderRadius: BorderRadius.circular(16.0),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.app.color.withOpacity(0.9),
                    widget.app.color,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 0,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Icon(
                widget.app.icon,
                color: Colors.white,
                size: widget.isDock ? 28 : 32,
              ),
            ),
            if (widget.app.badge != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Center(
                    child: Text(
                      widget.app.badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (!widget.isDock)
          const SizedBox(height: 6),
        if (!widget.isDock)
          Text(
            widget.app.name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
              shadows: [
                Shadow(
                  blurRadius: 4.0,
                  color: Colors.black.withOpacity(0.3),
                  offset: const Offset(1.0, 1.0),
                ),
              ],
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
      ],
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
