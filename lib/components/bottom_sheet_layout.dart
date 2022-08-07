/*
 * Summary: 文件描述
 * Created Date: 2022-08-05 23:43:56
 * Author: Spicely
 * -----
 * Last Modified: 2022-08-06 00:19:02
 * Modified By: Spicely
 * -----
 * Copyright (c) 2022 Spicely Inc.
 * 
 * May the force be with you.
 * -----
 * HISTORY:
 * Date      	By	Comments
 */
part of flutter_muka;

/// BottomSheet 定制框
class BottomSheetLayout extends StatelessWidget {
  final List<Widget> children;

  final MukaBottomSheetLayoutTheme? config;

  const BottomSheetLayout({
    Key? key,
    required this.children,
    this.config,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: config?.barBorderRadius ??
                MukaConfig.config.bottomSheetLayoutTheme.barBorderRadius ??
                BorderRadius.vertical(top: Radius.circular(10)),
            color: config?.bgColor ?? MukaConfig.config.bottomSheetLayoutTheme.bgColor,
            gradient: config?.gradient ?? MukaConfig.config.bottomSheetLayoutTheme.gradient,
            image: config?.image ?? MukaConfig.config.bottomSheetLayoutTheme.image,
          ),
          padding: config?.padding ?? MukaConfig.config.bottomSheetLayoutTheme.padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Padding(
                  padding: config?.barPadding ?? MukaConfig.config.bottomSheetLayoutTheme.barPadding,
                  child: SizedBox(
                    height: config?.barHeight ?? MukaConfig.config.bottomSheetLayoutTheme.barHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: config?.barColor ?? MukaConfig.config.bottomSheetLayoutTheme.barColor,
                        borderRadius:
                            config?.barBorderRadius ?? MukaConfig.config.bottomSheetLayoutTheme.barBorderRadius ?? BorderRadius.circular(3),
                      ),
                      width: config?.barWidth ?? MukaConfig.config.bottomSheetLayoutTheme.barWidth,
                    ),
                  ),
                ),
              ),
              ...children,
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
