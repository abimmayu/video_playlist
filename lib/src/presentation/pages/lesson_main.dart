import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_play/core/utils/constant.dart';
import 'package:video_play/src/domain/entities/curriculum.dart';
import 'package:video_play/src/presentation/bloc/lesson_bloc/lesson_bloc.dart';
import 'package:video_play/src/presentation/bloc/video_player_bloc/video_player_bloc.dart';
import 'package:video_play/src/presentation/widgets/app_bar.dart';
import 'package:video_play/src/presentation/widgets/lesson_sliver_persistent_header_widget.dart';
import 'package:video_play/src/presentation/widgets/list_section.dart';
import 'package:video_play/src/presentation/widgets/list_unit.dart';
import 'package:video_play/src/presentation/widgets/video_player.dart';
import 'package:video_player/video_player.dart';

class MainLessonView extends StatefulWidget {
  const MainLessonView({super.key});

  @override
  State<MainLessonView> createState() => _MainLessonViewState();
}

class _MainLessonViewState extends State<MainLessonView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () {
        context.read<LessonBloc>().add(
              GetLessonEvent(),
            );
      },
    );
  }

  late int selectedIndex;
  late String urlDownload;
  // late bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBarWidget(
          title: "Akutansi Dasar dan Keuangan",
          onPressed: () {
            context.read<VideoPlayerBloc>().add(
                  CheckVideoDownloadStatus(
                    urlDownload,
                  ),
                );
          },
        ),
      ),
      body: BlocBuilder<LessonBloc, LessonState>(
        builder: (context, state) {
          if (state is LessonLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LessonLoaded) {
            List<Curriculum> listCurriculum = state.curriculum;
            selectedIndex = context.read<VideoPlayerBloc>().selected;
            urlDownload = listCurriculum[selectedIndex].offlineVideoLink!;

            context.read<VideoPlayerBloc>().add(
                  VideoPlayerLoad(
                    listCurriculum[selectedIndex].onlineVideoLink!,
                  ),
                );
            return CustomScrollView(
              slivers: [
                BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
                  builder: (context, state) {
                    if (state is VideoUninitialized) {
                      return const SliverToBoxAdapter(
                          child: CircularProgressIndicator());
                    } else if (state is VideoInitializedState) {
                      return const SliverToBoxAdapter(
                        child: VideoPlayerWidget(),
                      );
                    }
                    return Container();
                  },
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 10,
                    ),
                    child: Html(
                      data: listCurriculum[selectedIndex].title,
                      // style: AppConstant().normalTextStyle,
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  floating: true,
                  pinned: true,
                  delegate: LessonHeader(),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      bool isSelected =
                          index == context.read<VideoPlayerBloc>().selected;
                      if (listCurriculum[index].type ==
                          AppConstant.sectionType) {
                        return ListSectionWidget(
                          title: listCurriculum[index].title,
                          duration: listCurriculum[index].duration,
                        );
                      } else {
                        return BlocListener<VideoPlayerBloc, VideoPlayerState>(
                          listener: (context, state) {
                            selectedIndex =
                                context.read<VideoPlayerBloc>().selected;
                          },
                          child: ListUnitWidget(
                            isSelected: isSelected,
                            title: listCurriculum[index].title,
                            duration: listCurriculum[index].duration,
                            onTap: () {
                              urlDownload =
                                  listCurriculum[index].offlineVideoLink!;
                              context.read<VideoPlayerBloc>().add(
                                    VideoSelected(
                                      listCurriculum[index].onlineVideoLink!,
                                      index,
                                    ),
                                  );
                              log("Ini selected index: $selectedIndex");
                              log("Ini index: $index");
                              log("Ini selected: ${context.read<VideoPlayerBloc>().selected}");
                            },
                            onTapDownload: () {
                              if (listCurriculum[index].offlineVideoLink !=
                                  null) {
                                context.read<VideoPlayerBloc>().add(
                                      CheckVideoDownloadStatus(
                                        listCurriculum[index].offlineVideoLink!,
                                      ),
                                    );
                              }
                            },
                            isDownloaded:
                                context.read<VideoPlayerBloc>().downloadStatus,
                            offlineDownloadLink:
                                listCurriculum[index].offlineVideoLink,
                          ),
                        );
                      }
                    },
                    childCount: listCurriculum.length,
                  ),
                ),
              ],
            );
          } else if (state is LessonError) {
            return Text(state.error);
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
