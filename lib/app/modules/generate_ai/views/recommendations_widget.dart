import 'package:flutter/material.dart';
import '../../../services/ai_service.dart';

/// Drop this widget anywhere in the dashboard to show "Recommended for You"
class RecommendationsWidget extends StatefulWidget {
  const RecommendationsWidget({super.key});

  @override
  State<RecommendationsWidget> createState() => _RecommendationsWidgetState();
}

class _RecommendationsWidgetState extends State<RecommendationsWidget> {
  late Future<List<MealRecommendation>> _future;

  @override
  void initState() {
    super.initState();
    _future = AiService.instance.getRecommendations();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MealRecommendation>>(
      future: _future,
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const _SectionShimmer();
        }
        if (snap.hasError || !snap.hasData || snap.data!.isEmpty) {
          return const SizedBox.shrink(); // hide if no data
        }

        final recs = snap.data!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Recommended for You',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 110,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: recs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, i) => _RecommendationCard(rec: recs[i]),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final MealRecommendation rec;
  const _RecommendationCard({required this.rec});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            rec.mealType.isEmpty ? 'Meal' : rec.mealType,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            rec.description,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _SectionShimmer extends StatelessWidget {
  const _SectionShimmer();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(
          3,
          (_) => Container(
            width: 160,
            height: 110,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
