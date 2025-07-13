import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jsulima/features/game_details/controller/game_details_controller.dart';
import 'package:jsulima/features/game_details/widget/player_tab_container.dart';
import 'package:jsulima/features/game_details/widget/player_tab_container_mlb.dart';
import 'package:jsulima/features/game_details/widget/prediction_tab_widget.dart';
import 'package:jsulima/features/game_details/widget/state_tab_container.dart';
import 'package:jsulima/features/game_details/widget/tuneup_screen.dart';
import 'package:jsulima/features/games/controller/game_controller.dart';
import 'package:jsulima/features/game_details/widget/head_to_head_shimmer.dart';

class TabNavigation extends StatelessWidget {
  final String team1Name;
  final String team2Name;

  const TabNavigation({
    super.key,
    required this.team1Name,
    required this.team2Name,
  });

  @override
  Widget build(BuildContext context) {
    return TabNavigationContent(team1Name: team1Name, team2Name: team2Name);
  }
}

class TabNavigationContent extends GetView<GameDetailsController> {
  final String team1Name;
  final String team2Name;

  const TabNavigationContent({
    super.key,
    required this.team1Name,
    required this.team2Name,
  });

  @override
  Widget build(BuildContext context) {
    final GameController gameController = Get.find<GameController>();

    // Fetch head-to-head data on first build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.headToHead.value == null &&
          !controller.isHeadToHeadLoading.value) {
        final sport = gameController.selectedButton.value == 0 ? 'nfl' : 'mlb';
        controller.fetchHeadToHead(
          homeTeam: team1Name,
          awayTeam: team2Name,
          sport: sport,
        );
      }
    });

    return TickerProviderBuilder(
      builder: (context, vsync) {
        // Initialize TabController when widget builds
        WidgetsBinding.instance.addPostFrameCallback((_) {
          controller.initializeTabController(vsync);
        });

        return Obx(() {
          final tabController = controller.tabController.value;
          if (tabController == null) {
            return SizedBox.shrink();
          }

          return Column(
            children: [
              TabBar(
                automaticIndicatorColorAdjustment: true,
                // dividerHeight: 0,
                controller: tabController,
                onTap: (index) => controller.updateSelectedIndex(index),
                indicatorColor: Color(0xFFCA0101),
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 6, color: Color(0xFFCA0101)),
                  insets: EdgeInsets.only(bottom: 0),
                ),
                labelColor: Color(0xFFCA0101),
                unselectedLabelColor: Color(0xFFABABAB),
                labelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.3,
                ),
                tabs: [
                  Tab(text: 'Prediction'),
                  Tab(text: 'Players'),
                  Tab(text: 'Line Up'),
                  Tab(text: 'State'),
                ],
              ),
              SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: IndexedStack(
                    index: controller.selectedIndex.value,
                    children: [
                      SingleChildScrollView(child: PredictionContainer()),
                      SingleChildScrollView(
                        child: gameController.selectedButton.value == 0
                            ? PlayerTabContainer(
                                team1Name: team1Name,
                                team2Name: team2Name,
                              )
                            : PlayerTabContainerMlb(
                                team1Name: team1Name,
                                team2Name: team2Name,
                              ),
                      ),
                      SingleChildScrollView(
                        child: TuneupScreen(
                          team1Name: team1Name,
                          team2Name: team2Name,
                        ),
                      ),
                      SingleChildScrollView(
                        child: Obx(() {
                          if (controller.isHeadToHeadLoading.value) {
                            return const HeadToHeadShimmer();
                          }

                          final data = controller.headToHead.value;
                          if (data == null) {
                            return Center(child: Text('No data'));
                          }
                          return StateTabContainer(
                            team1Win: data.wins,
                            team2Win: data.losses,
                            draw: data.draws,
                            team1Name: team1Name,
                            team2Name: team2Name,
                            matches: data.matches,
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        });
      },
    );
  }
}

// Custom widget that provides TickerProvider without StatefulWidget
class TickerProviderBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, TickerProvider vsync) builder;

  const TickerProviderBuilder({super.key, required this.builder});

  @override
  Widget build(BuildContext context) {
    return TickerProviderScope(builder: builder);
  }
}

class TickerProviderScope extends StatefulWidget {
  final Widget Function(BuildContext context, TickerProvider vsync) builder;

  const TickerProviderScope({super.key, required this.builder});

  @override
  State<TickerProviderScope> createState() => TickerProviderScopeState();
}

class TickerProviderScopeState extends State<TickerProviderScope>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context, this);
  }
}
