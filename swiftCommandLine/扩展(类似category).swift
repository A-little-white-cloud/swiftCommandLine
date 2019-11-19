//
//  扩展(类似category).swift
//  swiftCommandLine
//
//  Created by coder on 2019/10/8.
//  Copyright © 2019 coder. All rights reserved.
//

import Foundation
/*
 1.可以为结构体 类 枚举 协议 添加新功能
 2.方法 计算属性 下标 初始化器 嵌套类型 协议等等
 3.不能添加存储属性（这样会破坏内存结构） 不能覆盖原有的功能(oc是允许覆盖的 其实也不算是覆盖 是先调用分类的方法而已)
 */

extension Double{
    var m:Double {
        return self
    }
    var km:Double {
        return self/1000.0
    }
}

extension Array{
    
    subscript(index:Int)->Element?{
        
        if (0..<endIndex).contains(index){
            
            return self[index]
        }
        return nil
    }
    
}
///给类扩展协议
class advanceCateGory{}
extension advanceCateGory:Equatable{
    static func == (lhs: advanceCateGory, rhs: advanceCateGory) -> Bool {
        return true
    }
}

///结构体扩张初始化器不会覆盖以前的（本身结构体里面如果你自定义初始化器的话 系统自己生成的几个就不会自动生成了，但是extension里面不一样 不会被覆盖）
///如果是类的扩展 只能定义便携式初始化器
struct advanceCateGory_s {
    var a:Int = 0
    var b:Int = 0
}
extension advanceCateGory_s{
    
        init( Avalue a:Int, Bvalue b:Int) {
            self.a = a
            self.b = b
        }
}
///协议扩展方法（和协议本身不一样，因为协议是没有实现的 这里扩展是直接提供了默认实现了）  BinaryInteger是所有整数都遵守的一个协议
//扩展可以增加协议的默认实现    如果有默认实现 遵守协议的类里面就不是必须实现该协议方法了
//利用协议扩展。可实现类似于OC的option协议
extension BinaryInteger{
    
    func isOdd() -> Bool {
        return self % 2 == 0
    }
}


func MainCategory() {
    
    let distance = 100.0
    print(distance.km,distance.m)
    ///结构体添加构造函数 本身的不会被覆盖 （只有类才有 便捷初始化器 指定初始化器）
    _ = advanceCateGory_s(a: 100, b: 200)
    _ = advanceCateGory_s(Avalue: 100, Bvalue: 200)
    ///协议增加方法
    print(3.isOdd() ? "偶数" : "基数")
}
class HJCategory {
    init() {
        print("/*****************************************HJCategory*****************************************/")
        MainCategory()
    }
}
