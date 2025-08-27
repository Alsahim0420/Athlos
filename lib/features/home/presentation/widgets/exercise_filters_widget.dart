import 'package:flutter/material.dart';
import '../../domain/entities/exercise_filters.dart';
import '../../data/models/exercise_filters_model.dart';

class ExerciseFiltersWidget extends StatefulWidget {
  final ExerciseFilters currentFilters;
  final Function(ExerciseFilters) onFiltersChanged;
  final List<String> availableCategories;
  final List<String> availableTargetMuscles;
  final List<String> availableEquipment;
  final List<String> availableDifficulties;
  final List<String> availableBodyParts;
  final int totalExercises;
  final int filteredExercises;

  const ExerciseFiltersWidget({
    super.key,
    required this.currentFilters,
    required this.onFiltersChanged,
    required this.availableCategories,
    required this.availableTargetMuscles,
    required this.availableEquipment,
    required this.availableDifficulties,
    required this.availableBodyParts,
    required this.totalExercises,
    required this.filteredExercises,
  });

  @override
  State<ExerciseFiltersWidget> createState() => _ExerciseFiltersWidgetState();
}

class _ExerciseFiltersWidgetState extends State<ExerciseFiltersWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;
  bool _isExpanded = false;

  late ExerciseFiltersModel _filters;

  @override
  void initState() {
    super.initState();
    _filters = ExerciseFiltersModel(
      category: widget.currentFilters.category,
      targetMuscle: widget.currentFilters.targetMuscle,
      equipment: widget.currentFilters.equipment,
      difficulty: widget.currentFilters.difficulty,
      bodyPart: widget.currentFilters.bodyPart,
    );

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _heightAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    if (_isExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _applyFilters() {
    widget.onFiltersChanged(_filters);
  }

  void _clearFilters() {
    setState(() {
      _filters = const ExerciseFiltersModel();
    });
    widget.onFiltersChanged(_filters);
  }

  void _updateFilter(String type, String? value) {
    setState(() {
      switch (type) {
        case 'category':
          _filters = _filters.copyWith(category: value);
          break;
        case 'targetMuscle':
          _filters = _filters.copyWith(targetMuscle: value);
          break;
        case 'equipment':
          _filters = _filters.copyWith(equipment: value);
          break;
        case 'difficulty':
          _filters = _filters.copyWith(difficulty: value);
          break;
        case 'bodyPart':
          _filters = _filters.copyWith(bodyPart: value);
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with toggle button
          InkWell(
            onTap: _toggleExpanded,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.filter_list,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Filtros',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            if (_filters.hasActiveFilters)
                              Expanded(
                                child: Text(
                                  _filters.toString(),
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${widget.filteredExercises}/${widget.totalExercises}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSecondaryContainer,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: theme.colorScheme.onSurface,
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          AnimatedBuilder(
            animation: _heightAnimation,
            builder: (context, child) {
              return SizeTransition(
                sizeFactor: _heightAnimation,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 400),
                  child: Column(
                    children: [
                      // Scrollable content
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Column(
                            children: [
                              const Divider(height: 1),
                              const SizedBox(height: 16),

                              // Filter options
                              _buildFilterSection(
                                'Categoría',
                                'category',
                                widget.availableCategories,
                                _filters.category,
                              ),
                              const SizedBox(height: 16),

                              _buildFilterSection(
                                'Músculo Objetivo',
                                'targetMuscle',
                                widget.availableTargetMuscles,
                                _filters.targetMuscle,
                              ),
                              const SizedBox(height: 16),

                              _buildFilterSection(
                                'Equipamiento',
                                'equipment',
                                widget.availableEquipment,
                                _filters.equipment,
                              ),
                              const SizedBox(height: 16),

                              _buildFilterSection(
                                'Dificultad',
                                'difficulty',
                                widget.availableDifficulties,
                                _filters.difficulty,
                              ),
                              const SizedBox(height: 16),

                              _buildFilterSection(
                                'Parte del Cuerpo',
                                'bodyPart',
                                widget.availableBodyParts,
                                _filters.bodyPart,
                              ),
                              const SizedBox(height: 24),

                              // Results summary
                              if (_filters.hasActiveFilters)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer
                                        .withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: theme.colorScheme.primary
                                          .withValues(alpha: 0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.search,
                                        color: theme.colorScheme.primary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          'Resultados: ${widget.filteredExercises} de ${widget.totalExercises} ejercicios',
                                          style: theme.textTheme.bodyMedium
                                              ?.copyWith(
                                                color:
                                                    theme.colorScheme.primary,
                                                fontWeight: FontWeight.w500,
                                              ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              // Action buttons
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton.icon(
                                      onPressed: _clearFilters,
                                      icon: const Icon(Icons.clear),
                                      label: const Text('Limpiar'),
                                      style: OutlinedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: _applyFilters,
                                      icon: const Icon(Icons.check),
                                      label: const Text('Aplicar'),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Scroll indicator at bottom
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              theme.colorScheme.surface.withValues(alpha: 0.0),
                              theme.colorScheme.surface.withValues(alpha: 0.8),
                              theme.colorScheme.surface,
                            ],
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: theme.colorScheme.primary,
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Scroll para ver más filtros',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    String title,
    String filterType,
    List<String> options,
    String? selectedValue,
  ) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            // "Todos" option
            FilterChip(
              label: const Text('Todos'),
              selected: selectedValue == null,
              onSelected: (selected) {
                if (selected) {
                  _updateFilter(filterType, null);
                }
              },
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              selectedColor: theme.colorScheme.primaryContainer,
              labelStyle: TextStyle(
                color: selectedValue == null
                    ? theme.colorScheme.onPrimaryContainer
                    : theme.colorScheme.onSurface,
              ),
            ),
            // Individual options
            ...options.map(
              (option) => FilterChip(
                label: Text(option),
                selected: selectedValue == option,
                onSelected: (selected) {
                  _updateFilter(filterType, selected ? option : null);
                },
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                selectedColor: theme.colorScheme.primaryContainer,
                labelStyle: TextStyle(
                  color: selectedValue == option
                      ? theme.colorScheme.onPrimaryContainer
                      : theme.colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
