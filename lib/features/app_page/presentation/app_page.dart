import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:gwenchana/features/localization/presentation/pages/app_localization.dart';
import 'package:gwenchana/core/helper/basic_appbutton.dart';

@RoutePage()
class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 120),
          child: Column(
            children: [
              BasicAppButton(
                onPressed: () => context.router.pushPath('/reading-page'),
                title: AppLocale.reading.getString(context).toUpperCase(),
              ),
              const SizedBox(height: 10),
              BasicAppButton(
                onPressed: () => context.router.pushPath('/vocabulary-page'),
                title: AppLocale.vocabulary.getString(context).toUpperCase(),
              ),
              const SizedBox(height: 10),
              BasicAppButton(
                onPressed: () => context.router.pushPath('/speaking-page'),
                title: AppLocale.speaking.getString(context).toUpperCase(),
              ),
              const SizedBox(height: 10),
              BasicAppButton(
                onPressed: () => context.router.pushPath('/writing-page'),
                title: AppLocale.writing.getString(context).toUpperCase(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
