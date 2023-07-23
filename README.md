# **组合计算机**

## 目标

### 用基础芯片搭建一台可以编程的计算机。

- 第一阶段：能通过烧写*EEPROM*来编程，具有条件跳转
- 第二阶段：添加SPI、UART、IIC，能在SPI上挂载SD卡
- 第三阶段：添加显卡、显示屏、键盘鼠标
- 第四阶段：添加网络，能通过TCP发送信息

### 基础芯片的最高层次是*SRAM*芯片

## 结构

### 组成部分当如下

- 计数器PC

- 寄存器A、B、C

- 加法减法器ALU

- 储存器IROM、DROM

- 随机地址储存器RAM

- 阻塞器Block

- 解码器&控制器Decoder

- SPI总线控制

  初步决定，指令宽度为16，其中指令长度为5，地址长度为11。如：RAMTA11‘b0000_1000_101,其中**RAMTA**为指令，**11‘b0000_1000_101**为RAM地址。（地址长度可以斟酌，因为后期加长度拓展很难，而设计上加长度比较简单，虽然RAM芯片地址位可能不够）

数据宽度为16.

假设所有储存器类芯片数据口为8b，那么RAM至少要有11条地址线（两块），IROM至少16位地址线（两块），DROM需要11条地址线（两块）

## 控制线

RA:	RAIn

RB:	RBIn

RC:	RCIn 	RCOut(block)

IP(AO):	IPIn

ALU: PlusOut(block)	SubOut(block)	ZeroSet

PC:	PCpp	PCWrite

---

RAM:	RAMDWrite	RAMDRead(block)	

DROM(AO):	DROMDRead(block)	

----

SPI:	SPIAddrIn	SPIDWrite	SPIDRead

---

*MSB* **|**SPIAddrIn**|**SPIDWrite**|**SPIDRead**|**DROMDataRead**|**RAMDWrite**|**RAMDRead**|**PCpp**|**PCWrite**|**PlusOut**|**SubOut**|**ZeroSet**|**IPIn**|**RCIn**|**RCOut**|**RBIn**|**RAIn**|** *LSB*

## 指令集

DROMTA 		|	_	IPIn	|	DROMDRead	RAIn,PCpp	|

DROMTB 		|	_	IPIn	|	DROMDRead	RBIn,PCpp	|

DROMTC 		|	_	IPIn	|	DROMDRead	RBIn,PCpp	|

---

RAMTA  		|	_	IPIn	|	RAMDRead	RAIn,PCpp	|

RAMTB 	 	|	_	IPIn	|	RAMDRead	RBIn,PCpp	|

RAMTC	  	|	_	IPIn	|	RAMDRead	RCIn,PCpp	|

---

///ATRAM 		 |	_	IPIn	|	RAOut	RAMDWrite,PCpp	|

///BTRAM 		 |	_	IPIn	|	RBOut	RAMDWrite,PCpp	|

CTRAM 		 |	_	IPIn	|	RCOut	RAMDWrite,PCpp	|

---

JUMPTC(==0) 	|	_	IPIn	|	RCOut,ZeroSet=0	PCIn	|

JUMPTC(!=0)	 |	_	IPIn	|	RCOut,ZeroSet=1	PCIn	|

---

PLUSTRAM 		|	_	IPIn	|	PlusOut	RAMDIn	|

SUBTRAM		  |	_	IPIn	|	SubOut	 RAMDIn	|

---

SPIADDRSET 		|	_	IPIn	|	RAMDOut	SPIAddrIn	|

RAMTSPI 		   |	_	IPIn	|	RAMDRead	SPIDataWrite	|

SPITRAM 		   |	_	IPIn	|	SPIDataRead	RAMDWrite	|

---

*MSB* **|**SPIAddrIn**|**SPIDWrite**|**SPIDRead**|**DROMDRead**|/|**RAMDWrite**|**RAMDRead**|**PCpp**|**PCWrite**|/|**PlusOut**|**SubOut**|**ZeroSet**|**IPIn**|/|**RCIn**|**RCOut**|**RBIn**|**RAIn**|** *LSB*

## 指令对应控制线

### 	

```verilog
指令			   posedge		negedge			          posedge			         negedge	    
DROMTA			16'b0		 16'b0000_0000_0001_0000   16'b0001_0000_0000_0000    16'b0000_0000_0000_0001
DROMTB			16'b0		 16'b0000_0000_0001_0000   16'b0001_0000_0000_0000    16'b0000_0000_0000_0010
DROMTC			16'b0		 16'b0000_0000_0001_0000   16'b0001_0000_0000_0000    16'b0000_0000_0000_0100
RAMTA			16'b0		 16'b0000_0000_0001_0000   16'b0000_0100_0000_0000    16'b0000_0000_0000_0001
RAMTB			16'b0		 16'b0000_0000_0001_0000   16'b0000_0100_0000_0000    16'b0000_0000_0000_0010
RAMTC			16'b0		 16'b0000_0000_0001_0000   16'b0000_0100_0000_0000    16'b0000_0000_0000_0100
CTRAM			16'b0		 16'b0000_0000_0001_0000   16'b0000_0000_0000_0100    16'b0000_1000_0000_0000
JUMPTC(==0)		16'b0		 16'b0000_0000_0001_0000   16'b0000_0000_0000_0100    16'b0000_0001_0000_0000
JUMPTC(!=0)		16'b0		 16'b0000_0000_0001_0000   16'b0000_0000_0010_0100    16'b0000_0001_0000_0000
PLUSTRAM		16'b0		 16'b0000_0000_0001_0000   16'b0000_0000_1000_0000    16'b0000_1000_0000_0000
SUBTRAM	 		16'b0		 16'b0000_0000_0001_0000   16'b0000_0000_0100_0000    16'b0000_1000_0000_0000
SPIADDRSET		16'b0		 16'b0000_0000_0001_0000   16'b0000_0100_0000_0000    16'b0000_0000_0000_0001
```



## 芯片选型

寄存器：

ROM：			28C16//39VF3201							   ？

RAM：			HM628128B//XM8A51216 					2

三态收发：

时钟：

全加器：

与门：

或门：

非门：

异或门：

计数器：



## PCB设计

### 第一层

DROM IROM RAM DECODER IP

### 第二层

PC RA RB RC ALU SPIconnector

#### 连接线

BUS(RAM->BUS DROM->BUS):16

ctrl_line(DROMDRead,RAMDRead,RAMDWrite)
