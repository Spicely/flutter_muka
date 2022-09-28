/*
 * Summary: 文件描述
 * Created Date: 2022-09-29 00:38:53
 * Author: Spicely
 * -----
 * Last Modified: 2022-09-29 00:39:15
 * Modified By: Spicely
 * -----
 * Copyright (c) 2022 Spicely Inc.
 * 
 * May the force be with you.
 * -----
 * HISTORY:
 * Date      	By	Comments
 */

import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';

import '../../flutter_muka.dart';
import '../crop_editor_helper.dart';

class CropImageMemory extends StatefulWidget {
  final Uint8List file;

  final double cropAspectRatio;

  final double hitTestSize;

  final EdgeInsets cropRectPadding;

  final double maxScale;

  final Widget? doneWidget;

  final Function()? beforeCrop;

  final Function()? afterCrop;

  const CropImageMemory({
    Key? key,
    required this.file,
    this.hitTestSize = 20.0,
    this.maxScale = 8.0,
    this.cropAspectRatio = 1.0,
    this.cropRectPadding = const EdgeInsets.all(20.0),
    this.doneWidget,
    this.beforeCrop,
    this.afterCrop,
  }) : super(key: key);

  @override
  _CropImageMemoryState createState() => _CropImageMemoryState();
}

class _CropImageMemoryState extends State<CropImageMemory> {
  final GlobalKey<ExtendedImageEditorState> _editorKey = GlobalKey<ExtendedImageEditorState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ExtendedImage.memory(
          widget.file,
          fit: BoxFit.contain,
          mode: ExtendedImageMode.editor,
          cacheRawData: true,
          extendedImageEditorKey: _editorKey,
          enableLoadState: true,
          initEditorConfigHandler: (state) {
            return EditorConfig(
              maxScale: widget.maxScale,
              cropRectPadding: widget.cropRectPadding,
              hitTestSize: widget.hitTestSize,
              cropAspectRatio: widget.cropAspectRatio,
              initCropRectType: InitCropRectType.imageRect,
            );
          },
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(),
            actions: [
              IconButton(
                icon: widget.doneWidget ?? Icon(Icons.close, color: Colors.black54),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: widget.doneWidget ?? Icon(Icons.done, color: Theme.of(context).primaryColor),
                onPressed: () async {
                  widget.beforeCrop?.call();
                  Uint8List? data = await cropImageDataWithDartLibrary(state: _editorKey.currentState!);
                  if (data != null) {
                    data = await Utils.compressWithList(data);
                  }
                  widget.afterCrop?.call();
                  Navigator.pop(context, data);
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
