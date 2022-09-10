import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ImageView extends StatefulWidget {
  final String placeholder;
  final String image;
  final double height;
  final double width;

  const ImageView(
      {Key key, this.placeholder, this.image = "", this.height, this.width})
      : super(key: key);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: imageView(),
    );
  }

  Widget imageView() {
    if (widget.image == null || widget.image == "") {
      return placeholderImage();
    } else if (widget.image.contains('https') ||
        widget.image.contains('http')) {
      return CachedNetworkImage(
        imageUrl: widget.image,
        fit: BoxFit.cover,
        height: widget.height,
        width: widget.width,
        placeholder: (context, url) => placeholderImage(),
        errorWidget: (context, url, error) => placeholderImage(),
      );
    } else if (widget.image.contains('assets')) {
      return Image.asset(
        widget.image,
        fit: BoxFit.cover,
        height: widget.height,
        width: widget.width,
      );
    } else {
      return Image.file(
        File(widget.image),
        fit: BoxFit.cover,
        height: widget.height,
        width: widget.width,
      );
    }
  }

  Image placeholderImage() {
    return Image.asset(
      widget.placeholder,
      fit: BoxFit.cover,
      height: widget.height,
      width: widget.width,
    );
  }
}
