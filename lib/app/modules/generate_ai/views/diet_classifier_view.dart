import 'package:flutter/material.dart';
import '../../../services/ai_service.dart';

/// Screen where user inputs their profile and gets a diet classification
class DietClassifierView extends StatefulWidget {
  const DietClassifierView({super.key});

  @override
  State<DietClassifierView> createState() => _DietClassifierViewState();
}

class _DietClassifierViewState extends State<DietClassifierView> {
  final _formKey = GlobalKey<FormState>();

  final _ageCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();

  int _activityLevel = 2;
  String _goal = 'weight_loss';

  DietClassification? _result;
  bool _loading = false;

  final _goals = ['weight_loss', 'maintenance', 'muscle_gain'];
  final _activityLabels = [
    'Sedentary',
    'Light',
    'Moderate',
    'Active',
    'Very Active',
  ];

  @override
  void dispose() {
    _ageCtrl.dispose();
    _weightCtrl.dispose();
    _heightCtrl.dispose();
    super.dispose();
  }

  Future<void> _classify() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _result = null;
    });

    try {
      final result = await AiService.instance.classifyDiet(
        age: int.parse(_ageCtrl.text),
        weight: double.parse(_weightCtrl.text),
        height: double.parse(_heightCtrl.text),
        activityLevel: _activityLevel,
        goal: _goal,
      );
      if (mounted) {
        setState(() {
          _result = result;
          _loading = false;
        });
        if (result == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Diet classifier not available yet')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Diet Classifier')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Inputs ──────────────────────────────────────────────────
              _buildField(_ageCtrl, 'Age', 'years'),
              _buildField(_weightCtrl, 'Weight', 'kg'),
              _buildField(_heightCtrl, 'Height', 'cm'),

              const SizedBox(height: 12),
              Text(
                'Activity Level',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Slider(
                value: _activityLevel.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                label: _activityLabels[_activityLevel - 1],
                onChanged: (v) => setState(() => _activityLevel = v.toInt()),
              ),
              Text(
                _activityLabels[_activityLevel - 1],
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall,
              ),

              const SizedBox(height: 12),
              Text('Goal', style: Theme.of(context).textTheme.labelLarge),
              DropdownButtonFormField<String>(
                value: _goal,
                items: _goals
                    .map(
                      (g) => DropdownMenuItem(
                        value: g,
                        child: Text(g.replaceAll('_', ' ').toUpperCase()),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _goal = v!),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _loading ? null : _classify,
                child: _loading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Analyse My Diet'),
              ),

              // ── Result ──────────────────────────────────────────────────
              if (_result != null) ...[
                const SizedBox(height: 24),
                _ResultCard(result: _result!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController ctrl, String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: ctrl,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          suffixText: hint,
          border: const OutlineInputBorder(),
        ),
        validator: (v) => (v == null || v.isEmpty) ? 'Enter $label' : null,
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final DietClassification result;
  const _ResultCard({required this.result});

  @override
  Widget build(BuildContext context) {
    final dietLabel = result.dietType.replaceAll('_', ' ').toUpperCase();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Diet Plan',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(),
            _Row('Diet Type', dietLabel),
            _Row('BMI', result.bmi.toStringAsFixed(1)),
            _Row(
              'Daily Energy (TDEE)',
              '${result.tdee.toStringAsFixed(0)} kcal',
            ),
            _Row(
              'Recommended Calories',
              '${result.recommendedCalories} kcal/day',
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
