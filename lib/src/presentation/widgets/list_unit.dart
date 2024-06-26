import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_play/core/utils/constant.dart';
import 'package:video_play/core/utils/video_download.dart';
import 'package:video_play/src/domain/usecases/check_download_status.dart';
import 'package:video_play/src/domain/usecases/duration_on_minutes_usecase.dart';
import 'package:video_play/src/presentation/bloc/video_player_bloc/video_player_bloc.dart';

class ListUnitWidget extends StatefulWidget {
  ListUnitWidget({
    super.key,
    required this.title,
    required this.duration,
    required this.onTap,
    required this.onTapDownload,
    required this.onTapDelete,
    required this.isSelected,
    required this.isDownload,
    this.offlineDownloadLink,
  });

  final String title;
  final int duration;
  final Function() onTap;
  final Function() onTapDownload;
  final Function() onTapDelete;
  final bool isSelected;
  final bool isDownload;
  String? offlineDownloadLink;

  @override
  State<ListUnitWidget> createState() => _ListUnitWidgetState();
}

class _ListUnitWidgetState extends State<ListUnitWidget> {
  @override
  void initState() {
    super.initState();
  }

  checkDownloadStatus(String url) async {
    final internalPath = await getApplicationDocumentsDirectory();
    final fileName = url.split('/').last;
    final filePath = '${internalPath.path}/videos/$fileName';

    final file = File(filePath);

    setState(() {
      isDownloaded = file.existsSync();
    });
  }

  bool isDownloaded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.offlineDownloadLink != null) {
      checkDownloadStatus(widget.offlineDownloadLink!);
    }
    return BlocListener<VideoPlayerBloc, VideoPlayerState>(
      listener: (context, state) {},
      child: GestureDetector(
        onTap: widget.onTap,
        child: newWidget(
          widget.duration,
          isDownloaded,
          widget.offlineDownloadLink,
        ),
      ),
    );
  }

  Widget newWidget(int duration, bool isDownloaded, String? url) {
    ConvertDurationUseCase newDuration =
        ConvertDurationUseCase().execute(duration);
    return Container(
      decoration: BoxDecoration(
        color: widget.isSelected ? Colors.lightBlue[50] : Colors.white,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(20),
        vertical: ScreenUtil().setHeight(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SizedBox(
                height: ScreenUtil().setHeight(3),
              ),
              Container(
                padding: EdgeInsets.all(
                  ScreenUtil().setHeight(2),
                ),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(
                    20,
                  ),
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: ScreenUtil().setHeight(10),
                ),
              ),
            ],
          ),
          SizedBox(
            width: ScreenUtil().setWidth(10),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Html(
                  data: widget.title,
                  style: {
                    "body": Style(
                      margin: Margins.zero,
                      padding: HtmlPaddings.only(
                        bottom: ScreenUtil().setHeight(5),
                      ),
                      fontSize: FontSize.large,
                      fontWeight: FontWeight.w600,
                    ),
                  },
                ),
                Text(
                  duration >= 86400
                      ? "${newDuration.day} days ${newDuration.hour} hours ${newDuration.minutes} minutes"
                      : duration >= 3600 && duration < 86400
                          ? "${newDuration.hour} hours ${newDuration.minutes} minutes"
                          : "${newDuration.minutes} minutes",
                  style: AppConstant().thinTextStyle.copyWith(
                        fontSize: 12,
                      ),
                ),
                const Row(
                  children: [],
                ),
              ],
            ),
          ),
          widget.offlineDownloadLink != null
              ? InkWell(
                  onTap:
                      isDownloaded ? widget.onTapDelete : widget.onTapDownload,
                  child: BlocListener<VideoPlayerBloc, VideoPlayerState>(
                    listener: (context, state) {
                      if (state is VideoDownloadSuccess) {}
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      height: ScreenUtil().setHeight(30),
                      decoration: BoxDecoration(
                        color: isDownloaded ? Colors.white : Colors.blue,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: Colors.grey[200]!,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isDownloaded ? "Tersimpan" : "Tonton Offline",
                            style: isDownloaded
                                ? AppConstant().normalTextStyle.copyWith(
                                      color: Colors.black,
                                      fontSize: 10,
                                    )
                                : AppConstant().thinTextStyle.copyWith(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                          ),
                          SizedBox(
                            width: ScreenUtil().setWidth(3),
                          ),
                          isDownloaded
                              ? Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.blue,
                                  size: ScreenUtil().setHeight(12),
                                )
                              : const SizedBox.shrink()
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
