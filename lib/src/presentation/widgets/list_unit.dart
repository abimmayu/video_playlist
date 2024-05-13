import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_play/core/utils/constant.dart';
import 'package:video_play/src/presentation/bloc/video_player_bloc/video_player_bloc.dart';

class ListUnitWidget extends StatefulWidget {
  ListUnitWidget({
    super.key,
    required this.title,
    required this.duration,
    required this.onTap,
    required this.onTapDownload,
    required this.isDownloaded,
    this.offlineDownloadLink,
  });

  final String title;
  final int duration;
  final Function() onTap;
  final Function() onTapDownload;
  final bool isDownloaded;
  String? offlineDownloadLink;

  @override
  State<ListUnitWidget> createState() => _ListUnitWidgetState();
}

class _ListUnitWidgetState extends State<ListUnitWidget> {
  bool isDownloaded = false;

  @override
  void initState() {
    downloadStatusChange();
    super.initState();
  }

  void downloadStatusChange() {
    setState(
      () {
        isDownloaded = widget.isDownloaded;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int durationOnMinutes = (widget.duration / 60).round();
    return GestureDetector(
      onTap: widget.onTap,
      child: newWidget(durationOnMinutes),
    );
  }

  Widget newWidget(int duration) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ScreenUtil().setWidth(10),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[50],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(
                20,
              ),
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Colors.white,
            ),
          ),
          SizedBox(
            width: ScreenUtil().setWidth(20),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Html(
                  data: widget.title,
                  style: {
                    "div": Style(
                      textAlign: TextAlign.left,
                    ),
                  },
                ),
                Row(
                  children: [
                    SizedBox(
                      width: ScreenUtil().setWidth(7),
                    ),
                    Text(
                      "$duration minutes",
                      style: AppConstant().thinTextStyle.copyWith(
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          widget.offlineDownloadLink != null
              ? InkWell(
                  onTap: widget.onTapDownload,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      isDownloaded ? "Watch Downloaded" : "Download",
                      style: AppConstant().thinTextStyle.copyWith(
                            color: Colors.white,
                            fontSize: 10,
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
