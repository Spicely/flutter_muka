# muka

Flutter样式组件

## 引入方式

```
    muka:
      git: https://github.com/Spicely/flutter-muka.git
```

### Empty
```
    /// 全局样式
    Empty.GLOBAL_EMPTY_DATA_URL = 'assets/images/empty.png';
    Empty.GLOBAL_NOT_NETWORK_URL = 'assets/images/empty.png';
    Empty.WIDTH = 240;

    Empty(
        initLoad: _getData,
        /// 覆盖全局
        empty: Text('无数据'),
        /// 覆盖全局
        network: Text('无网络'),
        child: Text('111'),
    );
```