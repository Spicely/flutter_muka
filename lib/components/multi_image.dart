part of flutter_muka;

class MultiImageController {
  _MultiImageState? _multiImageState;

  /// 绑定状态
  void _bindMultiImageState(_MultiImageState state) {
    this._multiImageState = state;
  }

  /// 添加图片
  void add(MultiImagePorps data) {
    _multiImageState?._add(data);
  }

  /// 设置编辑状态
  void setEdit(bool status) {
    _multiImageState?._setEdit(status);
  }

  /// 获取数据
  List<MultiImagePorps> getValue() {
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

  const MultiImage({
    Key? key,
    required this.controller,
    this.maxLength,
    this.crossAxisSpacing = 5,
    this.mainAxisSpacing = 5,
    this.crossAxisCount = 3,
    this.border,
    this.onAdd,
    this.edit = true,
  }) : super(key: key);

  @override
  _MultiImageState createState() => _MultiImageState();
}

class _MultiImageState extends State<MultiImage> {
  List<MultiImagePorps> _data = [];

  late bool _edit;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.controller._bindMultiImageState(this);
  }

  @override
  initState() {
    super.initState();
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
        childAspectRatio: 1.0,
      ),
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(5),
      itemCount: _getItemCount(),
      itemBuilder: (context, index) {
        if (_data.length > index) {
          return Container(
            decoration: BoxDecoration(
              border: widget.border ?? Border.all(style: BorderStyle.solid, color: Theme.of(context).dividerColor),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(5),
                  child: _getImageView(_data[index]),
                ),
                if (_edit)
                  Positioned(
                    right: 0,
                    top: 0,
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
            ),
            child: Icon(Icons.add, color: Theme.of(context).dividerColor),
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

  Widget _getImageView(MultiImagePorps data) {
    if (data.file != null) {
      return kIsWeb
          ? Image.network(
              data.file!,
              width: double.maxFinite,
              fit: BoxFit.cover,
            )
          : Image.file(
              File(data.file!),
              width: double.maxFinite,
              fit: BoxFit.cover,
            );
    }
    return Image.network(
      (data.baseUrl ?? '') + data.url!,
      width: double.maxFinite,
      fit: BoxFit.cover,
    );
  }

  void _add(MultiImagePorps data) {
    _data.add(data);
    setState(() {});
  }

  void _setEdit(bool status) {
    _edit = status;
    setState(() {});
  }
}

class MultiImagePorps {
  final String? url;

  final String? file;

  /// 用于需要拼接网络地址使用
  final String? baseUrl;

  MultiImagePorps({
    this.url,
    this.file,
    this.baseUrl,
  });
}
