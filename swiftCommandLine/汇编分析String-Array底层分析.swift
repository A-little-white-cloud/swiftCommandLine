//
//  汇编分析String-Array底层分析.swift
//  swiftCommandLine
//
//  Created by coder on 2019/10/6.
//  Copyright © 2019 coder. All rights reserved.
//

import Foundation
/**
 mac-0 文件的偏移在这上面的表示其实就是 0x100000000 + 偏移量   可以在mac-o文件中查看_cstring 字面量（常量区） 全局区
 可以在汇编中的malloc中打断点判断变量是否是在堆空间。然后bt查看函数调用栈
 先将mach-o文件加载进内存。在看mach-o依赖什么动态库 运行过程中（启动后）再将动态库载入内存
 dyld_stub_blinder 库的作用:
                        1.用来做符号绑定动态库
                        2.比如说动态库的 call 0x1232132131 String_init 这里的地址是个假地址（因为动态库是动态加载的，所以地址是不确定的）
                        3.执行这个最后其实跳到dyld_stub_blinder 找到真实的地址然后初始化
                        4.动态库是用的时候在加载。比如说第一次用String_init会把真实地址放到mach-o的data区。下次再调用的话就不用再一步步寻找绑定了
 */
func mainFunc() {
    /*
     string:
     16个字节
     0123456789直接变成asc码放在了str2的内存中了
     str1: 0x3736353433323130   0xea00000000003938
     str2: 0x4847464544434241   0xee004d4c4b4a494a(很像OC的tagpoint)
     e可以认为是类型标示a是长度 3938373635....这些事0...9的asc码值 剩下15个字节是存储内容的
     如果字符长度超过16个字节存储范围 变量就会存储常量区的地址
     str1在常量区（其实mach-o文件载入内存 可以理解把这些代码生成的二进制直接搬到运行内存中  那一块内存有代码区-常量区-全局区,mach-o肯定能找到这些数据）
     前面的0xd00000000 这种0xd一般都是标志位。就是到时候碰见这个执行对应的指令
     */
    var str1:String = "0123456789"
    var str2:String = "ABCDEFGHJIJKLM"//常量区有，且str2变量中也有
    var str3:String = "ABCDEFGHJIJKLMLLLLLLLLLLLLLLLLLL"//str3后8个字节 - 0x7fffffffffffffe0 = str3的真实地址
    print("str3里面存储的内容:",Mems.memStr(ofVal: &str3))
    str3.append("k")//这str3就保存的是堆区的地址了(如果不满15个字节 就只接拼接在变量里面)【常量区是不允许修改的。在编译的时候就确定了】
    print("str1里面存储的内容:",Mems.memStr(ofVal: &str1))
    print("str2里面存储的内容:",Mems.memStr(ofVal: &str2))
    print("str3里面存储的内容:",Mems.memStr(ofVal: &str3))
    
    
    
    
    /**
     array:
     1.一个array占用多少内存？   8个字节（存放地址）
     2.数组里面的数据放在哪？     堆区
     3.是值类型，其实内部实现其实跟指针没啥区别
     */
    
    var arr:Array = Array<Int>() //zh
    var arr1:Array = [1,2,3,4] //里面的值放在堆区
    
    print("arr:",Mems.memStr(ofVal: &arr),Mems.size(ofRef: arr),Mems.size(ofVal: &arr))
    print("arr1:",Mems.memStr(ofVal: &arr1),Mems.size(ofRef: arr1),Mems.size(ofVal: &arr1))
    struct testArrMes{
        var arr = [1,2,3,4,5]
        
    }
    print(MemoryLayout<testArrMes>.size);
    
}

class HJAnalysisArrayString {
    
    init() {
        /*****************************************HJAnalysisArrayString*****************************************/
        mainFunc()
    }
}
