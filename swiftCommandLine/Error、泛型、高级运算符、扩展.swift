//
//  Error、泛型、高级运算符、扩展.swift
//  swiftCommandLine
//
//  Created by coder on 2019/9/28.
//  Copyright © 2019 coder. All rights reserved.
//

import Foundation
/*
 错误处理
 遵守Error协议就行了 结构体枚举类都可以
 throws 抛给上层函数。就是哪个函数调用这个方法 谁去处理(如果自己不想处理就必须throws 不然会编译报错)
 rethows 函数本身不会抛出错误 但调用闭包抛出错误，那么他将错误向上抛,其实用throws也可以。只是rethrow更明确错误一点
 try? try!
 如果都没有捕捉就会崩溃
 
 defer 以任何方式离开代码（正常的return 或者抛出异常,但是崩溃不行）块前必须执行
       要写在前面  作用就是延迟到函数结束的时候调用
 
 */

fileprivate enum errorType : Error{
    
    case parasError(error:String)
    
}
@discardableResult func testErrorDeal(num1:Int , num2:Int) throws ->Int{
    
    if num2 == 0 {
        throw errorType.parasError(error: "分母不能为0")
    }
    return num1/num2
    
}
func test111() throws{
    
    defer {
        testDefer();
    }
    try testErrorDeal(num1: 10, num2: 10)//如果这里有问题的话 就不会走下面的testDefer
    

    
    
}

/*
 defer 关键字
 */

func testDefer(){
    
    print("testDefer")
    
}

class HJerror_genericity_AdvancedOperational_category{
    
    init() throws{
        print("**************HJerror_genericity_AdvancedOperational_category********************")
//        fatalError("系统级别--致命错误")//debug release 是一样的都会直接崩溃
//        assert(false,"除数不能为0")//系统级别的 如果false 抛出运行时错误。输出后面打印的 release模式下相当于没写（也可以在setting里面强制开启断言 ）
        
        try! testErrorDeal(num1: 10, num2:1)//返回值可选类型会被解包
        _ = try? testErrorDeal(num1: 10, num2:0)//返回值会被包装成可选性
        do {
            
            try testErrorDeal(num1: 10, num2: 0)
            /**
             catch is errorType
             let error as errorType
             这两种写法都行
             */
        } catch errorType.parasError(let error) {
            print("异常处理",error)
        } catch{
            
            print("其它错误")
        }
        
        
        try test111()
        var a:Int = 100
        var b:Int = 200
        var c:String = "a"
        var d:String = "b"
        sawpValues(a: &a, b: &b)
        sawpValues(a: &c, b: &d)
        print(a,b,c,d)
        /*
         测试泛型
         */
        testConstraint(a: t, b: t)
        
        //do 单独使用  {} c oc中定义局部作用域
        do{
            let a = 10
            
        }
        do{
            let a = 10
            
        }
     
    }
    
    
}



/****************************************#泛型#**********************************************/

/*
 c++的实现是通过编译的时候利用函数重载生成很多个函数实现的范型
 swift并没有生成很多函数 type metadata得知类型信息的字节数。然后再操作
 */
func sawpValues<T>(a: inout T,b: inout T){
    
    (a,b) = (b,a)
    
}
//泛型函数赋值给变量
class stack<T>{
    
    var elements = Array<T>()
    
    func push(para:T) {
        elements.append(para)
    }
    func pop() -> T {
        return elements.first!
    }
}
class stack1<T>: stack<T> {
    
}
enum result<T> {
    case  score(T)
}
let stackEx = stack<Int>()


func sawpValue<T,T1>(a:T,b:T1){
    
}
var fn:(Int,Int) -> Void = sawpValue

/*****************************************关联类型*****************************************/
/*
 Element 就是关联类型 相当于申明
 typealias Element = Int 在这里是明确协议里面的类型
 如果里面有方法可以确定Element的类型的话。可省略typealias
 */
protocol anyProtocol {
    
    associatedtype Element
    func push(a:Element)
}
class typeConstraint<T>: anyProtocol {
//    typealias Element = Int
    func push(a:T) {

    }
}
struct TC:anyProtocol {
//    typealias Element = Int
    func push(a:Int ) {
        
        
        
    }
}
/**
 为啥报错
 */
//class TTT {
//
//    var Pet : some anyProtocol = TC()
//    init() {
//
//    }
//}
/*
 明确typeConstraint类里面T的类型 遵守协议或者是该类或者子类
 some修饰返回值。表示只能返回一种明确的类型
 */
let tc = typeConstraint<TC>();

protocol typeConstraint_Protocol{
    
    associatedtype T
    func run(t:T)
}
class typeConstraintCls<T1>:typeConstraint_Protocol{
//    typealias T = Int;
    func run(t:T1) {
    }
}

func testConstraint<T1:typeConstraint_Protocol>(a:T1,b:T1) -> T1 {
    
    return typeConstraintCls<Int>() as! T1
}

let t:typeConstraintCls = typeConstraintCls<Int>()

/*
 不透明类型 代表只开放协议里面的方法属性（除了用在返回值类型上面 还可以用在属性类型上）
 如果想返回遵守协议的类型,而且不想别人知道具体类型,而且不想别人调用该类的方法和属性
 为什么这里some报错
 */
//func testConstraintOpaque(_ type:Int) -> some typeConstraint_Protocol{
//
//
//    return typeConstraintCls<Int>()
//}

