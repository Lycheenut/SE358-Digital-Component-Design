# 实验三：五段流水线CPU设计

## 实验目的

1. 理解计算机指令流水线的协调工作原理，初步掌握流水线的设计和实现原理。
2. 深刻理解流水线寄存器在流水线实现中所起的重要作用。
3. 理解和掌握流水段的划分、设计原理及其实现方法原理。
4. 掌握运算器、寄存器堆、存储器、控制器在流水工作方式下，有别于实验二的设计和实现方法。
5. 掌握流水方式下，通过I/O端口与外部设备进行信息交互的方法。

## 实验内容

本实验的大部分代码可复用实验二：单周期CPU的设计代码，故以下仅陈述流水线部分。

五段流水线分别进行以下过程：

```mermaid
graph LR
    1(Fetch) --> 2(Decode) --> 3(Execute) --> 4(Memory) --> 5(Write back)
```

分别由设计模块`pipeif`, `pipeid`, `pipeexe`, `pipemem`, `mux2x32`来完成。

其中，Decode阶段和Execute阶段、Execute阶段和Memory阶段、Memory阶段和WB阶段之间的数据传递分别由流水线寄存器模块`pipedereg`, `pipeemreg`, `pipemwreg`实现。

为测试流水线工作情况和pipeline hazard（以data hazard为例），使用以下代码：

```S
# 检验流水线的正确性，通过LED显示
main:
    addi $1, $0, 0xc0   # in_port0
    addi $2, $0, 0xc4   # in_port1
    addi $3, $0, 0x80   # out_port0
    addi $4, $0, 0x84   # out_port1
    addi $5, $0, 0x88   # out_port2
    addi $6, $0, 0x50   # memout
loop:
    lw   $7, 0($1)      # load in_port0
    lw   $8, 0($2)      # load in_port1
    add  $9, $7, $8     # in1 + in0 => out => {out0,out1,out2}
    sw   $7, 0($3)      # out_port0
    sw   $8, 0($4)      # out_port1
    sw   $9, 0($5)      # out_port2
    j    loop
```

```S
# data hazard
add  $1,  $2,  $3  #  [R1] <- [R2] +  [R3]
sub  $4,  $1,  $5  #  [R4] <- [R1] -  [R5]
and  $6,  $1,  $7  #  [R6] <- [R1] &  [R7]
or   $8,  $1,  $9  #  [R8] <- [R1] |  [R9]
xor  $10, $1,  $11 # [R10] <- [R1] ^ [R11]
```

上述程序中，第一行的add语句执行完WB阶段前，第2~5行的代码都无法从寄存器1中读取数据，故需插入bubble。
