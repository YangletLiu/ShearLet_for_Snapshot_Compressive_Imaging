### 随机投影方法

- `random_test.m` 是程序的主文件，在其中调用了`random_projection.m` 或 `random_projection_without_optimization.m` 进行随机投影。使用`bTest` 控制使用哪个随机投影矩阵的生成方法，使用`codedNum` 控制恢复的帧数。
- `random_projection.m` 是优化后的随机投影方法，返回重建的视频。该文件主要是优化了内存问题，但是运行速度比起未处理内存问题的版本要慢。调用了`generate.m` 生成随机投影矩阵。
- `random_projection_without_optimization.m` 运行速度快，但是可运算的块的面积32×32左右。这里还保留了之前做的使用完全随机产生的投影矩阵的方法，通过`bTest` 控制。`bTest` 为 `True` 时，调用`generate_test.m` ，`bTest` 为 `False` 时 `generate_without_optimization.m` 生成随机投影矩阵。
- `generate_test.m` 是生成完全随机产生的投影矩阵的方法，返回随机投影矩阵$\Phi$和投影后的向量$y$。
- `generate.m` 是优化后的生成SCI投影矩阵的方法。调用了`kronv.m` 仿照Kronecker积，计算两行相乘的结果，用于构造傅里叶变换域的基。
- `generate_without_optimization.m`  是未经优化的生成SCI投影矩阵的方法。
- `map2vec.m` 和`kronv.m` 都是工具函数。`map2vec.m` 用于将SCI的mask中被挑选出的tube映射到投影矩阵中。