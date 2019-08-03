#ShearLet_for_Snapshot_Compressive_Imaging

`scripts` 目录下为对不同数据集的测试脚本。

脚本中默认的参数均为真实数据集上视觉效果较好的参数或模拟数据上当前评分最高的参数。其中cacti的三组模拟数据上使用了一样的参数，因为尝试修改后性能变差。



`figure` 目录下为绘制/保存图片的脚本。

`cassi_show.m` 绘制了论文中cassi相关图像，部分未进行封装。

`flowchart.m` 是flowchart图的来源。

`save_gray.m`和`save_rgb.m`存储cacti的各帧图像，`show.m`和`show_rgb.m`加载数据后绘制图像是用来观察、对比不同算法效果的。



- 运行前将整个文件夹添加到matlab路径。

