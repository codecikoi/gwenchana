import 'package:bloc/bloc.dart';
import 'package:gwenchana/features/writing/data/words.dart';
import 'package:gwenchana/features/writing/presentation/bloc/writing_skill_event.dart';
import 'package:gwenchana/features/writing/presentation/bloc/writing_skill_state.dart';

class WritingSkillBloc extends Bloc<WritingSkillEvent, WritingSkillState> {
  final List<Map<String, String>> words = writingSkillWords;

  WritingSkillBloc() : super(WritingSkillInitial()) {
    on<WritingInputChanged>(_onInputChanged);
    on<WritingCheckAnswer>(_onCheckAnswer);
    on<WritingNextWord>(_onNextWord);
    on<WritingPreviousWord>(_onPreviousWord);
    on<WritingSkipWord>(_onSkipWord);
    on<WritingResetProgress>(_onResetProgress);
    add(WritingResetProgress());
  }

  int _currentIndex = 0;
  String _userInput = '';
  bool _showResult = false;
  bool _isCorrect = false;
  bool _hasStudied = false;

  void _emitCurrentState(Emitter<WritingSkillState> emit) {
    emit(WritingSkillInProgress(
      currentIndex: _currentIndex,
      userInput: _userInput,
      showResult: _showResult,
      isCorrect: _isCorrect,
      hasStudied: _hasStudied,
      totalWords: words.length,
      currentWord: words[_currentIndex],
    ));
  }

  void _onInputChanged(
      WritingInputChanged event, Emitter<WritingSkillState> emit) {
    _userInput = event.input;
    _showResult = false;
    _emitCurrentState(emit);
  }

  void _onCheckAnswer(
      WritingCheckAnswer event, Emitter<WritingSkillState> emit) {
    final correct = words[_currentIndex]['korean']?.trim() ?? '';
    _isCorrect = _userInput.trim() == correct;
    _showResult = true;
    _hasStudied = true;
    _emitCurrentState(emit);
    if (_currentIndex == words.length - 1 && _isCorrect) {
      add(WritingNextWord());
    }
  }

  void _onNextWord(WritingNextWord event, Emitter<WritingSkillState> emit) {
    if (_currentIndex < words.length - 1) {
      _currentIndex++;
      _userInput = '';
      _showResult = false;
      _isCorrect = false;
      _hasStudied = false;
      _emitCurrentState(emit);
    } else {
      emit(WritingSkillFinished());
    }
  }

  void _onPreviousWord(
      WritingPreviousWord event, Emitter<WritingSkillState> emit) {
    if (_currentIndex > 0) {
      _currentIndex--;
      _userInput = '';
      _showResult = false;
      _isCorrect = false;
      _hasStudied = false;
      _emitCurrentState(emit);
    }
  }

  void _onSkipWord(WritingSkipWord event, Emitter<WritingSkillState> emit) {
    _hasStudied = false;
    _showResult = false;
    add(WritingNextWord());
  }

  void _onResetProgress(
      WritingResetProgress event, Emitter<WritingSkillState> emit) {
    _currentIndex = 0;
    _userInput = '';
    _showResult = false;
    _isCorrect = false;
    _hasStudied = false;
    _emitCurrentState(emit);
  }
}
