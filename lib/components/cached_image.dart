/*
 * Summary: 文件描述
 * Created Date: 2022-06-16 23:54:28
 * Author: Spicely
 * -----
 * Last Modified: 2022-07-30 20:49:54
 * Modified By: Spicely
 * -----
 * Copyright (c) 2022 Spicely Inc.
 * 
 * May the force be with you.
 * -----
 * HISTORY:
 * Date      	By	Comments
 */
part of flutter_muka;

class CachedImage extends StatelessWidget {
  final String? imageUrl;
  final String? assetUrl;

  final double? width;
  final double? height;
  final double circular;

  final BoxFit? fit;

  const CachedImage({
    Key? key,
    this.imageUrl,
    this.width,
    this.height,
    this.circular = 0,
    this.fit,
    this.assetUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          width: width,
          height: height,
          placeholder: (context, url) => Shimmer.fromColors(
            baseColor: Colors.grey.shade200,
            highlightColor: Colors.grey.shade100,
            child: Container(width: width, height: height, color: Colors.grey),
          ),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: fit,
        ),
      );
    }
    if (assetUrl != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(circular),
        child: Image.asset(
          assetUrl!,
          width: width,
          height: height,
          fit: fit,
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
