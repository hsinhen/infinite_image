import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_image/pages/image_list/widget/image_widget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../models/image_data.dart';
import 'controller/image_list_controller.dart';

class ImageListPage extends StatefulWidget {
  const ImageListPage({super.key});

  @override
  State<ImageListPage> createState() => _ImageListPageState();
}

class _ImageListPageState extends State<ImageListPage> {
  final ImageController controller = Get.put(ImageController());

  @override
  Widget build(BuildContext context) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Infinite Image'),
      ),
      body: SafeArea(
        child: Obx(
          () => RefreshIndicator(
            onRefresh: () async {
              await controller.refreshData();
            },
            child: PagedGridView<int, ImageData>(
              pagingController: controller.pagingController.value,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isPortrait ? 1 : 2,
                crossAxisSpacing: isPortrait ? 0 : 10.0,
                mainAxisSpacing: isPortrait ? 0 : 10.0,
                childAspectRatio: 1 / (isPortrait ? .56 : 0.6),
              ),
              cacheExtent: 2000,
              builderDelegate: PagedChildBuilderDelegate<ImageData>(
                itemBuilder: (context, e, index) => ImageWidget(
                  key: ValueKey(e.id),
                  imageData: e,
                  save: (e) => controller.downloadImage(e, context),
                  share: (e) => controller.shareImage(e, context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
