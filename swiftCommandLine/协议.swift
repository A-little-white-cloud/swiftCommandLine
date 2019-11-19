//
//  协议.swift
//  swiftCommandLine
//
//  Created by coder on 2019/9/27.
//  Copyright © 2019 coder. All rights reserved.
//

import Foundation
/*代表这个协议只能被类去遵守*/
protocol goodPerson_protocol : AnyObject {
    
}
protocol Person_Protocol {

    mutating func run()
    
    static func sleep()
    /*
     {}里面代表的权限 可读可写
     这里并不是代表它是计算属性
     */
    var age:Int { set get }
    //只读
    var name:String{ get }
    subscript(index:Int)->Int{set get}
    
    init()
}


fileprivate class Student : Person_Protocol ,goodPerson_protocol,CustomStringConvertible,CustomDebugStringConvertible{
    
    var description: String {
        get
        {
            return "自定义打印: age = \(age) name = \(name)"
        }
    }
    //release模式下还是会打  llvm po 优先调用的是debugDescription
    var debugDescription: String{
        
        return "debug自定义打印: age = \(age) name = \(name)"
    }
    
    static func sleep() {
        print("sleep")
    }
    
    func run() {
        print("run")
    }
    
    var age: Int = 10
    
    var name: String = "fadsf"
    
    subscript(index: Int) -> Int {
        get {
            print("subscript get")
            return 20
        }
        set {
            print("subscript set")
        }
    }
    
    required init() {
        
    }
}
//必须遵守两个协议和一个类型。 这是协议组合（多个协议和一个class类型【结构体不行】） 也可以取个别名
fileprivate typealias goodManType = goodPerson_protocol & Person_Protocol & Student

fileprivate func goodMan(obj:goodPerson_protocol & Person_Protocol & Student) {
    print("GoodMand")
}

/**
 1.协议里面和其他的一样都是真申明不实现  {}就是用来做权限限制的  和oc一样可以遵循多个协议
 2.枚举结构体类都是可以遵守协议的
 3.协议默认是必须全部实现的（只实现部分的方法？）
 4.实现协议的权限不能小于协议的权限的
 5.协议中定义类型方法必须用static 不能用class  因为不止是类可以遵  【可以在实现的时候将static改成class calss修饰的类方法是为了可以让子类重写】
 6.mutating（允许值类型对象在方法内修改存储属性的值）  类在实现的时候去掉mutating 如果不写就默认没有mutating 你在实现的时候加会报错的
 7.协议中定义初始化器 非final的类在实现的时候初始化器都必须+required 【required 修饰的指定初始化器 表明子类都必须实现该初始化器（继承 重写）】
 8.Any：代表任意类型   AnyObject：代表任意类类型
 */
func testProtocol(){
    
    let par = Student()
    goodMan(obj: par)
    
    print(par)
    debugPrint(par)
    
}







enum Season_1 : Int,CaseIterable{
    
    case spring ,summer,autumn,winter
}
/*
 1.枚举中默认实现了CaseIterable协议
 2.就可以实现便利枚举值
 */
func testCaseIterable() {
    
    _ = Season_1.spring
    let all = Season_1.allCases //[Season_1]数组
    for sea in all {
        
        print("测试CaseIterable协议\(sea)")
    }
    
}




class HJprotocol {

    init() {
        print("**************HJprotocol********************")
        testProtocol()
        testCaseIterable()
    }
}
