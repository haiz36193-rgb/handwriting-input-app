# 训练进度记录

## 当前训练配置
- 数据量: 13,065字符 × 20样本 = 261,300样本（全部数据）
- 批次大小: 32
- 训练轮数: 50
- 学习率: 0.0001
- 早停耐心值: 10

## 训练状态
- 状态: 已暂停
- 最后保存模型: best_handwriting_model_full.h5（第1轮完成后保存）
- 标签映射: label_mapping_full.json

## 下次继续训练
```bash
cd C:\Users\Administrator\handwriting-input-app\backend\src\main\resources\static\models
python train_batch.py
```

## 监控要点
- 每10分钟检查训练速度和Python进程数量
- 如果速度变慢或有多个Python进程，立即清理多余进程
- 训练完成后部署模型到 backend/models/