part of muka;

/////////////////////////////////////////////////////////////////////////
//// All rights reserved.
//// author: Spicely
//// Summary: 扩展类
//// Date: 2020年07月01日 22:33:42 Wednesday
//////////////////////////////////////////////////////////////////////////

class PersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  final ListItem child;

  PersistentHeaderDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return this.child;
  }

  @override
  double get maxExtent => this.child.height;

  @override
  double get minExtent => this.child.height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
