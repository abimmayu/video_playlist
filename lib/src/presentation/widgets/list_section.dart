import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_play/core/utils/constant.dart';
import 'package:video_play/src/domain/usecases/duration_on_minutes_usecase.dart';

class ListSectionWidget extends StatelessWidget {
  const ListSectionWidget({
    super.key,
    required this.title,
    required this.duration,
  });

  final String title;
  final int duration;

  @override
  Widget build(BuildContext context) {
    ConvertDurationUseCase newDuration =
        ConvertDurationUseCase().execute(duration);
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 5.h,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(20),
        vertical: ScreenUtil().setHeight(10),
      ),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey[300]!,
            offset: const Offset(0, -1),
            blurRadius: 2,
          ),
          BoxShadow(
            color: Colors.grey[300]!,
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
        color: Colors.grey[50],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppConstant().normalTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: ScreenUtil().setHeight(5),
          ),
          Text(
            duration >= 86400
                ? "${newDuration.day} days ${newDuration.hour} hours ${newDuration.minutes} minutes"
                : duration >= 3600 && duration < 86400
                    ? "${newDuration.hour} hours ${newDuration.minutes} minutes"
                    : "${newDuration.minutes} minutes",
            style: AppConstant().thinTextStyle,
          ),
        ],
      ),
    );
  }
}
