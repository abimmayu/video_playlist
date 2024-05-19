import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:path_provider/path_provider.dart';
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

  int selectedIndex = 1;
  late String urlDownload;
  bool isDownload = false;

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
                onPressed: () {},
                progress: state.progress,
              );
            } else {
              return CustomAppBarWidget(
                isDownloading: false,
                title: "Akutansi Dasar dan Keuangan",
                onPressed: () {
                  context.read<VideoPlayerBloc>().add(
                        VideoDownload(urlDownload),
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
                  VideoIntialize(
                    listCurriculum[selectedIndex].onlineVideoLink!,
                    listCurriculum[selectedIndex].offlineVideoLink!,
                    selectedIndex,
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
                      if (listCurriculum[index].offlineVideoLink != null) {
                        checkVideoFile() async {
                          final internalPath =
                              await getApplicationDocumentsDirectory();
                          final fileName = listCurriculum[index]
                              .offlineVideoLink!
                              .split('/')
                              .last;
                          final filePath =
                              '${internalPath.path}/videos/$fileName';

                          final file = File(filePath);

                          setState(() {
                            isDownload = file.existsSync();
                          });
                        }
                      }

                      if (listCurriculum[index].type ==
                          AppConstant.sectionType) {
                        return ListSectionWidget(
                          title: listCurriculum[index].title,
                          duration: listCurriculum[index].duration,
                        );
                      } else {
                        return BlocListener<VideoPlayerBloc, VideoPlayerState>(
                          listener: (context, state) {
                            if (state is VideoDownloadSuccess) {
                              if (state.isDownloaded) {
                                context.read<VideoPlayerBloc>().add(
                                      VideoIntialize(
                                        listCurriculum[index].onlineVideoLink!,
                                        listCurriculum[index].offlineVideoLink!,
                                        index,
                                      ),
                                    );
                              }
                            }
                          },
                          child: ListUnitWidget(
                            isSelected: isSelected,
                            title: listCurriculum[index].title,
                            duration: listCurriculum[index].duration,
                            onTap: () {
                              urlDownload =
                                  listCurriculum[index].offlineVideoLink!;
                              context
                                  .read<VideoPlayerBloc>()
                                  .controller
                                  .dispose();
                              context.read<VideoPlayerBloc>().add(
                                    VideoIntialize(
                                      listCurriculum[index].onlineVideoLink!,
                                      listCurriculum[index].offlineVideoLink!,
                                      index,
                                    ),
                                  );
                              setState(() {
                                selectedIndex = index;
                              });
                            },
                            onTapDownload: () {
                              if (listCurriculum[index].offlineVideoLink !=
                                  null) {
                                context.read<VideoPlayerBloc>().add(
                                      VideoDownload(listCurriculum[index]
                                          .offlineVideoLink!),
                                    );
                                context.read<VideoPlayerBloc>().add(
                                      VideoIntialize(
                                        listCurriculum[index].onlineVideoLink!,
                                        listCurriculum[index].offlineVideoLink!,
                                        index,
                                      ),
                                    );
                                setState(() {
                                  isDownload = true;
                                  selectedIndex = index;
                                });
                              }
                            },
                            onTapDelete: () {
                              context.read<VideoPlayerBloc>().add(
                                    DeleteVideo(
                                      listCurriculum[index].onlineVideoLink!,
                                      listCurriculum[index].offlineVideoLink!,
                                    ),
                                  );
                              context.read<VideoPlayerBloc>().add(
                                    VideoIntialize(
                                      listCurriculum[index].onlineVideoLink!,
                                      listCurriculum[index].offlineVideoLink!,
                                      index,
                                    ),
                                  );
                              setState(() {
                                isDownload = false;
                                selectedIndex = index;
                              });
                            },
                            isDownload: isDownload,
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
