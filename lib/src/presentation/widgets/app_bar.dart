import 'package:flutter/material.dart';
import 'package:video_play/core/utils/constant.dart';

class CustomAppBarWidget extends StatelessWidget {
  const CustomAppBarWidget({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Icons.arrow_back,
        ),
      ),
      title: Text(
        title,
        style: AppConstant().titleTextStyle,
      ),
    );
  }
}
