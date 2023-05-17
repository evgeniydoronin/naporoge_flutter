import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_theme.dart';

class StepperIcons extends StatefulWidget {
  final int step;

  const StepperIcons({Key? key, required this.step}) : super(key: key);

  @override
  State<StepperIcons> createState() => _StepperIconsState();
}

class _StepperIconsState extends State<StepperIcons> {
  late String _iconSrc2;
  late String _iconSrc3;
  late Color _lineColor;
  late Color _lineColor2;

  @override
  void initState() {
    super.initState();
    if (widget.step == 0) {
      _lineColor = AppColor.accent.withAlpha(50);
      _lineColor2 = AppColor.accent.withAlpha(50);

      _iconSrc2 = 'assets/icons/checkbox_off.svg';
      _iconSrc3 = 'assets/icons/checkbox_off.svg';
    } else if (widget.step == 1) {
      _lineColor = AppColor.accent;
      _lineColor2 = AppColor.accent.withAlpha(50);

      _iconSrc2 = 'assets/icons/checkbox_on.svg';
      _iconSrc3 = 'assets/icons/checkbox_off.svg';
    } else if (widget.step == 2) {
      _lineColor = AppColor.accent;
      _lineColor2 = AppColor.accent;

      _iconSrc2 = 'assets/icons/checkbox_on.svg';
      _iconSrc3 = 'assets/icons/checkbox_on.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/checkbox_on.svg'),
          Container(
            height: 1,
            width: 80,
            color: _lineColor,
          ),
          SvgPicture.asset(_iconSrc2),
          Container(
            height: 1,
            width: 80,
            color: _lineColor2,
          ),
          SvgPicture.asset(_iconSrc3),
        ],
      ),
    );
  }
}
