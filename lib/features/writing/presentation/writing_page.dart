import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gwenchana/core/helper/basic_appbar.dart';
import 'package:gwenchana/gen_l10n/app_localizations.dart';

@RoutePage()
class WritingPage extends StatelessWidget {
  const WritingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        title: Text(AppLocalizations.of(context)!.writing),
      ),
      body: Center(
        child: Text('soon writing page'),
      ),
    );
  }
}
