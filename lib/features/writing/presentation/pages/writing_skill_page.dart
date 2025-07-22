import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:confetti/confetti.dart';
import 'package:gwenchana/core/helper/validation_helper.dart';
import 'package:gwenchana/features/writing/presentation/bloc/writing_skill_bloc.dart';
import 'package:gwenchana/features/writing/presentation/bloc/writing_skill_event.dart';
import 'package:gwenchana/features/writing/presentation/bloc/writing_skill_state.dart';
import 'package:gwenchana/features/writing/presentation/widgets/grid_painter.dart';
import 'package:gwenchana/gen_l10n/app_localizations.dart';

@RoutePage()
class WritingSkillPage extends StatelessWidget {
  const WritingSkillPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WritingSkillBloc(),
      child: const WritingSkillView(),
    );
  }
}

class WritingSkillView extends StatefulWidget {
  const WritingSkillView({super.key});

  @override
  State<WritingSkillView> createState() => _WritingSkillViewState();
}

class _WritingSkillViewState extends State<WritingSkillView>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  bool _shouldUpdateController = true;

  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 2));
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WritingSkillBloc, WritingSkillState>(
      listener: (context, state) {
        if (state is WritingSkillInProgress) {
          if (_controller.text != state.userInput) {
            _shouldUpdateController = false;
            _controller.text = state.userInput;
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length),
            );
          }
        }
        if (state is WritingSkillFinished) {
          _animationController.forward(from: 0);
          _confettiController.play();
        }
      },
      builder: (context, state) {
        if (state is WritingSkillInProgress) {
          return Scaffold(
            backgroundColor: const Color(0xFF2C2C2E),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color(0xFF2C2C2E),
              leading: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              title: Text(
                '${state.currentIndex + 1} / ${state.totalWords}',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  onPressed: () {
                    context
                        .read<WritingSkillBloc>()
                        .add(WritingResetProgress());
                  },
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                // progress indicator
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: LinearProgressIndicator(
                    value: (state.currentIndex + 1) / state.totalWords,
                    backgroundColor: Colors.grey[700],
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF00D4AA),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          state.currentWord['english']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Align(
                        alignment: Alignment.topRight,
                        child: Builder(
                          builder: (context) {
                            return IconButton(
                              onPressed: () async {
                                final button =
                                    context.findRenderObject() as RenderBox;
                                final overlay = Overlay.of(context)
                                    .context
                                    .findRenderObject() as RenderBox;
                                final position = button.localToGlobal(
                                    Offset.zero,
                                    ancestor: overlay);
                                await showMenu(
                                  context: context,
                                  position: RelativeRect.fromLTRB(
                                    position.dx,
                                    position.dy + button.size.height,
                                    overlay.size.width -
                                        position.dx -
                                        button.size.width,
                                    overlay.size.height - position.dy,
                                  ),
                                  items: [
                                    PopupMenuItem(
                                      enabled: false,
                                      child: Text(
                                        '${AppLocalizations.of(context)!.correctAnswer}:\n ${state.currentWord['korean']}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                  color: Colors.black87,
                                  elevation: 8.0,
                                );
                              },
                              icon: const Icon(
                                Icons.tips_and_updates_rounded,
                              ),
                              iconSize: 24,
                              color: Colors.orangeAccent,
                            );
                          },
                        ),
                      ),
                      Container(
                        height: 350,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3C3C3E),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: Colors.grey[600]!,
                            width: 1,
                          ),
                        ),
                        child: CustomPaint(
                          painter: GridPainter(),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: TextField(
                                controller: _controller,
                                maxLength: 75,
                                maxLines: 4,
                                inputFormatters:
                                    ValidationHelper.koreanInputFormatters,
                                style: const TextStyle(
                                  color: Color(0xFF00D4AA),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '여기에 쓰세요',
                                  hintStyle: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 28,
                                  ),
                                  errorText: _controller.text.isEmpty
                                      ? null
                                      : ValidationHelper.getKoreanError(
                                          _controller.text, context),
                                ),
                                onChanged: (value) {
                                  if (_shouldUpdateController) {
                                    context
                                        .read<WritingSkillBloc>()
                                        .add(WritingInputChanged(value));
                                  }
                                  _shouldUpdateController = true;
                                },
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TextButton(
                            onPressed: state.currentIndex > 0
                                ? () => context
                                    .read<WritingSkillBloc>()
                                    .add(WritingPreviousWord())
                                : null,
                            child: Text(
                              AppLocalizations.of(context)!.back,
                              style: TextStyle(
                                color: state.currentIndex > 0
                                    ? const Color(0xFF00D4AA)
                                    : Colors.grey[600],
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              context
                                  .read<WritingSkillBloc>()
                                  .add(const WritingInputChanged(''));
                              _controller.clear();
                            },
                            icon: const Icon(
                              Icons.delete_outline_outlined,
                              color: Color(0xFF00D4AA),
                              size: 28,
                            ),
                          ),
                          TextButton(
                            onPressed:
                                state.currentIndex == state.totalWords - 1
                                    ? null
                                    : () => context
                                        .read<WritingSkillBloc>()
                                        .add(WritingSkipWord()),
                            child: Text(
                              AppLocalizations.of(context)!.skip,
                              style: TextStyle(
                                color:
                                    state.currentIndex == state.totalWords - 1
                                        ? Colors.grey[600]
                                        : const Color(0xFF00D4AA),
                                fontSize: 16,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 70),

                      // main button
                      Container(
                        width: double.infinity,
                        color: Colors.grey[700],
                        child: ElevatedButton(
                          onPressed: state.showResult
                              ? (state.isCorrect
                                  ? (state.currentIndex < state.totalWords - 1
                                      ? () => context
                                          .read<WritingSkillBloc>()
                                          .add(WritingNextWord())
                                      : null)
                                  : () {
                                      context
                                          .read<WritingSkillBloc>()
                                          .add(const WritingInputChanged(''));
                                      _controller.clear();
                                    })
                              : (state.userInput.isNotEmpty
                                  ? () => context
                                      .read<WritingSkillBloc>()
                                      .add(WritingCheckAnswer())
                                  : null),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: !state.showResult
                                ? (state.userInput.isNotEmpty
                                    ? Colors.yellow[700]
                                    : Colors.grey)
                                : (state.isCorrect
                                    ? Colors.green
                                    : Colors.deepOrange),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          child: Text(
                            !state.showResult
                                ? AppLocalizations.of(context)!.check
                                : (state.isCorrect
                                    ? (state.currentIndex < state.totalWords - 1
                                        ? AppLocalizations.of(context)!.next
                                        : AppLocalizations.of(context)!.finish)
                                    : AppLocalizations.of(context)!.tryAgain),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (state is WritingSkillFinished) {
          return Scaffold(
            backgroundColor: const Color(0xFF2C2C2E),
            body: Stack(
              alignment: Alignment.center,
              children: [
                ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  shouldLoop: false,
                  emissionFrequency: 0.08,
                  numberOfParticles: 30,
                  maxBlastForce: 20,
                  minBlastForce: 8,
                  gravity: 0.3,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // TODO: localization
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: Text(
                          AppLocalizations.of(context)!.congratsText,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<WritingSkillBloc>()
                              .add(WritingResetProgress());
                        },
                        child: Text(AppLocalizations.of(context)!.startAgain),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
