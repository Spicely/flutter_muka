/*
 * Summary: 扩展 Checkbox 组件
 * Created Date: 2022-07-22 17:32:11
 * Author: Spicely
 * -----
 * Last Modified: 2022-08-31 01:07:08
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

class MCheckbox extends StatelessWidget {
  final void Function(bool?)? onChanged;

  final bool? value;

  final Widget text;

  final Color? checkColor;

  final double scale;

  final MaterialStateProperty<Color?>? fillColor;

  final double? padding;

  const MCheckbox({
    Key? key,
    required this.onChanged,
    required this.value,
    required this.text,
    this.checkColor,
    this.fillColor,
    this.scale = 1.0,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onChanged?.call(null);
      },
      child: Row(
        children: [
          Transform.scale(
            scale: scale,
            child: Checkbox(
              value: value,
              onChanged: onChanged,
              splashRadius: 0,
              shape: const CircleBorder(),
              checkColor: checkColor,
              fillColor: fillColor,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          text,
        ],
      ),
    );
  }
}
