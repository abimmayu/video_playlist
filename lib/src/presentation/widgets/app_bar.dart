import 'package:flutter/material.dart';

import 'package:video_play/core/utils/constant.dart';

class CustomAppBarWidget extends StatelessWidget {
  CustomAppBarWidget({
    super.key,
    required this.title,
    required this.onPressed,
    required this.isDownloading,
    this.progress,
    this.downloadProgress,
    this.downloadIndicatorIcon,
  });
  final String title;
  final Function() onPressed;
  bool isDownloading = false;
  final double? progress;
  double? downloadProgress;
  Widget? downloadIndicatorIcon;

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
      actions: [
        isDownloading
            ? Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                  ),
                  Text(
                    '${(progress! * 100).toInt()}%',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              )
            : Container(),
      ],
    );
  }

  void updateDownloadIndicator({double? progress, Widget? icon}) {
    downloadProgress = progress;
    downloadIndicatorIcon = icon;
  }
}
