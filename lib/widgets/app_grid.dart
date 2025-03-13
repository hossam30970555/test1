import 'package:flutter/material.dart';
import '../models/app_model.dart';
import 'app_icon.dart';

class AppGrid extends StatelessWidget {
  final int pageIndex;
  final bool isEditMode;
  
  const AppGrid({
    super.key, 
    required this.pageIndex,
    this.isEditMode = false,
  });

  @override
  Widget build(BuildContext context) {
    List<AppModel> apps = pageIndex < allApps.length 
        ? allApps[pageIndex]
        : [];
    
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 16.0,
        crossAxisSpacing: 16.0,
        childAspectRatio: 0.75,
      ),
      itemCount: apps.length,
      itemBuilder: (context, index) {
        return AppIcon(
          app: apps[index],
          isEditMode: isEditMode,
        );
      },
    );
  }
}
