import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_play/core/utils/constant.dart';

class ListUnitWidget extends StatefulWidget {
  ListUnitWidget({
    super.key,
    required this.title,
    required this.duration,
    required this.onTap,
    required this.onTapDownload,
    required this.isDownloaded,
    required this.isSelected,
    this.offlineDownloadLink,
  });

  final String title;
  final int duration;
  final Function() onTap;
  final Function() onTapDownload;
  final bool isDownloaded;
  final bool isSelected;
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
      decoration: BoxDecoration(
        color: widget.isSelected ? Colors.blue[100] : Colors.white,
        // color: Colors.white,
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
                  "$duration minutes",
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
                  onTap: widget.onTapDownload,
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
                        Icon(
                          Icons.check_circle_outline,
                          color: Colors.blue,
                          size: ScreenUtil().setHeight(12),
                        )
                      ],
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
