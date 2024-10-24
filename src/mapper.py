#!/usr/bin/env python3
import sys

# 输入来自标准输入(STDIN)
for line in sys.stdin:
    # 移除行首尾的空白
    line = line.strip()
    # 分割单词
    words = line.split()
    # 输出每个单词的计数
    for word in words:
        print(f'{word}\t1')
