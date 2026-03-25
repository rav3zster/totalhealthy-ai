import 'package:flutter/material.dart';
import '../../../services/ai_service.dart';

/// Attach this below any meal description TextField.
/// It auto-fills nutrition when the user stops typing.
class NutritionAutofillWidget extends StatefulWidget {
  final TextEditingController descriptionController;
  final void Function(NutritionResult result)? onNutritionFilled;

  const NutritionAutofillWidget({
    super.key,
    required this.descriptionController,
    this.onNutritionFilled,
  });

  @override
  State<NutritionAutofillWidget> createState() =>
      _NutritionAutofillWidgetState();
}

class _NutritionAutofillWidgetState extends State<NutritionAutofillWidget> {
  NutritionResult? _result;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    widget.descriptionController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.descriptionController.removeListener(_onTextChanged);
    super.dispose();
  }

  // Debounce: only call API after user pauses typing for 800ms
  DateTime _lastChange = DateTime.now();

  void _onTextChanged() {
    _lastChange = DateTime.now();
    final text = widget.descriptionController.text.trim();
    if (text.length < 5) {
      setState(() {
        _result = null;
        _error = null;
      });
      return;
    }

    Future.delayed(const Duration(milliseconds: 800), () {
      if (DateTime.now().difference(_lastChange).inMilliseconds >= 800) {
        _predict(text);
      }
    });
  }

  Future<void> _predict(String text) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final result = await AiService.instance.predictNutrition(text);
      if (mounted) {
        setState(() {
          _result = result;
          _loading = false;
        });
        if (result != null) widget.onNutritionFilled?.call(result);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Could not estimate nutrition';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: LinearProgressIndicator(),
      );
    }

    if (_error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          _error!,
          style: const TextStyle(color: Colors.red, fontSize: 12),
        ),
      );
    }

    if (_result == null) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Estimated Nutrition',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NutrientChip(
                label: 'Calories',
                value: '${_result!.calories} kcal',
              ),
              _NutrientChip(label: 'Protein', value: '${_result!.protein}g'),
              _NutrientChip(label: 'Carbs', value: '${_result!.carbs}g'),
              _NutrientChip(label: 'Fat', value: '${_result!.fat}g'),
            ],
          ),
        ],
      ),
    );
  }
}

class _NutrientChip extends StatelessWidget {
  final String label;
  final String value;
  const _NutrientChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: Colors.grey),
        ),
      ],
    );
  }
}
