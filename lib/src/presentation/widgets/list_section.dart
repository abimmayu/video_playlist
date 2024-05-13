import 'package:flutter/material.dart';
import 'package:video_play/core/utils/constant.dart';

class ListSectionWidget extends StatelessWidget {
  const ListSectionWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: AppConstant().normalTextStyle,
      ),
    );
  }
}
