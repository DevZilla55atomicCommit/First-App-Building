// Home item widget
import 'package:flutter/material.dart';
import '../../domain/entities/home_item.dart';

class HomeItemCard extends StatelessWidget {
  final HomeItem item;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteToggle;
  final VoidCallback? onDelete;

  const HomeItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.onFavoriteToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getIconData(item.iconName),
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            item.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: item.isFavorite ? Colors.red : null,
                            size: 20,
                          ),
                          onPressed: onFavoriteToggle,
                          constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                          padding: EdgeInsets.zero,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Delete button
              if (onDelete != null)
                IconButton(
                  icon: Icon(
                    Icons.delete_outline,
                    color: Theme.of(context).colorScheme.error,
                    size: 20,
                  ),
                  onPressed: onDelete,
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  padding: EdgeInsets.zero,
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'flutter':
        return Icons.flutter_dash;
      case 'architecture':
        return Icons.architecture;
      case 'riverpod':
        return Icons.data_object;
      case 'iphone':
        return Icons.phone_iphone;
      default:
        return Icons.widgets;
    }
  }
}