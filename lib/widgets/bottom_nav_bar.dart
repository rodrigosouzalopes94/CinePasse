

import 'package:flutter/material.dart';
import 'dart:ui'; 
import '../core/constants/colors_constants.dart';


enum TabItem { home, tickets, plans }

class BottomNavBar extends StatelessWidget {
  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  const BottomNavBar({
    super.key,
    required this.currentTab,
    required this.onSelectTab,
  });

  
  IconData _getIcon(TabItem item) {
    switch (item) {
      case TabItem.home:
        return Icons.home_filled;
      case TabItem.tickets:
        return Icons.confirmation_number_outlined;
      case TabItem.plans:
        return Icons.star_border_outlined;
    }
  }

  
  String _getLabel(TabItem item) {
    switch (item) {
      case TabItem.home:
        return 'Início';
      case TabItem.tickets:
        return 'Ingressos';
      case TabItem.plans:
        return 'Planos';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    
    final barColor = Theme.of(context).cardColor.withValues(alpha: 0.9);

    
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 16.0,
          sigmaY: 16.0,
        ), 
        child: BottomAppBar(
          surfaceTintColor: Colors.transparent, 
          color: barColor,
          
          shape:
              const CircularNotchedRectangle(), 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: TabItem.values.map((item) {
              final isSelected = item == currentTab;
              return Expanded(
                child: InkWell(
                  onTap: () => onSelectTab(item),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _getIcon(item),
                          size: 24,
                          
                          color: isSelected
                              ? kPrimaryColor
                              : (isDarkMode
                                    ? Colors.grey[600]
                                    : Colors.grey[700]),
                        ),
                        Text(
                          _getLabel(item),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? kPrimaryColor
                                : (isDarkMode
                                      ? Colors.grey[500]
                                      : Colors.grey[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
