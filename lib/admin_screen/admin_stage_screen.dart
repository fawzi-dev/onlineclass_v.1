import 'package:flutter/material.dart';
import 'package:onlineclass/admin_screen/admin_main_screen.dart';
import 'package:onlineclass/constants/constants.dart';
import 'package:onlineclass/utlities/colors.dart';
import 'package:onlineclass/utlities/stagePath.dart';

import '../utlities/drawer.dart';

class AdminStageScreen extends StatelessWidget {
  const AdminStageScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// #### Constant values to be controlled at once
    const double height = 0.1;
    const verticalPadding = 0.005;
    const horizontalPadding = 0.05;

    return Scaffold(
      backgroundColor: colorBack1,
      appBar: AppBar(
        title: const Text('Stages'),
        backgroundColor: colorBack1,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (ctx, constraints) => Container(
            color: colorBack1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StagesCard(
                    title: 'Stage 1',
                    onTap: () {
                      goToStage(context, 'Stage1');
                    },
                    paddingHorizontal: constraints.maxWidth * horizontalPadding,
                    paddingVertical: constraints.maxHeight * verticalPadding,
                    height: constraints.maxHeight * height),
                StagesCard(
                    title: 'Stage 2',
                    onTap: () {
                      goToStage(context, 'Stage2');
                    },
                    paddingHorizontal: constraints.maxWidth * horizontalPadding,
                    paddingVertical: constraints.maxHeight * verticalPadding,
                    height: constraints.maxHeight * height),
                StagesCard(
                    title: 'Stage 3',
                    onTap: () {
                      goToStage(context, 'Stage3');
                    },
                    paddingHorizontal: constraints.maxWidth * horizontalPadding,
                    paddingVertical: constraints.maxHeight * verticalPadding,
                    height: constraints.maxHeight * height),
                SizedBox(height: constraints.maxHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: constraints.maxHeight * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                        color: Colors.amber,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: constraints.maxHeight * 0.02),
                        child: Text(
                          'Programming',
                          style: kDivHeader,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                      color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: constraints.maxHeight * 0.02,
                ),
                StagesCard(
                  title: 'Stage 4',
                  onTap: () {
                    goToStage(context, 'Stage 4 - Programming');
                  },
                  paddingHorizontal: constraints.maxWidth * horizontalPadding,
                  paddingVertical: constraints.maxHeight * verticalPadding,
                  height: constraints.maxHeight * height,
                ),
                StagesCard(
                  title: 'Stage 5',
                  onTap: () {
                     goToStage(context, 'Stage 5 - Programming');
                  },
                  paddingHorizontal: constraints.maxWidth * horizontalPadding,
                  paddingVertical: constraints.maxHeight * verticalPadding,
                  height: constraints.maxHeight * height,
                ),
                SizedBox(height: constraints.maxHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: constraints.maxHeight * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.amber,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          'Network',
                          style: kDivHeader,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                StagesCard(
                  title: 'Stage 4',
                  onTap: () {
                     goToStage(context, 'Stage 4 - Network');
                  },
                  paddingHorizontal: constraints.maxWidth * horizontalPadding,
                  paddingVertical: constraints.maxHeight * verticalPadding,
                  height: constraints.maxHeight * height,
                ),
                StagesCard(
                  title: 'Stage 5',
                  onTap: () {
                    goToStage(context, 'Stage 5 - Network');
                  },
                  paddingHorizontal: constraints.maxWidth * horizontalPadding,
                  paddingVertical: constraints.maxHeight * verticalPadding,
                  height: constraints.maxHeight * height,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StagesCard extends StatelessWidget {
  const StagesCard({
    Key? key,
    required this.title,
    required this.onTap,
    required this.height,
    required this.paddingHorizontal,
    required this.paddingVertical,
  }) : super(key: key);

  final String title;
  final VoidCallback onTap;
  final double height;
  final double paddingHorizontal;
  final double paddingVertical;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: paddingHorizontal,
        vertical: paddingVertical,
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          alignment: Alignment.center,
          height: height,
          width: double.infinity,
          child: Text(
            title,
            style: kCardTitle,
          ),
          decoration: BoxDecoration(
            color: darkBlue.withOpacity(0.7),
            borderRadius: BorderRadius.circular(7),
          ),
        ),
      ),
    );
  }
}
