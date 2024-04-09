"""
用法：你需要先在 ipynb 代码块的每道题代码最前面一行添加注释如下

# [x.y]

其中 x 为大题号，y 为小题号。
然后命令行输入：

python ext.py t1.ipynb t2.ipynb t3.ipynb t4.ipynb > 1.txt 

这样就可以把 ipynb 转为 typst 标题加代码块了，转换结果在 1.txt 中
"""
import sys
import nbformat

num = -1


def extract_and_process_python_code_from_ipynb(ipynb_path):
    """
    some code by chatgpt
    """
    global num
    # 读取 ipynb 文件
    with open(ipynb_path, "r") as f:
        nb_content = nbformat.read(f, as_version=4)

    # 初始化一个空列表，用于存储处理后的 Python 代码单元格
    processed_python_code_cells = []

    # 遍历每个单元格
    for cell in nb_content.cells:
        if cell.cell_type == "code":
            # 提取代码单元格中的 Python 代码
            python_code = cell.source

            # 检查是否以 #[x.y] 开头
            if python_code.strip() != '':
                if python_code.startswith("# ["):
                    # 提取 x.y
                    tag = python_code.split("[")[1].split("]")[0]
                    if int(tag[0]) > num:
                        num = int(tag[0])
                        processed_python_code_cells.append(
                            f"== Problem {num}\n")
                    processed_python_code_cells.append(
                        f"=== Code for {tag}\n")
                processed_python_code_cells.append(
                    f"```python\n{python_code}\n```\n")

    return processed_python_code_cells


# 设置 ipynb 文件的路径
for arg in sys.argv[1:]:
    print(arg, file=sys.stderr)
    ipynb_file_path = arg
    # 从 ipynb 文件中提取 Python 代码
    python_code_list = extract_and_process_python_code_from_ipynb(
        ipynb_file_path)
    # 打印提取的 Python 代码
    for i, code in enumerate(python_code_list, start=1):
        print(f"{code}")
