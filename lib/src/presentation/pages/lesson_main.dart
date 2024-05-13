import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_play/core/utils/constant.dart';
import 'package:video_play/src/domain/entities/curriculum_models.dart';
import 'package:video_play/src/presentation/bloc/lesson_bloc/lesson_bloc.dart';
import 'package:video_play/src/presentation/bloc/video_player_bloc/video_player_bloc.dart';
import 'package:video_play/src/presentation/widgets/app_bar.dart';
import 'package:video_play/src/presentation/widgets/list_section.dart';
import 'package:video_play/src/presentation/widgets/list_unit.dart';
import 'package:video_play/src/presentation/widgets/video_player.dart';

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

  late int selectedIndex = context.read<VideoPlayerBloc>().selected;
  late String urlDownload;

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
            urlDownload = listCurriculum[selectedIndex].offlineVideoLink!;
            context.read<VideoPlayerBloc>().add(
                  VideoPlayerLoad(
                    listCurriculum[selectedIndex].onlineVideoLink!,
                  ),
                );
            return Column(
              children: [
                const VideoPlayerWidget(),
                Expanded(
                  child: ListView.builder(
                    itemCount: listCurriculum.length,
                    itemBuilder: (context, index) {
                      if (listCurriculum[index].type ==
                          AppConstant.sectionType) {
                        return ListSectionWidget(
                          title: listCurriculum[index].title,
                        );
                      } else {
                        return ListUnitWidget(
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
                          },
                          onTapDownload: () {
                            if (listCurriculum[index].offlineVideoLink !=
                                null) {
                              context.read<VideoPlayerBloc>().add(
                                    CheckVideoDownloadStatus(
                                      listCurriculum[index].offlineVideoLink!,
                                    ),
                                  );
                            } else {}
                          },
                          isDownloaded:
                              context.read<VideoPlayerBloc>().downloadStatus,
                          offlineDownloadLink:
                              listCurriculum[index].offlineVideoLink,
                        );
                      }
                    },
                  ),
                )
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
