# EmptyView - Swift
### 空白页面：
### 当页面数据为空时，或者网络加载失败时，一般为了友好体验，会放置一个空白提示页。
## 预览
<img src="dome1.png" width="30%"></img><img src="dome2.png" width="30%"></img>
## 功能
+ EmptyVew控件主要是提供一个可配置的视图，其包含一个imageView、两个Label及一个Button。
+ 可以根据实际需要配置视图，最多可以显示一个图片、一个标题、一个描述、一个交互按钮。
+ EmptyVew视图会根据是否有内容自动显示或隐藏相应控件，并保持整体上下左右居中，同时还可以设置每个控件的上下间距，或整体的上下偏移距离。
+ 空白页通过一个View实现很灵活。你可以把它添加到viewController.view上，也可以添加到TableView\CollectionView上，或者Cell上。总之你可以把它添加到任何View上面。

