import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:gwenchana/core/localization/app_localization.dart';
import 'package:gwenchana/presentation/widgets/basic_appbutton.dart';

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
                onPressed: () => context.go('/reading-page'),
                title: AppLocale.reading.getString(context).toUpperCase(),
              ),
              const SizedBox(height: 10),
              BasicAppButton(
                onPressed: () => context.go('/vocabulary-page'),
                title: AppLocale.vocabulary.getString(context).toUpperCase(),
              ),
              const SizedBox(height: 10),
              BasicAppButton(
                onPressed: () => context.go('/speaking-page'),
                title: AppLocale.speaking.getString(context).toUpperCase(),
              ),
              const SizedBox(height: 10),
              BasicAppButton(
                onPressed: () => context.go('/writing-page'),
                title: AppLocale.writing.getString(context).toUpperCase(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
