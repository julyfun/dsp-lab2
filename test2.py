import matplotlib.pyplot as plt

# 示例数据
x = 3.5
y = 2.4

# 绘制实线
plt.plot(x, y, marker='o', color='red', label='(3.5, 2.4)')

# 绘制点的投影到 x 轴的虚线
plt.plot([x, x], [0, y], '--', color='gray')

# 绘制点的投影到 y 轴的虚线
plt.plot([0, x], [y, y], '--', color='gray')

# 添加标签
plt.annotate('(3.5, 2.4)', xy=(x, y), xytext=(x + 0.1, y + 0.1), color='red')

# 设置坐标轴范围
plt.xlim(0, 4)
plt.ylim(0, 3)

# 显示图形
plt.xlabel('X')
plt.ylabel('Y')
plt.title('Point Projection to X and Y Axes')
plt.legend()
plt.grid(True)
plt.show()
