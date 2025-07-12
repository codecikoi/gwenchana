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
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _isLoading = false;

  @override
  void dispose() {
    _koreanController.dispose();
    _translationController.dispose();
    super.dispose();
  }

  Future<void> _addCard() async {
    setState(() {
      _autovalidateMode = AutovalidateMode.onUserInteraction;
    });

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
          showDialog(
            context: context,
            barrierDismissible: false,
            barrierColor: Colors.black26,
            builder: (context) => Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.done,
                  color: Colors.green,
                  size: 40,
                ),
              ),
            ),
          );
          Future.delayed(Duration(milliseconds: 300), () {
            if (mounted) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            }
          });
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
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
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
                  return AppLocalizations.of(context)!.koreanWord;
                }

                return ValidationHelper.getKoreanError(
                  value.trim(),
                  context,
                );
              },
              textInputAction: TextInputAction.next,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _translationController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.translation,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.translate),
                enabled: !_isLoading,
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return AppLocalizations.of(context)!.translationEmpty;
                }
                return ValidationHelper.getTranslationError(
                  value.trim(),
                  context,
                );
              },
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => !_isLoading ? _addCard() : null,
              enabled: !_isLoading,
            )
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: Text(
            AppLocalizations.of(context)!.cancel,
          ),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _addCard,
          child: _isLoading
              ? SizedBox(child: CircularProgressIndicator(strokeWidth: 2))
              : Text(
                  AppLocalizations.of(context)!.add,
                ),
        ),
      ],
    );
  }
}
