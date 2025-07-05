import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gwenchana/core/helper/validation_helper.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_bloc.dart';
import 'package:gwenchana/features/vocabulary/presentation/bloc/vocabulary_event.dart';
import 'package:gwenchana/features/vocabulary/presentation/widgets/word_card_model.dart';
import 'package:gwenchana/gen_l10n/app_localizations.dart';

class AddCardDialog extends StatefulWidget {
  final VocabularyBloc bloc;

  const AddCardDialog({
    super.key,
    required this.bloc,
  });

  @override
  State<AddCardDialog> createState() => _AddCardDialogState();
}

class _AddCardDialogState extends State<AddCardDialog> {
  final _formKey = GlobalKey<FormState>();
  final _koreanController = TextEditingController();
  final _translationController = TextEditingController();

  @override
  void dispose() {
    _koreanController.dispose();
    _translationController.dispose();
    super.dispose();
  }

  void _addCard() {
    if (_formKey.currentState!.validate()) {
      final card = MyCard(
        korean: _koreanController.text.trim(),
        translation: _translationController.text.trim(),
      );
      widget.bloc.add(AddCardEvent(card));
      Navigator.of(context).context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context)!.addCard,
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _koreanController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.koreanWord,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.language),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return ValidationHelper.getKoreanError(
                    _koreanController.text,
                    context,
                  );
                }
                return null;
              },
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _translationController,
              decoration: InputDecoration(
                labelText: 'Translate',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.translate),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'please write translate';
                }
                return null;
              },
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _addCard(),
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _addCard,
          child: Text('add'),
        ),
      ],
    );
  }
}
