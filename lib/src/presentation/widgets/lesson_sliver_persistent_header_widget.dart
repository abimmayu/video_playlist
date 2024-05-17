import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_play/core/utils/constant.dart';

class LessonHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      alignment: Alignment.centerLeft,
      child: const DefaultTabController(
        length: 3,
        child: Expanded(
          child: TabBar(
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                text: "Kurikulum",
              ),
              Tab(
                text: "Ikhtisar",
              ),
              Tab(text: "Lampiran"),
            ],
            unselectedLabelStyle: TextStyle(
              color: Colors.grey,
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 35.h;

  @override
  double get minExtent => 35.h;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
