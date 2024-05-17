import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
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
  late bool isDownloaded;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
          builder: (context, state) {
            if (state is VideoDownloading) {
              return CustomAppBarWidget(
                isDownloading: false,
                title: "Akutansi Dasar dan Keuangan",
                onPressed: () {
                  context.read<VideoPlayerBloc>().add(
                        CheckVideoDownloadStatus(
                          urlDownload,
                        ),
                      );
                },
                progress: state.progress,
              );
            } else {
              return CustomAppBarWidget(
                isDownloading: false,
                title: "Akutansi Dasar dan Keuangan",
                onPressed: () {
                  context.read<VideoPlayerBloc>().add(
                        CheckVideoDownloadStatus(
                          urlDownload,
                        ),
                      );
                },
              );
            }
          },
        ),
      ),
      body: BlocBuilder<LessonBloc, LessonState>(
        builder: (context, state) {
          if (state is LessonLoading) {
            selectedIndex = 1;
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LessonLoaded) {
            List<Curriculum> listCurriculum = state.curriculum;
            urlDownload = listCurriculum[selectedIndex].offlineVideoLink!;

            context.read<VideoPlayerBloc>().add(
                  VideoPlayerLoad(
                    listCurriculum[selectedIndex].onlineVideoLink!,
                  ),
                );
            return CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: VideoPlayerWidget(),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      top: 10,
                    ),
                    child: Html(
                      data: listCurriculum[selectedIndex].title,
                    ),
                  ),
                ),
                SliverPersistentHeader(
                  pinned: true,
                  delegate: LessonHeader(),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      bool isSelected = listCurriculum[selectedIndex] ==
                          listCurriculum[index];
                      isDownloaded = false;
                      if (listCurriculum[index].type ==
                          AppConstant.sectionType) {
                        return ListSectionWidget(
                          title: listCurriculum[index].title,
                          duration: listCurriculum[index].duration,
                        );
                      } else {
                        return BlocListener<VideoPlayerBloc, VideoPlayerState>(
                          listener: (context, state) {
                            if (state is VideoSelection) {
                              setState(
                                () {
                                  selectedIndex = state.index;
                                },
                              );
                            }
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
                                setState(
                                  () {
                                    selectedIndex = index;
                                  },
                                );
                              }
                            },
                            isDownloaded: isDownloaded,
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
