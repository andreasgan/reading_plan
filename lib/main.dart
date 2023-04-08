import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:json_theme/json_theme.dart';
import 'package:reading_plan/bible/api.dart';
import 'package:reading_plan/bible/models/plan.dart';
import 'package:wakelock/wakelock.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;
  runApp(AppRoot(theme: theme));
}

class AppRoot extends StatelessWidget {
  const AppRoot({super.key, required this.theme});

  final ThemeData theme;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme,
      home: const PlanDaySelectionScreen(),
    );
  }
}

class PlanDaySelectionScreen extends HookWidget {
  const PlanDaySelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();

    final day = useState(1);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: PlanDayScreen(plan: '2202', day: day.value)),
            SizedBox(
              height: 300,
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollEndNotification) {
                    final metrics =
                        (scrollNotification.metrics as FixedExtentMetrics);
                    day.value = metrics.itemIndex + 1;
                    return true;
                  } else {
                    return false;
                  }
                },
                child: CupertinoPicker.builder(
                  itemExtent: 30,
                  childCount: 182,
                  onSelectedItemChanged: (index) {},
                  itemBuilder: (context, index) => Center(
                    child: Text('${index + 1}'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PlanDayScreen extends HookWidget {
  const PlanDayScreen({super.key, required this.plan, required this.day});

  final String plan;
  final int day;

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();

    final dayFuture = useMemoized(() => api.fetchPlan(plan, day), [plan, day]);
    final daySnapshot = useFuture(dayFuture);

    return Scaffold(
      appBar: AppBar(title: Text('Leseplan')),
      body: Center(
        child: Builder(builder: (context) {
          if (daySnapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator.adaptive();
          }
          if (daySnapshot.data == null) {
            return const Text('Error');
          }
          final verseSelections = daySnapshot.data!.segments
              .whereType<ReferencePlanSegment>()
              .expand((segment) => segment.verseSelections.expand((vs) => vs));
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Dag ${daySnapshot.data!.day}',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ...verseSelections
                  .map(
                    (vs) => Container(
                      child: Text(
                        vs.toLocalizedString('NB'),
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(height: 1.4),
                      ),
                    ),
                  )
                  .toList()
            ],
          );
        }),
      ),
    );
  }
}
