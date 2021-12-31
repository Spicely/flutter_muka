part of flutter_muka;

class CropImageFile extends StatefulWidget {
  final File file;

  final double cropAspectRatio;

  final double hitTestSize;

  final EdgeInsets cropRectPadding;

  final double maxScale;

  final Widget? doneWidget;

  const CropImageFile({
    Key? key,
    required this.file,
    this.hitTestSize = 20.0,
    this.maxScale = 8.0,
    this.cropAspectRatio = 1.0,
    this.cropRectPadding = const EdgeInsets.all(20.0),
    this.doneWidget,
  }) : super(key: key);

  @override
  _CropImageState createState() => _CropImageState();
}

class _CropImageState extends State<CropImageFile> {
  final GlobalKey<ExtendedImageEditorState> _editorKey = GlobalKey<ExtendedImageEditorState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ExtendedImage.file(
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
                icon: widget.doneWidget ?? Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              IconButton(
                icon: widget.doneWidget ?? Icon(Icons.done),
                onPressed: () async {
                  EasyLoading.show(maskType: EasyLoadingMaskType.clear);
                  Uint8List data = (await cropImageDataWithDartLibrary(state: _editorKey.currentState!))!;
                  EasyLoading.dismiss();
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

class CropImageMemory extends StatefulWidget {
  final Uint8List file;

  final double cropAspectRatio;

  final double hitTestSize;

  final EdgeInsets cropRectPadding;

  final double maxScale;

  final Widget? doneWidget;

  const CropImageMemory({
    Key? key,
    required this.file,
    this.hitTestSize = 20.0,
    this.maxScale = 8.0,
    this.cropAspectRatio = 1.0,
    this.cropRectPadding = const EdgeInsets.all(20.0),
    this.doneWidget,
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
                  EasyLoading.show(maskType: EasyLoadingMaskType.clear);
                  Uint8List data = (await cropImageDataWithDartLibrary(state: _editorKey.currentState!))!;
                  EasyLoading.dismiss();
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
