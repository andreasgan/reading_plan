import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:json_theme/json_theme.dart';
import 'package:reading_plan/bible/api.dart';
import 'package:reading_plan/bible/models/plan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock/wakelock.dart';

late SharedPreferences sharedPrefs;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  sharedPrefs = await SharedPreferences.getInstance();
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

    final day = useState(sharedPrefs.getInt('last_selected_day') ?? 1);
    const plan = '2202';

    final doneDays = useState<List<String>>(
      sharedPrefs.getStringList('${plan}_days') ?? [],
    );
    useMemoized(
      () => sharedPrefs.setStringList('${plan}_days', doneDays.value),
      [doneDays.value],
    );
    useMemoized(() => null);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: PlanDayScreen(
                plan: plan,
                day: day.value,
                doneDays: doneDays,
              ),
            ),
            SizedBox(
              height: 400,
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollEndNotification) {
                    final metrics =
                        (scrollNotification.metrics as FixedExtentMetrics);
                    sharedPrefs.setInt(
                      'last_selected_day',
                      metrics.itemIndex + 1,
                    );
                    return true;
                  } else {
                    return false;
                  }
                },
                child: CupertinoPicker.builder(
                  scrollController: FixedExtentScrollController(
                    initialItem: day.value - 1,
                  ),
                  itemExtent: 35,
                  childCount: 182,
                  onSelectedItemChanged: (index) {
                    day.value = index + 1;
                  },
                  itemBuilder: (context, index) {
                    final listDay = index + 1;
                    final done = doneDays.value.contains(listDay.toString());
                    return Center(
                      child: SizedBox(
                        width: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 800),
                              curve: Curves.easeOutCirc,
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: done == true
                                    ? Theme.of(context).colorScheme.primary
                                    : null,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 1.5,
                                  strokeAlign: BorderSide.strokeAlignCenter,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text('$listDay'),
                          ],
                        ),
                      ),
                    );
                  },
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
  const PlanDayScreen({
    super.key,
    required this.plan,
    required this.day,
    required this.doneDays,
  });

  final String plan;
  final int day;
  final ValueNotifier<List<String>> doneDays;

  @override
  Widget build(BuildContext context) {
    useListenable(doneDays);
    final dayFuture = useMemoized(() => api.fetchPlan(plan, day), [plan, day]);
    final daySnapshot = useFuture(dayFuture);
    useEffect(() {
      final timer = Timer.periodic(const Duration(seconds: 10), (timer) {
        debugPrint('renewing wakelock');
        Wakelock.enable();
      });
      return timer.cancel;
    }, []);

    return Scaffold(
      appBar: AppBar(title: const Text('Leseplan')),
      body: Center(
        child: Builder(builder: (context) {
          if (daySnapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator.adaptive();
          }
          if (daySnapshot.data == null) {
            return Text('Error: ${daySnapshot.error}');
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
                    (vs) => Text(
                      vs.toLocalizedString('NB'),
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(height: 1.4),
                    ),
                  )
                  .toList(),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Switch(
                  value: doneDays.value.contains(day.toString()),
                  onChanged: (v) {
                    if (v) {
                      doneDays.value = List.from(doneDays.value)
                        ..add(day.toString());
                    } else {
                      doneDays.value = List.from(doneDays.value)
                        ..remove(day.toString());
                    }
                  },
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
