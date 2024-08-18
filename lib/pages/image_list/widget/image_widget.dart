import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';

import '../../../models/image_data.dart';

class ImageWidget extends StatefulWidget {
  const ImageWidget({
    required this.imageData,
    this.save,
    this.share,
    super.key,
  });

  final ImageData imageData;
  final Function(String e)? save;
  final Function(String e)? share;

  @override
  State<ImageWidget> createState() => _ImageWidgetState();
}

class _ImageWidgetState extends State<ImageWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Stack(
            children: [
              widget.imageData.downloadUrl != null &&
                      widget.imageData.downloadUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: widget.imageData.downloadUrl!,
                      height: 200,
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) => Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Center(child: Icon(Icons.error)),
                    )
                  : Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: Center(
                        child: Text(
                          'Image not found',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
              Positioned(
                top: 8,
                right: 8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.share, color: Colors.white),
                      onPressed: () {
                        widget.share!(widget.imageData.downloadUrl!);
                        // _shareImage(widget.imageData.downloadUrl!);
                      },
                    ),
                    IconButton(
                      color: Colors.black.withOpacity(0.6),
                      icon: const Icon(Icons.save_alt, color: Colors.white),
                      onPressed: () {
                        widget.save!(widget.imageData.downloadUrl!);
                        // _downloadImage(widget.imageData.downloadUrl!);
                      },
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    widget.imageData.author ?? 'No author',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
