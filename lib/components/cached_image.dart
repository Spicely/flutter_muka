part of flutter_muka;
/*
 * Summary: 缓存图片组件
 * Created Date: 2022-06-16 23:54:28
 * Author: Spicely
 * -----
 * Last Modified: 2023-05-07 00:33:28
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
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Utils.isNotEmpty(imageUrl)) {
      String baseUrl = MukaConfig.config.baseUrl;

      CachedNetworkImageProvider img = CachedImage.getCache(context, baseUrl + imageUrl!);

      return ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: Image(
          image: img,
          width: width,
          height: height,
          loadingBuilder: (context, child, loadingProgress) => loadingProgress == null
              ? child
              : Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade100,
                  child: Container(width: width, height: height, color: Colors.grey),
                ),
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          fit: fit,
        ),
      );
    }

    if (file != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: Image.file(
          file!,
          width: width,
          height: height,
          fit: fit,
          color: imageColor,
        ),
      );
    }

    if (Utils.isNotEmpty(assetUrl)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: Image.asset(
          assetUrl!,
          width: width,
          height: height,
          fit: fit,
          color: imageColor,
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

  /// 缓存
  static Map<String, CachedNetworkImageProvider> _cache = {};

  /// 获取缓存
  static CachedNetworkImageProvider getCache(BuildContext context, String url) {
    if (_cache.containsKey(url)) {
      return _cache[url]!;
    }
    _cache[url] = CachedNetworkImageProvider(url);
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
