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
  bool _isLoading = false;

  @override
  void dispose() {
    _koreanController.dispose();
    _translationController.dispose();
    super.dispose();
  }

  Future<void> _addCard() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        final card = MyCard(
          korean: _koreanController.text.trim(),
          translation: _translationController.text.trim(),
        );
        widget.bloc.add(AddCardEvent(card));
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('card added successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('error adding $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
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
                enabled: !_isLoading,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'please write translate';
                }
                return null;
              },
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => !_isLoading ? _addCard() : null,
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _addCard,
          child: _isLoading
              ? SizedBox(child: CircularProgressIndicator(strokeWidth: 2))
              : Text('add'),
        ),
      ],
    );
  }
}
