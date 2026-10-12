// Home screen/view
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../shared/widgets/app_widgets.dart';
import '../viewmodels/home_viewmodel.dart';
import '../widgets/home_item_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeState = ref.watch(homeViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('First App Building'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddItemDialog(context, ref),
            tooltip: 'Add Item',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(homeViewModelProvider.notifier).refresh(),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: homeState.when(
        data: (items) {
          if (items.isEmpty) {
            return AppEmptyState(
              icon: Icons.inbox_outlined,
              title: 'No items yet',
              message: 'Tap the + button to add your first item',
              action: FilledButton.icon(
                onPressed: () => _showAddItemDialog(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
              ),
            );
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(homeViewModelProvider.notifier).refresh(),
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return HomeItemCard(
                  item: item,
                  onTap: () => _showItemDetail(context, item),
                  onFavoriteToggle: () => ref.read(homeViewModelProvider.notifier).toggleFavorite(item.id),
                  onDelete: () => _showDeleteConfirmation(context, ref, item),
                );
              },
            ),
          );
        },
        loading: () => const Center(child: AppLoadingIndicator(size: 32)),
        error: (error, stack) => AppErrorWidget(
          message: error.toString(),
          onRetry: () => ref.read(homeViewModelProvider.notifier).refresh(),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddItemDialog(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedIcon = 'flutter';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add New Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    hintText: 'Enter item title',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    hintText: 'Enter item description',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedIcon,
                  decoration: const InputDecoration(labelText: 'Icon'),
                  items: const [
                    DropdownMenuItem(value: 'flutter', child: Text('Flutter')),
                    DropdownMenuItem(value: 'architecture', child: Text('Architecture')),
                    DropdownMenuItem(value: 'riverpod', child: Text('Riverpod')),
                    DropdownMenuItem(value: 'iphone', child: Text('iPhone')),
                  ],
                  onChanged: (value) => setState(() => selectedIcon = value!),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (titleController.text.trim().isEmpty) return;
                
                final newItem = HomeItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  iconName: selectedIcon,
                  createdAt: DateTime.now(),
                );
                
                ref.read(homeViewModelProvider.notifier).addItem(newItem);
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _showItemDetail(BuildContext context, HomeItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      _getIconData(item.iconName),
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      size: 30,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.title, style: Theme.of(context).textTheme.headlineSmall),
                        const SizedBox(height: 4),
                        Text('Created: ${_formatDate(item.createdAt)}', 
                          style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                  Icon(
                    item.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: item.isFavorite ? Colors.red : null,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(item.description, style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, HomeItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item?'),
        content: Text('Are you sure you want to delete "${item.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () {
              ref.read(homeViewModelProvider.notifier).deleteItem(item.id);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}