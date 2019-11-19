//
//  高级运算符.swift
//  swiftCommandLine
//
//  Created by coder on 2019/10/7.
//  Copyright © 2019 coder. All rights reserved.
//

import Foundation


precedencegroup jiehexing{
    ///结合性(left right none)  a+b+c两个+号写一起就是结合性
    associativity: left
    ///比谁的优先级高
    higherThan: AdditionPrecedence
    ///比谁的优先级低
    lowerThan:MultiplicationPrecedence
    ///代表在可选链操作中拥有跟赋值运算符一样的优先级 people1ex？ = people()    +-如果people1ex==nil 就不会执行后面的对象的生成   这个属性就是这个意思
    assignment:true
}
    

infix operator ++* : jiehexing
func ++*(_ pram1:  Int,_ pram2: Int) -> Int {
    
     return (pram1 + pram2) + (pram1 * pram2)
}

class people1:Equatable ,Comparable{
    static func < (lhs: people1, rhs: people1) -> Bool {
        
        return lhs.age < rhs.age
    }
    
    var age = 10

    static func == (lhs: people1, rhs: people1) -> Bool {
        
        return lhs.age == rhs.age
    }
   
    init(_ age:Int) {
        self.age = age
    }
    

}
struct people:Equatable{
    
    var age = 10
    
    static func +( p1:people , p2:people)-> people{  //不写代表中缀
        
        var peo = people()
        peo.age = p1.age + p2.age
        return peo
    }
    
    static prefix func -(p1:people)->people{   //prefix 代表符号作为前缀  postfix 后缀 infix 中缀
        
        var peo = people()
        peo.age = p1.age + 1
        return peo
    }
}
/*
 &+ &-  &* 溢出运算符  超出的值就会倒回去
 运算符重载（和c++一样 c++需要关键字opretor）
 1.判断对象相等 需要遵守Equatable协议 然后重载==
 2.判断结构体相等 只需要遵守Equatable协议 前提是成员属性类型遵守了Equatable协议  如果成员类型有不遵守的话需要自己定义 ==
 4.枚举类型如果没有关联类型 默认支持 == 不用遵守协议。  如果有关联值就需要遵守协议  需不需要重写== 看关联类型有没有遵守Equatable
 3.遵守Equatable协议 实现了== 其实Equatable协议内部帮你实现了!=
 4.=== !=== 判断指针里面存的地址是否一样，只适用引用类型
 5.比较大小。遵守Comparable协议。如果是bool的话 只要实现一个<运算符协议它内部会帮你把其余的都实现了  但是如果i比较复杂你就要自己去一个个实现了
 6.自定义运算符 在全局作用域使用operator进行声明（c++自定义的时候关键字就是opretor）
 */
func testAdvancedOperators(){
    let a:uint8 = uint8.max
    let b:uint8 = uint8.min
    let c = a &+ 1  //0  溢出255 + 1  0
    let d = b &- 1  //0  益处1 - 1 255
    print(c,d)
///运算符重载
    
    let p1 = people() + people()
    _ = -people()
///Equatable协议
    p1 == p1 ? print("相等") : print("不相等")
    
    let p3 = people1(10)
    let p4 = people1(20)
    let p5 = p4;
    p3 == p4 ? print("相等") : print("不相等")
    p4 === p5 ? print("相等") : print("不相等")
///comparable 协议
    let cmp1:Bool = p3 > p4
    let cmp2:Bool = p3 >= p4
    let cmp3:Bool = p3 < p4
    let cmp4:Bool = p3 <= p4
    print(cmp1,cmp2,cmp3,cmp4)
///自定义运算符
    _ = 1++*2++*3
    
}

class AdvancedOperators {
    
    init() {
        
        print("/*****************************************AdvancedOperators*****************************************/")
        testAdvancedOperators()
        
    }
}
