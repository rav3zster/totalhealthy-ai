import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/ai_service.dart';

const _lime = Color(0xFFC2D86A);
const _bg = Color(0xFF0A0A0A);
const _card = Color(0xFF141414);
const _inp = Color(0xFF1A1A1A);
const _bdr = Color(0xFF2A2A2A);

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
  bool _loading = false;

  final List<String> _goals = ['weight_loss', 'maintenance', 'muscle_gain'];
  final List<String> _activityLabels = [
    'Sedentary',
    'Light',
    'Moderate',
    'Active',
    'Very Active',
  ];
  final List<IconData> _activityIcons = [
    Icons.airline_seat_recline_normal_rounded,
    Icons.directions_walk_rounded,
    Icons.directions_bike_rounded,
    Icons.fitness_center_rounded,
    Icons.bolt_rounded,
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
    setState(() => _loading = true);
    try {
      final result = await AiService.instance.classifyDiet(
        age: int.parse(_ageCtrl.text),
        weight: double.parse(_weightCtrl.text),
        height: double.parse(_heightCtrl.text),
        activityLevel: _activityLevel,
        goal: _goal,
      );
      if (!mounted) return;
      setState(() => _loading = false);
      if (result == null) {
        Get.snackbar(
          'Unavailable',
          'Could not analyse diet. Try again.',
          backgroundColor: Colors.red.shade900,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) => _ResultSheet(result: result),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red.shade900,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.back(),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 17,
            ),
          ),
        ),
        title: const Text(
          'AI Diet Analyser',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 70,
          left: 16,
          right: 16,
          bottom: 32,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildBadge(),
              const SizedBox(height: 24),
              _buildMetricsCard(),
              _buildActivityCard(),
              _buildGoalCard(),
              const SizedBox(height: 8),
              _buildAnalyseButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: _lime.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _lime.withValues(alpha: 0.3)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.analytics_rounded, color: _lime, size: 15),
            SizedBox(width: 6),
            Text(
              'Get your BMI, TDEE & diet recommendation',
              style: TextStyle(
                color: _lime,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsCard() {
    return _sectionCard(
      icon: Icons.person_rounded,
      title: 'Body Metrics',
      child: Row(
        children: [
          Expanded(child: _field(_ageCtrl, 'Age', 'yrs')),
          const SizedBox(width: 10),
          Expanded(child: _field(_weightCtrl, 'Weight', 'kg')),
          const SizedBox(width: 10),
          Expanded(child: _field(_heightCtrl, 'Height', 'cm')),
        ],
      ),
    );
  }

  Widget _buildActivityCard() {
    return _sectionCard(
      icon: Icons.directions_run_rounded,
      title: 'Activity Level',
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (i) {
              final on = _activityLevel == i + 1;
              return GestureDetector(
                onTap: () => setState(() => _activityLevel = i + 1),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: on ? _lime.withValues(alpha: 0.15) : _inp,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: on ? _lime.withValues(alpha: 0.5) : _bdr,
                      width: on ? 1.5 : 1,
                    ),
                  ),
                  child: Icon(
                    _activityIcons[i],
                    color: on ? _lime : Colors.white38,
                    size: 22,
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 10),
          Text(
            _activityLabels[_activityLevel - 1],
            style: const TextStyle(
              color: _lime,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoalCard() {
    return _sectionCard(
      icon: Icons.flag_rounded,
      title: 'Goal',
      child: Wrap(
        spacing: 8,
        children: _goals.map((g) {
          final on = _goal == g;
          return GestureDetector(
            onTap: () => setState(() => _goal = g),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: on ? _lime.withValues(alpha: 0.15) : _inp,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: on ? _lime.withValues(alpha: 0.5) : _bdr,
                  width: on ? 1.5 : 1,
                ),
              ),
              child: Text(
                g.replaceAll('_', ' ').toUpperCase(),
                style: TextStyle(
                  color: on ? _lime : Colors.white54,
                  fontSize: 13,
                  fontWeight: on ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAnalyseButton() {
    return GestureDetector(
      onTap: _loading ? null : _classify,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 54,
        decoration: BoxDecoration(
          gradient: _loading
              ? null
              : const LinearGradient(
                  colors: [Color(0xFFD4EF7A), _lime],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
          color: _loading ? _lime.withValues(alpha: 0.3) : null,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _loading
              ? null
              : [
                  BoxShadow(
                    color: _lime.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Center(
          child: _loading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.black,
                  ),
                )
              : const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.biotech_rounded, color: Colors.black, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Analyse My Diet',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _bdr),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: _lime.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Icon(icon, color: _lime, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Divider(color: Colors.white.withValues(alpha: 0.06), height: 20),
          child,
        ],
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label, String suffix) {
    return TextFormField(
      controller: ctrl,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.5),
          fontSize: 13,
        ),
        suffixText: suffix,
        suffixStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.4),
          fontSize: 12,
        ),
        filled: true,
        fillColor: _inp,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _bdr),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _bdr),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: _lime.withValues(alpha: 0.6),
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
    );
  }
}

// ── Result bottom sheet ───────────────────────────────────────────────────────

class _ResultSheet extends StatelessWidget {
  final DietClassification result;
  const _ResultSheet({required this.result});

  String get _bmiCategory {
    final b = result.bmi;
    if (b < 18.5) return 'Underweight';
    if (b < 25) return 'Normal';
    if (b < 30) return 'Overweight';
    return 'Obese';
  }

  Color get _bmiColor {
    final b = result.bmi;
    if (b < 18.5) return Colors.blue;
    if (b < 25) return _lime;
    if (b < 30) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final dietLabel = result.dietType.replaceAll('_', ' ').toUpperCase();
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        12,
        20,
        MediaQuery.of(context).padding.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _lime.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: _lime,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Analysis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'AI-powered diet profile',
                    style: TextStyle(color: Colors.white38, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _bmiColor.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _bmiColor.withValues(alpha: 0.25)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Body Mass Index',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          result.bmi.toStringAsFixed(1),
                          style: TextStyle(
                            color: _bmiColor,
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6, left: 4),
                          child: Text(
                            'BMI',
                            style: TextStyle(
                              color: _bmiColor.withValues(alpha: 0.6),
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _bmiColor.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _bmiCategory,
                    style: TextStyle(
                      color: _bmiColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _StatTile(
                  label: 'Daily Energy (TDEE)',
                  value: result.tdee.toStringAsFixed(0),
                  unit: 'kcal',
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatTile(
                  label: 'Recommended Intake',
                  value: '${result.recommendedCalories}',
                  unit: 'kcal/day',
                  color: _lime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.purple.withValues(alpha: 0.15),
                  Colors.purple.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.restaurant_rounded,
                    color: Colors.purpleAccent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recommended Diet',
                      style: TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dietLabel,
                      style: const TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: _lime,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Got it',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stat tile ─────────────────────────────────────────────────────────────────

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;
  const _StatTile({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white54, fontSize: 11),
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: color,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                TextSpan(
                  text: ' $unit',
                  style: TextStyle(
                    color: color.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
