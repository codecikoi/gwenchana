import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gwenchana/gen_l10n/app_localizations.dart';

class KoreanTextInputFormatter extends TextInputFormatter {
  static final _koreanRegExp =
      RegExp(r'[\uac00-\ud7af\u1100-\u11ff\u3130-\u318f\s?!\-,.]+');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final filtered =
        _koreanRegExp.allMatches(newValue.text).map((m) => m.group(0)).join();
    return TextEditingValue(
      text: filtered,
      selection: TextSelection.collapsed(offset: filtered.length),
    );
  }
}

class ValidationHelper {
  // маил валидация

  static bool isValidEmail(String email) {
    if (email.isEmpty) return false;
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(
      email.trim(),
    );
  }

  // валидация пароль
  static bool isValidPassword(String password) {
    return password.trim().length >= 6;
  }

  // валидация имени
  static bool isValidName(String name) {
    return name.trim().length >= 2 &&
        RegExp(r'^[a-zA-Z\s]+$').hasMatch(name.trim());
  }

  // валидация корейского языка (добавление карточки)
  static bool isValidKorean(String koreanText) {
    final trimmed = koreanText.trim();
    if (trimmed.isEmpty) return false;
    if (trimmed.replaceAll(' ', ' ').isEmpty) return false;
    if (trimmed.contains(RegExp(r'\s{2,}'))) return false;

    final hasKoreanChars =
        RegExp(r'[\uac00-\ud7af\u1100-\u11ff\u3130-\u318f]').hasMatch(trimmed);
    if (!hasKoreanChars) return false;

    return RegExp(r'^[\uac00-\ud7af\u1100-\u11ff\u3130-\u318f\s?!\-,.]+$')
        .hasMatch(trimmed);
  }

  static bool isValidTranslation(String translationText) {
    final trimmed = translationText.trim();
    if (trimmed.isEmpty) return false;
    if (trimmed.replaceAll(' ', ' ').isEmpty) return false;
    if (trimmed.contains(RegExp(r'\s{2,}'))) return false;
    return RegExp(r'^[\p{L}\s?!\-,.]+$', unicode: true).hasMatch(trimmed);
  }

  static bool isValidEnglish(String englishText) {
    final trimmed = englishText.trim();
    if (trimmed.isEmpty) return false;
    if (trimmed.replaceAll(' ', ' ').isEmpty) return false;
    if (trimmed.contains(RegExp(r'\s{2,}'))) return false;

    return RegExp(r'^[a-zA-Z\s?!\-,.]+$').hasMatch(trimmed);
  }

  // проверка на совпадение паролей
  static bool passwordsMatch(String password, String confirPassword) {
    return password == confirPassword;
  }

  // getting error messages

  static String? getEmailError(String email, BuildContext context) {
    if (email.isEmpty) {
      return _getLocalizedMessage('emailEmpty', context);
    }
    if (!isValidEmail(email)) {
      return _getLocalizedMessage('emailInvalid', context);
    }
    return null;
  }

  static String? getPasswordError(String password, BuildContext context) {
    if (password.isEmpty) {
      return _getLocalizedMessage('passwordEmpty', context);
    }
    if (!isValidPassword(password)) {
      return _getLocalizedMessage('passwordInvalid', context);
    }
    return null;
  }

  static String? getNameError(String name, BuildContext context) {
    if (name.isEmpty) {
      return _getLocalizedMessage('nameEmpty', context);
    }
    if (!isValidName(name)) {
      return _getLocalizedMessage('nameInvalid', context);
    }
    return null;
  }

  // Получить сообщение об ошибке подтверждения пароля
  static String? getConfirmPasswordError(
      String password, String confirmPassword, BuildContext context) {
    if (confirmPassword.isEmpty) {
      return _getLocalizedMessage('confirmPasswordEmpty', context);
    }
    if (!passwordsMatch(password, confirmPassword)) {
      return _getLocalizedMessage('passwordsNotMatch', context);
    }
    return null;
  }

  // Получить сообщение об ошибке корейского текста
  static String? getKoreanError(String text, BuildContext context) {
    if (text.isEmpty) {
      return _getLocalizedMessage('koreanEmpty', context);
    }
    if (!isValidKorean(text)) {
      return _getLocalizedMessage('koreanInvalid', context);
    }
    return null;
  }

  // Получить сообщение об ошибке английского текста
  static String? getTranslationError(String text, BuildContext context) {
    if (text.isEmpty) {
      return _getLocalizedMessage('translationEmpty', context);
    }
    if (!isValidTranslation(text)) {
      return _getLocalizedMessage('translationInvalid', context);
    }
    return null;
  }

  static String? getEnglishError(String text, BuildContext context) {
    if (text.isEmpty) {
      return _getLocalizedMessage('englishEmpty', context);
    }
    if (!isValidEnglish(text)) {
      return _getLocalizedMessage('englishInvalid', context);
    }
    return null;
  }

  // Валидация формы логина
  static bool isValidLoginForm(String email, String password) {
    return isValidEmail(email) && isValidPassword(password);
  }

  // Валидация формы регистрации
  static bool isValidSignUpForm({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    return isValidName(name) &&
        isValidEmail(email) &&
        isValidPassword(password) &&
        passwordsMatch(password, confirmPassword);
  }

  // Валидация словарной карточки
  static bool isValidVocabularyCard(String korean, String tranlation) {
    return isValidKorean(korean) && isValidTranslation(tranlation);
  }

  static List<TextInputFormatter> get koreanInputFormatters =>
      [KoreanTextInputFormatter()];

  // Получить все ошибки формы регистрации
  static Map<String, String?> getSignUpFormErrors({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required BuildContext context,
  }) {
    return {
      'name': getNameError(name, context),
      'email': getEmailError(email, context),
      'password': getPasswordError(password, context),
      'confirmPassword':
          getConfirmPasswordError(password, confirmPassword, context),
    };
  }

  // Получить все ошибки словарной карточки
  static Map<String, String?> getVocabularyCardErrors({
    required String korean,
    required String tranlation,
    required BuildContext context,
  }) {
    return {
      'korean': getKoreanError(korean, context),
      'translation': getTranslationError(tranlation, context),
    };
  }

  // Проверить, есть ли ошибки в карте
  static bool hasErrors(Map<String, String?> errors) {
    return errors.values.any((error) => error != null);
  }

  // Приватный метод для получения локализованных сообщений
  static String _getLocalizedMessage(String key, BuildContext context) {
    // Здесь можно интегрировать с AppLocale
    switch (key) {
      case 'emailEmpty':
        return AppLocalizations.of(context)!.emptyEmail;
      case 'emailInvalid':
        return AppLocalizations.of(context)!.pleaseEnterValidEmail;
      case 'passwordEmpty':
        return AppLocalizations.of(context)!.emptyPassword;
      case 'passwordTooShort':
        return AppLocalizations.of(context)!.passwordTooShort;
      case 'nameEmpty':
        return AppLocalizations.of(context)!.emptyName;
      case 'nameTooShort':
        return AppLocalizations.of(context)!.nameTooShort;
      case 'confirmPasswordEmpty':
        return AppLocalizations.of(context)!.emptyConfirmPassword;
      case 'passwordsNotMatch':
        return AppLocalizations.of(context)!.passwordsNotMatch;
      case 'koreanEmpty':
        return AppLocalizations.of(context)!.emptyKorean;
      case 'koreanInvalid':
        return AppLocalizations.of(context)!.invalidKorean;
      case 'translationEmpty':
        return AppLocalizations.of(context)!.translationEmpty;
      case 'englisInvalid':
        return AppLocalizations.of(context)!.invalidEnglish;
      default:
        return AppLocalizations.of(context)!.invalidInput;
    }
  }
}

// Расширение для удобного использования с TextEditingController
extension ValidationExtension on TextEditingController {
  String? validateEmail(BuildContext context) {
    return ValidationHelper.getEmailError(text, context);
  }

  String? validatePassword(BuildContext context) {
    return ValidationHelper.getPasswordError(text, context);
  }

  String? validateName(BuildContext context) {
    return ValidationHelper.getNameError(text, context);
  }

  String? validateKorean(BuildContext context) {
    return ValidationHelper.getKoreanError(text, context);
  }

  String? validateTranslation(BuildContext context) {
    return ValidationHelper.getTranslationError(text, context);
  }

  String? validateEnglish(BuildContext context) {
    return ValidationHelper.getEnglishError(text, context);
  }
}
