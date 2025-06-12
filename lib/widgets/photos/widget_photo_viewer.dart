import 'dart:io';

import 'package:base_code_flutter/base_core.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

import '../../flavor/flavor.dart';


class PhotoViewerWidget extends StatefulWidget {
  final List<String> lsUrl;
  final int index;

  const PhotoViewerWidget({super.key, required this.lsUrl, this.index = 0});

  @override
  State<PhotoViewerWidget> createState() => _PhotoViewerWidgetState();
}

class _PhotoViewerWidgetState extends State<PhotoViewerWidget> {

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            pageController: _pageController,
            scrollPhysics: const ClampingScrollPhysics(),
            builder: (BuildContext context, int index) {

              var url = widget.lsUrl.elementAt(index);
              if (url.isNotEmpty && !url.startsWith("http")) {
                url = "${AppFlavor.cdnUrl}/$url";
              }
              var image = CachedNetworkImageProvider(url);
              return PhotoViewGalleryPageOptions(
                imageProvider: image,
                minScale: PhotoViewComputedScale.contained * 1,
                // heroAttributes: PhotoViewHeroAttributes(tag: ""),
              );
            },
            itemCount: widget.lsUrl.length,
            loadingBuilder: (context, event) => Center(
              child: SizedBox(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
                ),
              ),
            ),
            // backgroundDecoration: widget.backgroundDecoration,
            // pageController: widget.pageController,
            // onPageChanged: onPageChanged,
          ),
          Positioned(
              left: 8,
              top: screenUtil.statusBarHeight,
              child: CircleAvatar(
                backgroundColor: Colors.white24,
                child: IconButton(
                  icon: Icon(Icons.close_outlined, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ))
        ],
      ),
    );
  }
}
