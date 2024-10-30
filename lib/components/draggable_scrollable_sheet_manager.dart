part of flutter_muka;

class PhotoManagerPaths {
  final String? imagePath;

  final String? videoPath;

  const PhotoManagerPaths({this.imagePath, this.videoPath});
}

class DraggableScrollableSheetManager extends StatefulWidget {
  final double initialChildSize;
  final double minChildSize;

  /// 点击回调
  final Function(List<PhotoManagerPaths>)? onTap;

  const DraggableScrollableSheetManager({
    Key? key,
    this.initialChildSize = 0.4,
    this.minChildSize = 0.4,
    this.onTap,
  }) : super(key: key);

  @override
  State<DraggableScrollableSheetManager> createState() => _DraggableScrollableSheetManagerState();
}

class _DraggableScrollableSheetManagerState extends State<DraggableScrollableSheetManager> {
  /// 资源列表
  List<AssetEntity> _assetList = [];

  /// 选择列表
  List<AssetEntity> _selectedAssetList = [];

  final DraggableScrollableController _draggableScrollableController = DraggableScrollableController();

  /// 手势抬起
  bool _tapStatus = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _draggableScrollableController.addListener(_listener);
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    if (ps.isAuth) {
      final int count = await PhotoManager.getAssetCount();
      _assetList = await PhotoManager.getAssetListRange(start: 0, end: count);
      setState(() {});
    } else if (ps.hasAccess) {
    } else {}
  }

  void _listener() {
    if (_draggableScrollableController.size < widget.minChildSize + 0.05) {
      setState(() {
        _tapStatus = false;
      });
    } else if (_draggableScrollableController.size > 0.9) {
      setState(() {
        _tapStatus = true;
      });
    }
  }

  @override
  void dispose() {
    _draggableScrollableController.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: widget.initialChildSize,
      minChildSize: widget.minChildSize,
      controller: _draggableScrollableController,
      snap: true,
      builder: (BuildContext context, scrollController) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          ),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).hintColor,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              _tapStatus
                  ? SliverAppBar(
                      leading: Center(
                        child: TextButton(onPressed: _onMinimize, child: Text('后退')),
                      ),
                      actions: [
                        TextButton(onPressed: _onOpenAssets, child: Text('所有相册', style: TextStyle(fontSize: Theme.of(context).appBarTheme.titleTextStyle?.fontSize))),
                      ],
                      title: Column(
                        children: [
                          _selectedAssetList.isEmpty ? Text('最近') : Text('${_selectedAssetList.length}已选择'),
                          Text('选择至多10', style: TextStyle(fontSize: 12, color: Theme.of(context).hintColor)),
                        ],
                      ),
                      primary: false,
                      pinned: true,
                      centerTitle: true,
                    )
                  : SliverAppBar(
                      leading: Container(),
                    ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                sliver: SliverGrid.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10),
                  itemCount: _assetList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        _onSelectedAssetListChange(_assetList[index]);
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: index == 0 ? Radius.circular(20) : Radius.circular(5),
                          topRight: index == 2 ? Radius.circular(20) : Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            Image(
                              image: AssetEntityImageProvider(
                                _assetList[index],
                                isOriginal: false,
                                thumbnailSize: const ThumbnailSize.square(200),
                              ),
                              fit: BoxFit.cover,
                            ),
                            _assetList[index].type == AssetType.video
                                ? Positioned(
                                    left: 10,
                                    bottom: 10,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(5)),
                                      child: Row(
                                        children: [
                                          Icon(Icons.play_arrow_rounded, color: Colors.white, size: 20),
                                          Text(Utils.timeToStamp(_assetList[index].duration), style: TextStyle(color: Colors.white)),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Visibility(
                                visible: !_selectedAssetList.contains(_assetList[index]) && _selectedAssetList.length >= 10,
                                child: Container(
                                  color: Colors.white70,
                                  alignment: Alignment.topRight,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child: Visibility(
                                visible: _selectedAssetList.contains(_assetList[index]),
                                child: Container(
                                  color: Colors.black26,
                                  alignment: Alignment.topRight,
                                  child: Checkbox(
                                    value: true,
                                    onChanged: (v) {
                                      _onSelectedAssetListChange(_assetList[index]);
                                    },
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 点击选择资源
  void _onSelectedAssetListChange(AssetEntity data) async {
    if (_selectedAssetList.contains(data)) {
      _selectedAssetList.remove(data);
    } else {
      if (_selectedAssetList.length >= 10) {
        return;
      }
      _selectedAssetList.add(data);
    }
    List<PhotoManagerPaths> paths = [];
    for (var v in _selectedAssetList) {
      // print((await v.thumbnailData)?.path);
      // print((await v.file)?.path);
      paths.add(PhotoManagerPaths(imagePath: (await v.originFile)?.path));
    }
    widget.onTap?.call(paths);
    setState(() {});
  }

  /// 缩小到最小
  void _onMinimize() {
    _draggableScrollableController.animateTo(0.4, duration: Duration(milliseconds: 300), curve: Curves.ease);
  }

  /// 打开资源
  void _onOpenAssets() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      List<PhotoManagerPaths> paths = [];
      for (var v in result.files) {
        paths.add(PhotoManagerPaths(imagePath: v.path));
      }
      widget.onTap?.call(paths);
    } else {
      // User canceled the picker
    }
  }
}
