import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class NetworkLoadImage extends StatelessWidget {
  final String? url;
  final Widget? image;
  final Widget? placeHolder;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Color backgroundColor;
  final Color? filterColor;

  const NetworkLoadImage(
      {super.key,
      this.url,
      this.image,
      this.placeHolder,
      this.fit = BoxFit.cover,
      this.backgroundColor = Colors.transparent,
      this.filterColor,
      this.width = double.infinity,
      this.height = double.infinity});
  const NetworkLoadImage.fill({super.key, this.url, this.image, this.placeHolder})
      : width = double.infinity,
        height = double.infinity,
        backgroundColor = Colors.transparent,
        filterColor = null,
        fit = BoxFit.cover;

  @override
  Widget build(BuildContext context) {
    String? url = this.url;
    if (image != null &&
        (url == null || url.isEmpty || !url.startsWith("http"))) {
      return SizedBox(width: width, height: height, child: image!);
    } else {
      return (url == null || url.isEmpty)
          ? Container(
              color: backgroundColor,
              width: width,
              height: height,
              child: const Icon(
                Icons.image,
                color: Colors.grey,
              ),
            )
          : CachedNetworkImage(
              imageUrl: url,
              key: ValueKey(url),
              fit: fit,
              width: width,
              height: height,
              imageBuilder: filterColor == null ? null : (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: imageProvider,
                      fit: fit,
                      colorFilter:
                          ColorFilter.mode(filterColor!, BlendMode.color)),
                ),
              ),
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  placeHolder ??
                  image ??
                  const Center(
                      child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(),
                  )),
              errorWidget: (context, url, error) =>
                  image ??
                  Container(
                    color: backgroundColor,
                    child: const Icon(
                      Icons.image,
                      color: Colors.grey,
                    ),
                  ),
            );
    }
  }
}

class RoundedImage extends StatelessWidget {
  final String? url;
  final Widget? image;
  final BoxFit? fit;
  final double width;
  final double height;
  final Color borderColor;
  final Color backgroundColor;
  final Color? filterColor;
  final double borderWidth;
  final double radius;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? boxShadow;

  const RoundedImage(
      {super.key, this.url,
      this.image,
      this.fit,
      this.width = double.infinity,
      this.height = double.infinity,
      this.borderColor = Colors.white,
      this.backgroundColor = Colors.transparent,
      this.filterColor,
      this.borderWidth = 2.0,
      this.radius = 10,
      this.margin,
      this.boxShadow});
  const RoundedImage.normal(
      {this.url,
      this.image,
      this.fit,
      this.width = double.infinity,
      this.height = double.infinity,
      this.margin,
      this.backgroundColor = Colors.transparent,
        this.filterColor,
      this.boxShadow})
      : borderColor = Colors.white,
        borderWidth = 2.0,
        radius = 10.0,
        super();

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.all(Radius.circular(radius)),
          border: Border.all(color: borderColor, width: borderWidth),
          boxShadow: boxShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(radius - borderWidth)),
          child: NetworkLoadImage(
            url: url,
            image: image,
            fit: fit ?? BoxFit.cover,
            filterColor: filterColor,
          ),
        ));
  }
}

class CircleImage extends StatelessWidget {
  final String? url;
  final Widget? image;
  final double size;
  final Color? borderColor;
  final Color backgroundColor;
  final double borderWidth;
  final List<BoxShadow>? boxShadow;

  const CircleImage(
      {super.key, this.url,
      this.image,
      this.borderColor,
      this.backgroundColor = Colors.white,
      this.size = double.infinity,
      this.borderWidth = 2.0,
      this.boxShadow});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
              color: borderColor ?? Colors.white, width: borderWidth),
          boxShadow: boxShadow,
        ),
        clipBehavior: Clip.hardEdge,
        child: ClipOval(
          child: NetworkLoadImage(
              url: url, backgroundColor: backgroundColor, width: size, height: size, image: image, fit: BoxFit.cover,),
        ));
  }
}
