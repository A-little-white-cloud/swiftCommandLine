//
//  枚举.swift
//  swiftCommandLine
//
//  Created by coder on 2019/9/26.
//  Copyright © 2019 coder. All rights reserved.
//

import Foundation
/*OC和c++的枚举*/
/*
 typedef NS_ENUM(int,stu){
 stu_ns,
 stu_ns1
 };
 
 typedef NS_OPTIONS(int, sss){
 sss_ns,
 };
 
 typedef enum stu111{
 stu1_ns,
 stu1_ns1
 }student;
 
 enum stu{
 
 stu1_ns,
 stu1_ns1
 }
 */

enum Season {
    case spring
    case summer
    case autumn
    case winter
}

enum Color{
    case red(depp:Int)
    case green(depp:Int)
    case yellow(depp:Int)
}
/*这个Int表示的就是关联值只能是Int*/
enum Color1 : Int{
    case red = 1
    case green = 2
    case yellow = 3
}
/*枚举里面用到了自己 递归枚举*/
indirect enum Color2 {
    
    case red(co:Color2)
    case green
    case yellow
}
/**************************************枚举MemoryLayout*******************************************/
/*
 枚举的内存对齐都不一样alignment,
 string占用16个字节
 int = int64 占8个字节
 */
var age = 10;
//原始值
enum CorlorInt{
    
    case red1, yellow1
}
enum CorlorStr:String{
    
    case red2, yellow2
}
//关联值
enum CorlorConnect{
    
    case red(_:Int)
    case yellow(_ :Int)
}


/*
 关联值
 关联值是把传进来的值存到枚举里面
 
 原始值 有点像共用体
 原始值的具体值是不会存到枚举内存中的 内部是给这个枚举编号 所以只占1个字节 (那这些关联对象的内存存在哪呢)
 实际上Swift仍然使用整型值来管理原始值的 不管你默认写了什么都会变成0，1，2，3，4 原始值只是一个符号
 */

//这就证明了原始值并不是存在枚举的内存里面（有可能不用存存储）
func rawValueEX(origin:Int)-> String{
    if origin == 0
    {
        return "red2"
        
    }
    if origin == 1
    {
        return "Yellow2"
        
    }
    return ""
}
/**************************************元组*******************************************/
/*:
 /// 元组
 1.可以有多个成员
 2.类型可以不一样
 3.通过下标或者标签可以找到对应的元素
 */
func tuple(){
    
    let http404 = ("http",404);
    let http4041 = (name:"http",code:4041);
    let http4042 = ([1,2],["age" : 1]);
    
    print(http404,http404.0,http404.1,http4041.name,http4041.code,http404,http4042);
}


/*
 枚举 枚举关联值
 如果枚举的原始值是Int,String swift会自动分配原始值
 string 就是关联你的case的名字
 int 就是从0开始
 */
func Enum(){
    
    var season:Season = .spring;
    season = Season.autumn;
    
    let corlor:Color = Color.red(depp:100);
    print(corlor);
    
    let corlor1:Color1 = .red;
    
    print(season);
    print(corlor1);

    switch corlor {
    case .red(let h) where h == 100:
        print("颜色深度",h);
        break;
    case .green:
        break;
    default:
        break;
    }
    
    
   /*
    窥探枚举的内存
    */
    let cor:CorlorConnect = .red(1);
    let cor1:CorlorInt = .red1;
    let cor2:CorlorStr = .red2;
    //分配占用的空间大小
    print("Int所占字节",MemoryLayout<Int>.size)
    //实际用到的空间大小
    print("Int所占字节",MemoryLayout<Int>.stride)
    //对齐参数
    print("Int所占字节",MemoryLayout<Int>.alignment)
    
    print(MemoryLayout.stride(ofValue: age)) //8
    print(MemoryLayout.stride(ofValue: cor)) //16
    print(MemoryLayout.stride(ofValue: cor1)) //1
    print(MemoryLayout.stride(ofValue: cor2)) //1
    //关联值
    //每个成员的hash值
    //枚举里面接受参数绑定关联值的就没有hashValue
    print(MemoryLayout.stride(ofValue: cor2.rawValue))
}


/// 入口
class Enum_tuple{
    
    init() {
        print("/************************Enum_tuple*********************************/")
        tuple()
        Enum();
    }
    
}



