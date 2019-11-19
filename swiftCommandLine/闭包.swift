//
//  闭包.swift
//  swiftCommandLine
//
//  Created by coder on 2019/9/26.
//  Copyright © 2019 coder. All rights reserved.
//

import Foundation

@discardableResult func test(v1:Int , v2:Int) ->Int{
    
    return v1 + v2
}

@discardableResult func sum( a: Int,b: Int, fn: (Int,Int)-> Int ) ->Int
{
    
    return fn(a,b)
    
}

/*
 自动闭包
 autoclosure ()->T  后面的类型是 无参且有返回值的闭包 或者函数
 且可以和没有autoclosesure的重载
 */

@discardableResult func getPositionNum(v1:Int,v2:()->Int)->Int{
    
    return v1 > 0 ? v1 : v2()
}


/// getPositionNum
///
/// - Parameters:
///   - v1: Int
///   - v2: autoclosure  可能会被推迟执行
/// - Returns: Int
@discardableResult func getPositionNum(v1:Int, v2: @autoclosure ()->Int)->Int{
    
    return v1 > 0 ? v1 : v2()
}



/*
 闭包表达式
 1.函数有两种定义方法 一种是正常的函数 一种就是闭包表达式
 2.闭包表达式 就是oc中的block
 3.调用的时候参数名称可以不用_省略也可以不写
 4.简单的这种fn其实就是函数指针
 */
/*
 闭包
 1.一个函数和它捕获的变量或者常量组合起来称为闭包
 2.一般是指函数内定义的函数函数
 3.这里就是返回的mul函数和num局部变量 形成了一个闭包
 
 
 4.这里的fn1其实也是一种类型 其中至少保存了num和mul的函数指针
 5.这里的堆空间为什么是24 swiftAlloc为什么穿进去的是24 最后内存对齐的是32
 */
/*
 尾随闭包
 1.将一个很长的闭包表达式，作为一个函数的最后实参
 2.如果像上面一样那么写 可读性很差
 3.fn的标签直接
 4.如果只有唯一参数且是闭包 直接()都画不用写了
 5.$0就是第一个参数 $1就是第二个参数 以此内推  因为在定义的时候参数 返回值都确定了 s所以可以省略
 
 */
func testClosure(){
    
    var fn = {
        
        
        (a :Int,b:Int)->Int in
        
        return a+b
        
    }
    
    var fnTest :(Int,Int)->Int = {$0 + $1}
    
    
    sum(a: 1, b: 2, fn: test(v1:v2:));
    
    sum(a: 1, b: 1, fn:{ (v1:Int,v2:Int) -> Int in
        
        return v1+v2
    })
    sum(a: 3, b: 4 ,fn: { v1,v2 -> Int in
        
        return v1+v2
    });
    sum(a: 3, b: 4, fn: { v1,v2 in
        
        return v1+v2
    });
    
    
    sum(a: 3, b: 4, fn: {
        
        return $0 + $1
    })
    sum(a: 23, b: 23){
        
        return $0 + $1
    }
    
    _ = fn(10,20)
    

    
    

    /*
     数组的排序
     */
    var arr = [1,3,2,5]
    
    arr.sort();
    arr.sort { (v1:Int, v2:Int) -> Bool in
        
        return v1 > v2 ? true : false
    }
    
    
    /*
    闭包
     */
    typealias sub = (Int,Int)->Int
    
    func add(a:Int,b:Int)->sub{
        
        var num:Int = 0;
        
        func mul(a:Int,b:Int)->Int{
            
            num = num+a*b
            return num
        }
        
        return mul(a:b:)
        
    }
    
    let fn1 = add(a: 10, b: 20)
    /*
     正常来说add执行完 栈空间就会被释放，但是这里的栈空间的num貌似没有被释放
     闭包不需要写前面的标签
     */
    let result = fn1(20,10)  //200
    let result1 = fn1(20,10) //400
    let result2 = fn1(20,10) //600
    print(result,result1,result2)
    let sum1 = sum;
    /*
     窥探储存方法和储存闭包的变量里面到底是装了什么
     */
    
    print(MemoryLayout.stride(ofValue: sum1))
    print(MemoryLayout.stride(ofValue: fn1))
    

    getPositionNum(v1: 10, v2: {20})
    getPositionNum(v1: 100, v2: 200)
    
    /*
     空合并运算符
     ??的第二个参数其实就是@autocloseure的自动闭包
     */
    
    let num1: Int? = 10;
    let num2: Int? = nil;
    
    _ = num1 ?? num2;
    
}


/// 闭包入口
class HJClosure {
    init() {
        print("/************************HJClosure*********************************/")
        testClosure();
    }
}
