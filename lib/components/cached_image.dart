part of flutter_muka;
/*
 * Summary: 缓存图片组件
 * Created Date: 2022-06-16 23:54:28
 * Author: Spicely
 * -----
<<<<<<< HEAD
 * Last Modified: 2023-06-01 16:55:05
=======
 * Last Modified: 2023-05-30 01:31:22
>>>>>>> parent of 3acadae (修复bug)
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

      var img = CachedImage.getImage(context, baseUrl + imageUrl!, CacheType.network);

      return ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: Image(
          image: img,
          width: width,
          height: height,
          loadingBuilder: (context, child, loadingProgress) => loadingProgress == null
              ? child
              : config?.placeholder(width: width, height: height) ??
                  MukaConfig.config.cachedTheme.placeholder(width: width, height: height),
          errorBuilder: (context, obj, stackTrace) {
            return config?.errorBuilder(context, obj, stackTrace, width: width, height: height) ??
                MukaConfig.config.cachedTheme.errorBuilder(context, obj, stackTrace, width: width, height: height);
          },
          fit: fit,
        ),
      );
    }

    if (file != null) {
      var img = CachedImage.getImage(context, file!.path, CacheType.file, package: package);
      return ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: Image(
          image: img,
          fit: fit,
          color: imageColor,
          width: width,
          height: height,
        ),
      );
    }

    if (Utils.isNotEmpty(assetUrl)) {
      var img = CachedImage.getImage(context, assetUrl!, CacheType.assets, package: package);
      return ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: Image(
          image: img,
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

  /// 获取缓存
  static getImage(BuildContext context, String url, CacheType type, {String? package}) {
    ImageProvider<Object> img;
    switch (type) {
      case CacheType.file:
        img = FileImage(File(url));
        break;
      case CacheType.assets:
        img = AssetImage(url, package: package);
        break;
      default:
        img = CachedNetworkImageProvider(url);
    }
    return img;
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
