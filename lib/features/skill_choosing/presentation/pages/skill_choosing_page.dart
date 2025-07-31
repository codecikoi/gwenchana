import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gwenchana/features/skill_choosing/presentation/bloc/skill_choosing_bloc.dart';
import 'package:gwenchana/features/skill_choosing/presentation/bloc/skill_choosing_event.dart';
import 'package:gwenchana/features/skill_choosing/presentation/bloc/skill_choosing_state.dart';
import 'package:gwenchana/l10n/gen_l10n/app_localizations.dart';

@RoutePage()
class SkillChoosingPage extends StatelessWidget {
  const SkillChoosingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => SkillChoosingBloc(), child: SkillChoosingView());
  }
}

class SkillChoosingView extends StatefulWidget {
  const SkillChoosingView({super.key});

  @override
  State<SkillChoosingView> createState() => _SkillChoosingViewState();
}

class _SkillChoosingViewState extends State<SkillChoosingView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 300,
      ),
    );
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<SkillCard> skills = [
      SkillCard(
        id: '1',
        title: AppLocalizations.of(context)!.vocabulary,
        gradient: [
          Color.fromARGB(255, 136, 216, 139),
          Color.fromARGB(255, 5, 157, 58)
        ],
        icon: Icons.book,
      ),
      SkillCard(
        id: '2',
        title: AppLocalizations.of(context)!.reading,
        gradient: [Color(0xFFf093fb), Color(0xFFf5576c)],
        icon: Icons.menu_book,
      ),
      SkillCard(
        id: '3',
        title: AppLocalizations.of(context)!.writing,
        gradient: [Color(0xff667eea), Color(0xff764ba2)],
        icon: Icons.message,
      ),
      SkillCard(
        id: '4',
        title: AppLocalizations.of(context)!.speaking,
        gradient: [Color(0xFFffeaa7), Color(0xFFfab1a0)],
        icon: Icons.speaker,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gwenchana',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1.2,
          ),
        ),
        actions: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: CircleAvatar(
                radius: 14,
                backgroundImage: AssetImage('assets/logo/main_logo.png'),
                backgroundColor: Colors.grey[300],
              ),
            ),
            onTap: () => context.router.pushPath('/account-settings-page'),
          ),
        ],
        backgroundColor: Color(0xFFfab1a0),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFfab1a0),
              Color(0xffc67c4e),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 40,
          ),
          child: BlocListener<SkillChoosingBloc, SkillChoosingState>(
            listenWhen: (prev, curr) =>
                prev is SkillsLoaded &&
                curr is SkillsLoaded &&
                prev.isAnimating &&
                !curr.isAnimating &&
                curr.selectedIndex != -1,
            listener: (context, state) {
              if (state is SkillsLoaded && state.selectedIndex != -1) {
                switch (state.selectedIndex) {
                  case 0:
                    context.router.pushPath('/vocabulary-page');
                    break;
                  case 1:
                    context.router.pushPath('/reading-page');
                    break;
                  case 2:
                    context.router.pushPath('/writing-skill-page');
                    break;
                  case 3:
                    context.router.pushPath('/speaking-page');
                    break;
                }
              }
            },
            child: BlocBuilder<SkillChoosingBloc, SkillChoosingState>(
              builder: (context, state) {
                if (state is SkillsLoaded) {
                  var selectedIndex = state.selectedIndex;
                  final isAnimating = state.isAnimating;
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: skills.length,
                    itemBuilder: (context, index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        margin: EdgeInsets.only(
                          bottom: 20,
                          left: selectedIndex == index ? 10 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            if (!isAnimating) {
                              context.read<SkillChoosingBloc>().add(
                                    SkillSelected(selectedIndex == index
                                        ? ''
                                        : skills[index].id),
                                  );
                              _animationController.forward().then((_) {
                                _animationController.reverse();
                                Future.delayed(const Duration(milliseconds: 50),
                                    () {
                                  context
                                      .read<SkillChoosingBloc>()
                                      .add(SkillAnimationEnded());
                                });
                              });
                            }
                          },
                          child: Transform.scale(
                            scale: selectedIndex == index ? 1.05 : 1.0,
                            child: Container(
                              clipBehavior: Clip.hardEdge,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: skills[index].gradient,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(40),
                                    spreadRadius: 0,
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    top: -20,
                                    right: -20,
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(30),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: -10,
                                    right: -10,
                                    child: Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withAlpha(30),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              skills[index].title,
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              width: 40,
                                              height: 3,
                                              color: Colors.white.withAlpha(80),
                                            )
                                          ],
                                        ),
                                        AnimatedBuilder(
                                          animation: _animation,
                                          builder: (context, child) {
                                            return Opacity(
                                              opacity: selectedIndex == index
                                                  ? _animation.value
                                                  : 0.7,
                                              child: Icon(
                                                skills[index].icon,
                                                color: Colors.white,
                                                size: 40,
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (selectedIndex == index)
                                    AnimatedBuilder(
                                      animation: _animation,
                                      builder: (context, child) {
                                        return Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white.withAlpha(
                                                (30 * _animation.value)
                                                    .toInt()),
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else if (state is SkillsLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is SkillsError) {
                  return Center(child: Text(state.message));
                } else {
                  return Center(child: Text('Unknown state'));
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class SkillCard {
  final String id;
  final String title;
  final List<Color> gradient;
  final IconData icon;

  SkillCard({
    required this.id,
    required this.title,
    required this.gradient,
    required this.icon,
  });
}
