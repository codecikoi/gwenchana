import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gwenchana/core/helper/basic_appbutton.dart';
import 'package:gwenchana/gen_l10n/app_localizations.dart';

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
                title: AppLocalizations.of(context)!.reading.toUpperCase(),
              ),
              const SizedBox(height: 10),
              BasicAppButton(
                onPressed: () => context.router.pushPath('/vocabulary-page'),
                title: AppLocalizations.of(context)!.vocabulary.toUpperCase(),
              ),
              const SizedBox(height: 10),
              BasicAppButton(
                onPressed: () => context.router.pushPath('/speaking-page'),
                title: AppLocalizations.of(context)!.speaking.toUpperCase(),
              ),
              const SizedBox(height: 10),
              BasicAppButton(
                onPressed: () => context.router.pushPath('/writing-page'),
                title: AppLocalizations.of(context)!.writing.toUpperCase(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
