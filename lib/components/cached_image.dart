part of flutter_muka;
/*
 * Summary: 缓存图片组件
 * Created Date: 2022-06-16 23:54:28
 * Author: Spicely
 * -----
 * Last Modified: 2023-05-20 20:02:26
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

      var img = CachedImage.getCache(context, baseUrl + imageUrl!, CacheType.network);

      return ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: Image(
          image: ResizeImage(img, width: width?.toInt(), height: height?.toInt()),
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
      var img = CachedImage.getCache(context, file!.path, CacheType.file, package: package);
      return ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: Image(image: ResizeImage(img, width: width?.toInt(), height: height?.toInt()), fit: fit, color: imageColor),
      );
    }

    if (Utils.isNotEmpty(assetUrl)) {
      var img = CachedImage.getCache(context, assetUrl!, CacheType.assets, package: package);
      return ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: Image(image: ResizeImage(img, width: width?.toInt(), height: height?.toInt()), fit: fit, color: imageColor),
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

  /// 缓存
  static Map<String, dynamic> _cache = {};

  /// 获取缓存
  static getCache(BuildContext context, String url, CacheType type, {String? package}) {
    if (_cache.containsKey(url)) {
      return _cache[url]!;
    }

    switch (type) {
      case CacheType.file:
        _cache[url] = FileImage(File(url));
        break;
      case CacheType.assets:
        _cache[url] = AssetImage(url, package: package);
        break;
      default:
        _cache[url] = CachedNetworkImageProvider(url);
    }

    precacheImage(_cache[url]!, context);
    return _cache[url]!;
  }

  /// 移除缓存
  static removeCache(String key) {
    _cache.remove(key);
  }

  /// 清空缓存
  static clearCache() {
    _cache.clear();
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
