# 笔迹特征提取模型训练指南

## 📋 概述

本目录包含用于训练手写输入法特征提取深度学习模型的所有脚本和配置。

## 🎯 模型架构

**CNN + RNN 混合架构**
- **CNN部分**: 提取局部笔画特征
- **RNN部分**: 捕捉笔画序列的时间依赖性
- **输出**: 256维特征向量

## 📁 文件说明

| 文件 | 说明 |
|------|------|
| `model_architecture.py` | 模型架构定义 |
| `train_model.py` | 训练脚本 |
| `data_processor.py` | 数据处理脚本 |
| `config.json` | 训练配置文件 |
| `train.bat` | Windows一键训练脚本 |

## 🚀 快速开始

### 步骤1: 安装Python环境

运行桌面上的批处理脚本：
```
桌面\安装Python深度学习环境.bat
```

该脚本会自动安装：
- Python 3.8+
- TensorFlow
- NumPy, SciPy, Matplotlib
- scikit-learn
- tqdm, TensorBoard, h5py

### 步骤2: 运行训练脚本

方法A - 使用批处理脚本（推荐）
```
双击 train.bat
```

方法B - 手动运行
```bash
cd backend\src\main\resources\static\models
python train_model.py
```

### 步骤3: 部署模型

训练完成后，将生成的模型文件复制到指定位置：
```bash
copy feature-model.h5 ..\..\..\..\..\..\..\models\
```

然后重启后端服务。

## ⚙️ 配置说明

编辑 `config.json` 文件可以调整训练参数：

```json
{
  "input_shape": [128, 128, 3],      // 输入图像大小
  "num_classes": 100,                 // 分类类别数
  "epochs": 50,                       // 训练轮数
  "batch_size": 32,                   // 批次大小
  "learning_rate": 0.001,             // 学习率
  "validation_split": 0.2,            // 验证集比例
  "model_path": "feature-model.h5",   // 模型保存路径
  "data_path": "training_data/"       // 训练数据路径
}
```

## 📊 训练数据

### 使用真实数据集（推荐）

1. 将手写图像放入 `training_data/` 目录
2. 创建 `training_data/labels.json` 标签文件

标签文件格式：
```json
[0, 1, 2, ..., 99]
```

### 使用合成数据（演示）

如果没有真实数据集，脚本会自动生成合成数据用于演示。

**注意**: 合成数据仅用于测试，训练出的模型性能较差。

## 💡 高级功能

### 数据增强

脚本支持以下数据增强：
- 随机旋转 (-10° 到 10°)
- 随机缩放 (0.9x 到 1.1x)
- 随机噪声

### 训练监控

使用TensorBoard监控训练过程：
```bash
tensorboard --logdir=./logs
```

然后在浏览器打开：http://localhost:6006

### 模型优化

如果需要更快的训练速度，可以使用轻量级模型：
```python
from model_architecture import create_lightweight_model
model = create_lightweight_model()
```

## 🔧 故障排除

### 问题1: Python未安装

**错误**: `'python' 不是内部或外部命令`

**解决**: 运行 `桌面\安装Python深度学习环境.bat`

### 问题2: TensorFlow安装失败

**错误**: `Could not find a version that satisfies the requirement tensorflow`

**解决**: 
1. 确保网络连接正常
2. 尝试使用国内镜像：
   ```bash
   pip install tensorflow -i https://pypi.tuna.tsinghua.edu.cn/simple
   ```

### 问题3: 训练过程中内存不足

**错误**: `ResourceExhaustedError`

**解决**:
1. 减小 `batch_size`（例如改为 16 或 8）
2. 使用轻量级模型
3. 减小 `input_shape`

### 问题4: 训练速度慢

**建议**:
1. 启用GPU加速（安装CUDA和cuDNN）
2. 减少训练轮数
3. 使用更小的模型

## 📈 预期结果

### 训练时间（参考）

| 硬件配置 | 训练时间 |
|----------|----------|
| CPU (i5) | 2-3 小时 |
| CPU (i7) | 1-2 小时 |
| GPU (GTX 1060) | 15-30 分钟 |
| GPU (RTX 3060) | 10-15 分钟 |

### 模型性能

使用合成数据训练的模型仅用于演示，实际使用需要：

1. 收集真实手写数据（建议 1000+ 样本）
2. 标注数据
3. 使用完整数据集训练

真实数据集预期准确率：85-95%

## 📚 参考资料

- TensorFlow文档: https://www.tensorflow.org/guide
- Keras文档: https://keras.io/guides/
- IAM手写数据库: http://www.fki.inf.unibe.ch/databases/iam-handwriting-database

## 📞 支持

如有问题，请查看：
1. 训练日志输出
2. TensorBoard可视化
3. 项目文档

---

**版本**: 1.0.0  
**最后更新**: 2026-02-02  
**开发者**: 个性化手写输入法项目组