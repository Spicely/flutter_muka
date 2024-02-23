part of flutter_muka;
/*
 * Summary: 缓存图片组件
 * Created Date: 2022-06-16 23:54:28
 * Author: Spicely
 * -----
 * Last Modified: 2023-09-07 11:25:34
 * Modified By: Spicely
 * -----
 * Copyright (c) 2022 Spicely Inc.
 * 
 * May the force be with you.
 * -----
 * HISTORY:
 * Date      	By	Comments
 */

class CachedImage extends StatelessWidget {
  final String? imageUrl;

  final String? assetUrl;

  final File? file;

  final double? width;

  final double? height;

  final double circular;

  final BoxFit? fit;

  final Color? imageColor;

  /// 内存图片
  final Uint8List? memory;

  final MukaCachedTheme? config;

  final String? package;

  final FilterQuality filterQuality;

  const CachedImage({
    Key? key,
    this.imageUrl,
    this.width,
    this.height,
    this.circular = 0,
    this.fit,
    this.assetUrl,
    this.imageColor,
    this.file,
    this.config,
    this.package,
    this.memory,
    this.filterQuality = FilterQuality.low,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      if (width != null && height != null) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(circular),
          child: Image(
            image: FileImage(File(file!.path), scale: 2.0),
            fit: fit,
            color: imageColor,
            filterQuality: filterQuality,
            width: width,
            height: height,
          ),
        );
      } else {
        return ClipRRect(
          borderRadius: BorderRadius.circular(circular),
          child: Image(
            image: FileImage(File(file!.path)),
            fit: fit,
            color: imageColor,
            filterQuality: filterQuality,
            width: width,
            height: height,
          ),
        );
      }
    }

    if (Utils.isNotEmpty(assetUrl)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: Image(
          image: AssetImage(assetUrl!, package: package),
          fit: fit,
          color: imageColor,
          filterQuality: filterQuality,
          width: width,
          height: height,
        ),
      );
    }

    if (memory != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: Image(
          image: MemoryImage(memory!),
          fit: fit,
          color: imageColor,
          filterQuality: filterQuality,
          width: width,
          height: height,
        ),
      );
    }
    if (Utils.isNotEmpty(imageUrl)) {
      String baseUrl = MukaConfig.config.baseUrl;

      return ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: ExtendedImage.network(
          baseUrl + imageUrl!,
          cache: true,
          filterQuality: filterQuality,
          loadStateChanged: (state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                return config?.placeholder(width: width, height: height) ?? MukaConfig.config.cachedTheme.placeholder(width: width, height: height);
              case LoadState.failed:
                return config?.errorBuilder(context, width: width, height: height) ?? MukaConfig.config.cachedTheme.errorBuilder(context, width: width, height: height);
              default:
                return ExtendedRawImage(
                  image: state.extendedImageInfo?.image,
                  width: width,
                  height: height,
                  fit: fit,
                  filterQuality: filterQuality,
                );
            }
          },
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(circular),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade200,
        highlightColor: Colors.grey.shade100,
        child: Container(width: width, height: height, color: Colors.grey),
      ),
    );
  }
}

enum CacheType {
  /// 文件
  file,

  /// 资产
  assets,

  /// 网路
  network,
}
