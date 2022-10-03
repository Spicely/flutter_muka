import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_muka/components/cached_image/cached_image.dart';

class MultiClosePosition {
  final double? left;

  final double? right;

  final double? top;

  final double? bottom;

  const MultiClosePosition({
    this.left,
    this.right,
    this.top,
    this.bottom,
  });
}

class MultiImageController {
  final List<MultiImageProps>? initData;

  _MultiImageState? _multiImageState;

  MultiImageController({
    this.initData,
  });

  /// 绑定状态
  void _bindMultiImageState(_MultiImageState state) {
    this._multiImageState = state;
    state._data = initData ?? [];
  }

  /// 添加图片
  void add(MultiImageProps data) {
    _multiImageState?._add(data);
  }

  /// 添加图片
  void addAll(List<MultiImageProps> data) {
    _multiImageState?._addAll(data);
  }

  /// 设置编辑状态
  void setEdit(bool status) {
    _multiImageState?._setEdit(status);
  }

  /// 获取数据
  List<MultiImageProps> getValue() {
    return _multiImageState == null ? [] : _multiImageState!._data;
  }
}

class MultiImage extends StatefulWidget {
  /// 控制器
  final MultiImageController controller;

  /// 最大数量
  final int? maxLength;

  /// 水平间距
  final double crossAxisSpacing;

  /// 垂直间距
  final double mainAxisSpacing;

  /// 每列数量
  final int crossAxisCount;

  final BoxBorder? border;

  final bool edit;

  final GestureTapCallback? onAdd;

  /// 删除图片时处罚
  final GestureTapCallback? onRemove;

  final Widget? addView;

  final BorderRadiusGeometry? borderRadius;

  final BorderRadius imageRadius;

  final double childAspectRatio;

  final EdgeInsetsGeometry imagePadding;

  final MultiClosePosition closePosition;

  const MultiImage({
    Key? key,
    required this.controller,
    this.maxLength,
    this.crossAxisSpacing = 5,
    this.mainAxisSpacing = 5,
    this.crossAxisCount = 3,
    this.childAspectRatio = 1.0,
    this.border,
    this.onAdd,
    this.edit = true,
    this.addView,
    this.borderRadius,
    this.onRemove,
    this.imagePadding = const EdgeInsets.all(5),
    this.imageRadius = const BorderRadius.all(Radius.circular(5)),
    this.closePosition = const MultiClosePosition(right: 3, top: 3),
  }) : super(key: key);

  @override
  _MultiImageState createState() => _MultiImageState();
}

class _MultiImageState extends State<MultiImage> {
  List<MultiImageProps> _data = [];

  late bool _edit;

  @override
  initState() {
    super.initState();
    widget.controller._bindMultiImageState(this);
    _edit = widget.edit;
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: widget.crossAxisSpacing,
        mainAxisSpacing: widget.mainAxisSpacing,
        childAspectRatio: widget.childAspectRatio,
      ),
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(5),
      itemCount: _getItemCount(),
      itemBuilder: (context, index) {
        if (_data.length > index) {
          return Container(
            decoration: BoxDecoration(
              border: widget.border ?? Border.all(style: BorderStyle.solid, color: Theme.of(context).dividerColor),
              borderRadius: widget.borderRadius,
            ),
            child: Stack(
              children: [
                Padding(
                  padding: widget.imagePadding,
                  child: ClipRRect(
                    borderRadius: widget.imageRadius,
                    child: _getImageView(_data[index]),
                  ),
                ),
                if (_edit)
                  Positioned(
                    right: widget.closePosition.right,
                    top: widget.closePosition.top,
                    left: widget.closePosition.left,
                    bottom: widget.closePosition.bottom,
                    child: GestureDetector(
                      child: Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(Icons.close, size: 12, color: Colors.white),
                      ),
                      onTap: () {
                        _data.removeAt(index);
                        widget.onRemove?.call();
                        setState(() {});
                      },
                    ),
                  ),
              ],
            ),
          );
        }
        return GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              border: widget.border ?? Border.all(style: BorderStyle.solid, color: Theme.of(context).dividerColor),
              borderRadius: widget.borderRadius,
            ),
            child: widget.addView ?? Icon(Icons.add, color: Theme.of(context).dividerColor),
          ),
          onTap: () {
            widget.onAdd?.call();
          },
        );
      },
    );
  }

  int _getItemCount() {
    if (widget.maxLength != null) {
      return widget.maxLength! > _data.length
          ? _edit
              ? _data.length + 1
              : _data.length
          : widget.maxLength!;
    }
    return _edit ? _data.length + 1 : _data.length;
  }

  Widget _getImageView(MultiImageProps data) {
    if (data.file != null) {
      return CachedImage(
        file: data.file!,
        width: double.maxFinite,
        fit: BoxFit.cover,
      );
    }
    if (data.fileData != null) {
      return ExtendedImage.memory(
        data.fileData!,
        width: double.maxFinite,
        fit: BoxFit.cover,
      );
    }
    return CachedImage(
      imageUrl: (data.baseUrl ?? '') + data.url!,
      width: double.maxFinite,
      fit: BoxFit.cover,
    );
  }

  void _add(MultiImageProps data) {
    _data.add(data);
    setState(() {});
  }

  void _addAll(List<MultiImageProps> data) {
    _data.addAll(data);
    setState(() {});
  }

  void _setEdit(bool status) {
    _edit = status;
    setState(() {});
  }
}

class MultiImageProps {
  final String? url;

  final File? file;

  final Uint8List? fileData;

  /// 用于需要拼接网络地址使用
  final String? baseUrl;

  MultiImageProps({
    this.url,
    this.file,
    this.baseUrl,
    this.fileData,
  });
}
