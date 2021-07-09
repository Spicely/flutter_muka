part of flutter_muka;

class CropImage extends StatefulWidget {
  final String url;

  final double cropAspectRatio;

  final double hitTestSize;

  final EdgeInsets cropRectPadding;

  final double maxScale;

  final Widget? doneWidget;

  const CropImage({
    Key? key,
    required this.url,
    this.hitTestSize = 20.0,
    this.maxScale = 8.0,
    this.cropAspectRatio = 1.0,
    this.cropRectPadding = const EdgeInsets.all(20.0),
    this.doneWidget,
  }) : super(key: key);

  @override
  _CropImageState createState() => _CropImageState();
}

class _CropImageState extends State<CropImage> {
  final GlobalKey<ExtendedImageEditorState> _editorKey = GlobalKey<ExtendedImageEditorState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ExtendedImage.file(
          File(widget.url),
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
                  Uint8List fileData = (await cropImageDataWithDartLibrary(state: _editorKey.currentState!))!;
                  EasyLoading.dismiss();
                  Navigator.pop(context, fileData);
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
