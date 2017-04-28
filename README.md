# hzip
压缩算法操作文档
操作系统：ubuntu 14.04
编译器要求：g++4.8及以上.
一 软件安装
1.1	依赖库SAc的安装
1)	下载地址：http://pizzachili.dcc.uchile.cl/indexes/Suffix_Array/
2)	安装要求：支持C++11的编译器，比如g++4.9。
3)	安装：
根据网址下载Sac.tgz库文件，然后进行如下命令操作：
1.	mkdir Sac               //创建文件加存放解压数据
2.	cp Sac.tgz ./Sac          //将压缩包拷贝到文件夹
3.	cd SAc
4.	.tar zxvf SAc.tgz Sac.tgz   //解压库文件
5.	cd ds
6.	make                   //编译库文件
7.	copy ds_ssort.a /home/**/hzip/  //将编译生成的库拷贝到压缩软件中
注：在make之前，编译库是会出现‘CLK_TCK’未定义的错误，可以使用vim编辑器打开suftest2.c文件，在文件中添加#define CLK_TCK 1000，在其他库中查询知道CLK_TCK的值一般为1000，该值对我们使用库获取SA以及进行BWT变换无影响。添加完成后保存退出vim再进行make操作。
1.2	hzip数据压缩软件的编译
1)	下载地址：https://github.com/baiwenwu/hzip
2)	编译：
在终端中运行以下命令：
1.	git clone https://github.com/baiwenwu/hzip
2.	cd hzip
3.	sudo apt-get install libc6-dev-i386
4.	sudo apt-get install libc6-dev
5.	sudo apt-get install gcc-multilib
6.	make
注：在make之前，需要确认libds_ssort.a(ds_ssort.a)库是否拷贝进入hzip文档中，因为该库必须是使用32位系统，故需要3-5行命令执行配置环境，不然直接make会报一系列错误。
二 压缩软件使用
1.	将测试数据集拷贝到/doc目录下
2.	生成测试用例
目录下gen_test.py为自动生成/doc目录下测试用例的脚本，运行方法为：
./hzip –c -b 9 –e 3 data  \\压缩数据data
./hzip –d data.wz       \\解压数据data.wz
参数说明：
		-b 后面值取1-20，表示数据切块大小为为100000B到2000000B，一般使用格式是(-b  n)其中为具体取值1-20。 
-c 表示执行压缩过程
	-d 表示执行解压过程
	-e 表示选择小波树树形，1：HUFFMASN 2：BALANCE 3：HU-TUCKER，使用格式(-e  n)其中n具体取值1-3
	-g 表示位向量编码方式，1：run-length gamma 2:run-length delta 3:hybird
	-f 表示生成文件存在时，是否重写，1：重写 0：不重写
	-k 表示是否产出输入文件，1：删除 0：保留
	-h 表示打印出操作文档，供使用者使用
	-p 表示程序执行时需要几个线程来执行，取值范围1-4
	-v 表示显示程序执行信息，如时间、数据压缩率等
注：程序make执行完后会生成可执行文件hzip，使用是使用./hzip 后面加上参数，最后面一项为需要处理的数据路径和数据名称。压缩过程需要加上-c参数，解压过程加上-d参数，其他参数可以选择性添加。程序中都具有默认值，如数据分块大小为900000B，树型默认为HU-TUCKER类型，位向量编码为HYBIRD编码等。
三 补充说明
该压缩软件使用的库为pizzachili中提供的标准库，但只能在32位机器下编译，所以安装过程中需要对环境进行设置，不然编译会出错。我们在下面提供其可以使用的64位库地址和其使用方法。
3.1依赖库libdivsufsort的安装
1)	地址：https://github.com/elventear/libdivsufsort 
2)	安装要求：支持C++11的编译器，比如g++4.9。cmake进行编译安装。
3)	安装：
根据网址下载libdivsufsort库文件，然后进行如下命令操作：
1	cd libdivsufsort
2	mkdir build 
3	cmake -DCMAKE_BUILD_TYPE="Release" -DCMAKE_INSTALL_PREFIX="/usr/local"
4	cd build
5	.make
6	make install
7	cd lib
8	cp libdivsufsort.so* /home/**/hzip/
注：下载完成库之后，根据libdivsufsort文件中提供的install文件安装配置libdivsufsort库，第3行执行后会在build文件中生成一系列文件，其中包括makefile文件，然后进入build文件直接执行make，在huild文件中的lib文件下会生成我们需要库文件并将其拷贝到hzip文件夹下，完成后将libdivsufsort库文件下的include文件拷贝到hzip文件夹下面。
3.2算法中需要做出的修改 
将hzip文件夹下面引用#include "blocksort.h"的.c和.h文件进行修改，把#include "blocksort.h"改变成#include "./include/divsufsort.h"。
将global.cpp中求取SA的函数以及BWT变换的函数接口用libdivsufsort库中提供的同样功能的函数接口替换即可，替换时注意参数个数以及参数类型。
将Makefile文件中对于库函数的引用进行修改，将原来的-L. -lds_ssort替换成-L. –ldivsufsort，完成后即可直接执行make，使用压缩软件。

