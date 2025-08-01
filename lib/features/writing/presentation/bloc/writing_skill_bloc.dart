import 'package:bloc/bloc.dart';
import 'package:gwenchana/core/di/locator.dart';
import 'package:gwenchana/core/domain/models/level.dart';
import 'package:gwenchana/core/domain/repository/book_repository.dart';
import 'package:gwenchana/core/services/get_words_from_data.dart';
import 'package:gwenchana/features/writing/presentation/bloc/writing_skill_event.dart';
import 'package:gwenchana/features/writing/presentation/bloc/writing_skill_state.dart';

class WritingSkillBloc extends Bloc<WritingSkillEvent, WritingSkillState> {
  List<Map<String, String>> words = [];
  final BookRepository _bookRepository = locator<BookRepository>();
  List<String> get levelNames => _bookRepository.getAllBookTitles();

  WritingSkillBloc() : super(WritingLevelsLoading()) {
    on<LoadWritingLevels>(_onLoadWritingLevels);
    on<ChangeWritingLevel>(_onChangeWritngWritingLevel);
    on<StartWritingSkill>(_onStartWritingSkill);
    on<WritingInputChanged>(_onInputChanged);
    on<WritingCheckAnswer>(_onCheckAnswer);
    on<WritingNextWord>(_onNextWord);
    on<WritingPreviousWord>(_onPreviousWord);
    on<WritingSkipWord>(_onSkipWord);
    on<WritingResetProgress>(_onResetProgress);
  }

  void _onLoadWritingLevels(
      LoadWritingLevels event, Emitter<WritingSkillState> emit) {
    emit(WritingLevelsLoaded(
      selectedLevel: 0,
      levelNames: levelNames,
      lessonTitles:
          GetWordsFromDataService.getLessonTitlesForLevel(Level.elementary),
    ));
  }

  void _onChangeWritngWritingLevel(
      ChangeWritingLevel event, Emitter<WritingSkillState> emit) {
    if (state is WritingLevelsLoaded) {
      final currentState = state as WritingLevelsLoaded;
      final level = Level.values[event.level];

      emit(currentState.copyWith(
        selectedLevel: event.level,
        lessonTitles: GetWordsFromDataService.getLessonTitlesForLevel(level),
      ));
    }
  }

  void _onStartWritingSkill(
      StartWritingSkill event, Emitter<WritingSkillState> emit) {
    final level = Level.values[event.level];

    words = GetWordsFromDataService.getWordsForWriting(level, event.setIndex);
    emit(WritingSkillInProgress(
      currentIndex: 0,
      userInput: '',
      showResult: false,
      isCorrect: false,
      hasStudied: false,
      totalWords: words.length,
      currentWord: words[0],
    ));
  }

  void _onInputChanged(
      WritingInputChanged event, Emitter<WritingSkillState> emit) {
    if (state is WritingSkillInProgress) {
      final s = state as WritingSkillInProgress;
      emit(s.copyWith(
        userInput: event.input,
        showResult: false,
      ));
    }
  }

  void _onCheckAnswer(
      WritingCheckAnswer event, Emitter<WritingSkillState> emit) {
    if (state is WritingSkillInProgress) {
      final s = state as WritingSkillInProgress;
      final correct = s.currentWord['korean']?.trim() ?? '';
      final isCorrect = s.userInput.trim() == correct;
      emit(s.copyWith(
        isCorrect: isCorrect,
        showResult: true,
        hasStudied: true,
      ));
      if (s.currentIndex == s.totalWords - 1 && isCorrect) {
        add(WritingNextWord());
      }
    }
  }

  void _onNextWord(WritingNextWord event, Emitter<WritingSkillState> emit) {
    if (state is WritingSkillInProgress) {
      final s = state as WritingSkillInProgress;
      if (s.currentIndex < words.length - 1) {
        emit(s.copyWith(
          currentIndex: s.currentIndex + 1,
          userInput: '',
          showResult: false,
          isCorrect: false,
          hasStudied: false,
          currentWord: words[s.currentIndex + 1],
        ));
      } else {
        emit(WritingSkillFinished());
      }
    }
  }

  void _onPreviousWord(
      WritingPreviousWord event, Emitter<WritingSkillState> emit) {
    if (state is WritingSkillInProgress) {
      final s = state as WritingSkillInProgress;
      if (s.currentIndex > 0) {
        emit(s.copyWith(
          currentIndex: s.currentIndex - 1,
          userInput: '',
          showResult: false,
          isCorrect: false,
          hasStudied: false,
          currentWord: words[s.currentIndex - 1],
        ));
      }
    }
  }

  void _onSkipWord(WritingSkipWord event, Emitter<WritingSkillState> emit) {
    if (state is WritingSkillInProgress) {
      final s = state as WritingSkillInProgress;
      emit(s.copyWith(
        hasStudied: false,
        showResult: false,
      ));
      add(WritingNextWord());
    }
  }

  void _onResetProgress(
      WritingResetProgress event, Emitter<WritingSkillState> emit) {
    emit(WritingSkillInProgress(
      currentIndex: 0,
      userInput: '',
      showResult: false,
      isCorrect: false,
      hasStudied: false,
      totalWords: words.length,
      currentWord: words[0],
    ));
  }
}
