import 'package:flutter/material.dart';

class ExercisesSkeleton extends StatelessWidget {
  // Helper method to get skeleton color with better contrast
  Color _getSkeletonColor(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    if (brightness == Brightness.light) {
      // For light theme, use a darker color for better contrast
      return Colors.grey.shade300;
    } else {
      // For dark theme, use a lighter color for better contrast
      return Colors.grey.shade600;
    }
  }

  final int itemCount;

  const ExercisesSkeleton({super.key, this.itemCount = 10});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return _buildExerciseSkeletonItem(context);
      },
    );
  }

  Widget _buildExerciseSkeletonItem(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getSkeletonColor(context).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Exercise image skeleton (GIF placeholder)
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: _getSkeletonColor(context),
              borderRadius: BorderRadius.circular(8),
            ),
          ),

          const SizedBox(width: 16),

          // Exercise details skeleton
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Exercise name skeleton
                Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                    color: _getSkeletonColor(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 8),

                // Body part skeleton
                Container(
                  width: 120,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getSkeletonColor(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                const SizedBox(height: 8),

                // Target muscle skeleton
                Container(
                  width: 100,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getSkeletonColor(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                const SizedBox(height: 8),

                // Equipment skeleton
                Container(
                  width: 80,
                  height: 16,
                  decoration: BoxDecoration(
                    color: _getSkeletonColor(context),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Arrow icon skeleton
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _getSkeletonColor(context),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ],
      ),
    );
  }
}

// Alternative skeleton for grid layout
class ExercisesGridSkeleton extends StatelessWidget {
  final int itemCount;

  const ExercisesGridSkeleton({super.key, this.itemCount = 12});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return _buildExerciseCardSkeleton(context);
      },
    );
  }

  Widget _buildExerciseCardSkeleton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise image skeleton
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
          ),

          // Exercise details skeleton
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Exercise name skeleton
                  Container(
                    width: double.infinity,
                    height: 16,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Body part skeleton
                  Container(
                    width: 80,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Target muscle skeleton
                  Container(
                    width: 60,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Theme.of(
                        context,
                      ).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
