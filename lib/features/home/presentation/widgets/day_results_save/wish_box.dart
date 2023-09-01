import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_theme.dart';
import '../../bloc/save_day_result/day_result_bloc.dart';

class WishBox extends StatefulWidget {
  final String title;
  final String category;
  final bool status;

  const WishBox({Key? key, required this.title, required this.category, required this.status}) : super(key: key);

  @override
  State<WishBox> createState() => _WishBoxState();
}

class _WishBoxState extends State<WishBox> {
  List<Map> buttonStatus = [
    {'padding': 5.0, 'radius': 20.0, 'result': 'small', 'isActive': false},
    {'padding': 3.0, 'radius': 24.0, 'result': 'middle', 'isActive': false},
    {'padding': 0.0, 'radius': 28.0, 'result': 'large', 'isActive': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 15, bottom: 15, left: 18, right: 18),
      decoration: BoxDecoration(
        color: AppColor.lightBGItem,
        border: Border.all(color: widget.status ? AppColor.red : const Color(0xFFE7E7E7)),
        borderRadius: AppLayout.primaryRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(
            widget.title,
            style: AppFont.formLabel,
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...buttonStatus.map(
                (e) => GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    for (Map btn in buttonStatus) {
                      btn['isActive'] = false;
                    }
                    e['isActive'] = true;

                    if (widget.category == 'desires') {
                      context.read<DayResultBloc>().add(DesiresChanged(e['result']));
                    } else if (widget.category == 'reluctance') {
                      context.read<DayResultBloc>().add(ReluctanceChanged(e['result']));
                    }

                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.all(e['padding']),
                    child: Container(
                      width: e['radius'],
                      height: e['radius'],
                      decoration: BoxDecoration(
                        color: e['isActive'] ? AppColor.accent : Colors.white,
                        border: e['isActive'] ? const Border() : Border.all(color: AppColor.deep),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
