import 'package:PiliPalaX/common/widgets/http_error.dart';
import 'package:PiliPalaX/http/loading_state.dart';
import 'package:flutter/material.dart';
import 'package:PiliPalaX/common/constants.dart';
import 'package:PiliPalaX/common/widgets/badge.dart';
import 'package:PiliPalaX/common/widgets/network_img_layer.dart';
import 'package:PiliPalaX/utils/utils.dart';

import '../../../utils/grid.dart';

Widget searchBangumiPanel(BuildContext context, ctr, loadingState) {
  TextStyle style =
      TextStyle(fontSize: Theme.of(context).textTheme.labelMedium!.fontSize);
  return CustomScrollView(
    controller: ctr.scrollController,
    slivers: [
      loadingState is Success
          ? SliverPadding(
              padding: EdgeInsets.only(
                bottom: StyleString.safeSpace +
                    MediaQuery.of(context).padding.bottom,
              ),
              sliver: SliverGrid(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  mainAxisSpacing: StyleString.safeSpace,
                  crossAxisSpacing: StyleString.safeSpace,
                  maxCrossAxisExtent: Grid.maxRowWidth * 2,
                  mainAxisExtent: 160,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    var i = loadingState.response[index];
                    return InkWell(
                      onTap: () {
                        /// TODO 番剧详情页面
                        // Get.toNamed('/video?bvid=${i.bvid}&cid=${i.cid}', arguments: {
                        //   'videoItem': i,
                        //   'heroTag': Utils.makeHeroTag(i.id),
                        //   'videoType': SearchType.media_bangumi
                        // });
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                            StyleString.safeSpace,
                            StyleString.safeSpace,
                            StyleString.safeSpace,
                            2),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                NetworkImgLayer(
                                  width: 111,
                                  height: 148,
                                  src: i.cover,
                                ),
                                PBadge(
                                  text: i.mediaType == 1 ? '番剧' : '国创',
                                  top: 6.0,
                                  right: 4.0,
                                  bottom: null,
                                  left: null,
                                )
                              ],
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  RichText(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    text: TextSpan(
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onSurface),
                                      children: [
                                        for (var i in i.title) ...[
                                          TextSpan(
                                            text: i['text'],
                                            style: TextStyle(
                                              fontSize: MediaQuery.textScalerOf(
                                                      context)
                                                  .scale(Theme.of(context)
                                                      .textTheme
                                                      .titleSmall!
                                                      .fontSize!),
                                              fontWeight: FontWeight.bold,
                                              color: i['type'] == 'em'
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Theme.of(context)
                                                      .colorScheme
                                                      .onSurface,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text('评分:${i.mediaScore['score'].toString()}',
                                      style: style),
                                  Row(
                                    children: [
                                      Text(i.areas, style: style),
                                      const SizedBox(width: 3),
                                      const Text('·'),
                                      const SizedBox(width: 3),
                                      Text(
                                          Utils.dateFormat(i.pubtime)
                                              .toString(),
                                          style: style),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(i.styles, style: style),
                                      const SizedBox(width: 3),
                                      const Text('·'),
                                      const SizedBox(width: 3),
                                      Text(i.indexShow, style: style),
                                    ],
                                  ),
                                  const SizedBox(height: 18),
                                  SizedBox(
                                    height: 32,
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        Utils.viewBangumi(seasonId: i.seasonId);
                                        // SmartDialog.showLoading(msg: '获取中...');
                                        // var res = await SearchHttp.bangumiInfo(
                                        //     seasonId: i.seasonId);
                                        // SmartDialog.dismiss().then((value) {
                                        //   if (res['status']) {
                                        //     EpisodeItem episode =
                                        //         res['data'].episodes.first;
                                        //     int? epId = res['data']
                                        //         .userStatus
                                        //         ?.progress
                                        //         ?.lastEpId;
                                        //     if (epId == null) {
                                        //       epId = episode.epId;
                                        //     } else {
                                        //       for (var item
                                        //           in res['data'].episodes) {
                                        //         if (item.epId == epId) {
                                        //           episode = item;
                                        //           break;
                                        //         }
                                        //       }
                                        //     }
                                        //     String bvid = episode.bvid!;
                                        //     int cid = episode.cid!;
                                        //     String pic = episode.cover!;
                                        //     String heroTag =
                                        //         Utils.makeHeroTag(cid);
                                        //     Get.toNamed(
                                        //       '/video?bvid=$bvid&cid=$cid&seasonId=${i.seasonId}&epId=$epId',
                                        //       arguments: {
                                        //         'pic': pic,
                                        //         'heroTag': heroTag,
                                        //         'videoType':
                                        //             SearchType.media_bangumi,
                                        //         'bangumiItem': res['data'],
                                        //       },
                                        //     );
                                        //   } else {
                                        //     SmartDialog.showToast(res['msg']);
                                        //   }
                                        // });
                                      },
                                      child: const Text('观看'),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: loadingState.response.length,
                ),
              ),
            )
          : HttpError(
              errMsg: loadingState is Error ? loadingState.errMsg : '没有相关数据',
              callback: ctr.onReload,
            ),
    ],
  );
}
