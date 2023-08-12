part of flutter_muka;
/*
 * Summary: 缓存图片组件
 * Created Date: 2022-06-16 23:54:28
 * Author: Spicely
 * -----
 * Last Modified: 2023-08-12 14:57:30
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

  final MukaCachedTheme? config;

  final String? package;

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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Utils.isNotEmpty(imageUrl)) {
      String baseUrl = MukaConfig.config.baseUrl;

      return ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: ExtendedImage.network(
          baseUrl + imageUrl!,
          width: width,
          height: height,
          fit: fit,
          cache: true,
          loadStateChanged: (state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                return config?.placeholder(width: width, height: height) ??
                    MukaConfig.config.cachedTheme.placeholder(width: width, height: height);
              case LoadState.failed:
                return config?.errorBuilder(context, width: width, height: height) ??
                    MukaConfig.config.cachedTheme.errorBuilder(context, width: width, height: height);
              default:
                return ExtendedRawImage(
                  image: state.extendedImageInfo?.image,
                  width: width,
                  height: height,
                  fit: fit,
                );
            }
          },
        ),
      );
    }

    if (file != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: Image(
          image: FileImage(File(file!.path)),
          fit: fit,
          color: imageColor,
          width: width,
          height: height,
        ),
      );
    }

    if (Utils.isNotEmpty(assetUrl)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: Image(
          image: AssetImage(assetUrl!, package: package),
          fit: fit,
          color: imageColor,
          width: width,
          height: height,
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
