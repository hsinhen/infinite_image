import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:infinite_image/models/image_data.dart';
import 'package:infinite_image/pages/image_list/repo/image_list_repository.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class ImageController extends GetxController {
  static const int pageSize = 10;

  final Rx<PagingController<int, ImageData>> pagingController =
      PagingController<int, ImageData>(firstPageKey: 1).obs;

  @override
  void onInit() {
    pagingController.value.addPageRequestListener((pageKey) {
      fetchApiCall(pageKey);
    });
    super.onInit();
  }

  Future<void> refreshData() async {
    pagingController.value.refresh();
    try {
      pagingController.value.addPageRequestListener((pageKey) {
        fetchApiCall(pageKey);
      });
    } catch (e) {
      print('Error refreshing data: $e');
      pagingController.value.error = e;
    }
  }

  @override
  void onClose() {
    pagingController.value.dispose();
    super.onClose();
  }

  Future<void> shareImage(String data, BuildContext context) async {
    try {
      final url = Uri.parse(data);
      final response = await http.get(url);
      final contentType = response.headers['content-type'];
      final image = XFile.fromData(
        response.bodyBytes,
        mimeType: contentType,
      );
      await Share.shareXFiles([image]);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> downloadImage(String url, BuildContext context) async {
    try {
      var imageId = await ImageDownloader.downloadImage(url);
      if (imageId == null) {
        return;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image saved to gallery'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> fetchApiCall(int pageKey) async {
    try {
      List<ImageData> imageList = await ImageListRepository.fetchImages(
        pageNo: pageKey,
        itemPerPage: pageSize,
      );
      final isLastPage = imageList.length < pageSize;
      if (isLastPage) {
        pagingController.value.appendLastPage(imageList);
      } else {
        final nextPageKey = pageKey + 1;
        pagingController.value.appendPage(imageList, nextPageKey);
      }
    } catch (error) {
      pagingController.value.error = error;
    }
  }
}
