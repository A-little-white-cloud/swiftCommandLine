//
//  内存布局.swift
//  codingSwift
//
//  Created by coder on 2019/9/25.
//  Copyright © 2019 许何健. All rights reserved.
//

import Foundation
/*
 枚举只占一个字节
 这里面的原始值 1  Extest1 并不是存储在枚举里面的。
 这个原始值值是放在哪里的？不明白
 */
enum testIntEnum:Int {
    case test1 = 1
    case test2 = 2
};

enum testStringEnum:String {
    case test1 = "EXTest1"
    case test2 = "EXTest2"
};
/*
 这里窥探内存  testRelevanceEnum1保存的是61 也就是a的asc码
 16+16+1(关联值是需要32个字节 枚举本身需要1个字节存储成员值) 内存对其是8 对齐前十33 对齐后是40
 因为case最大的就是两个string的关联值。所以取最大的
 也就是说关联值是存在枚举内部的
 */
enum testRelevanceEnum {
    case test1(value:String,valuse:String)
    case test2(String)
    case test3(String)
    case test4(Int)
    
};


/// 输出内存地址
///
/// - Parameter o: 参数的引用
/// - Returns: 内存地址
func address(o: UnsafeRawPointer) -> String {
    return String.init(format: "%018p", Int(bitPattern: o))
}



func entrance(){
    
    //窥探内存布局
    var testIntEnum1 = testIntEnum.test1;
    print(MemoryLayout<testIntEnum>.size);
    print(MemoryLayout<testIntEnum>.alignment);
    print(MemoryLayout<testIntEnum>.stride);
    print(testIntEnum1);
    print("rawValue:",testIntEnum1.rawValue);
    print(address(o: &testIntEnum1));
    testIntEnum1 = testIntEnum.test2;
    
    
    
    
    var testStringEnum1 = testStringEnum.test2;
    print(MemoryLayout<testStringEnum>.size);
    print(MemoryLayout<testStringEnum>.alignment);
    print(MemoryLayout<testStringEnum>.stride);
    print(testStringEnum1);
    print("rawValue:",testStringEnum1.rawValue);
    print(address(o: &testStringEnum1));
    testStringEnum1 = testStringEnum.test1;
    
    
    /*
     这里窥探内存  testRelevanceEnum1保存的是61 也就是a的asc码
     也就是说关联值是存在枚举内部的
     */
    var testRelevanceEnum1 = testRelevanceEnum.test2("a");
    print(MemoryLayout<testRelevanceEnum>.size);
    print(MemoryLayout<testRelevanceEnum>.alignment);
    print(MemoryLayout<testRelevanceEnum>.stride);
    print(testRelevanceEnum1);
    print(address(o: &testRelevanceEnum1));
    testRelevanceEnum1 = testRelevanceEnum.test1(value:"aa" , valuse:"bb");
    
    
    /*
     枚举的底层实现大概就类似于一个switch
     先用最后一个字节判断是哪一个case 然后在把前面的值负值给这个关联值
     */
    switch testRelevanceEnum1 {
        
    case let .test1(value: V1, valuse: V2):
        print("test1",V1,V2);
        break;
    case .test2("bb"):
        break;
    default:
        break;
    }
    
    
    /******************类和结构体的构造函数窥探***********************/
    /*
     自定义构造函数
     如果你自己写了构造函数它就不默认帮你生成了
     */
    struct size{
        
        var x :Float = 10.0
        var y :Float = 9.0
        
        init(x:Float,y:Float) {
            self.x = x
            self.y = y
        }
        init() {
            x = 0;
            y = 10;
        }
    }
    
    let size1 = size(x: 100, y: 200);
    let size2 = size();
    print("size1:",size1,"\nsize2:",size2);
    
    
    
    /*
     如果成员变量你没有给默认值 连无参数的构造函数也不会自动生成
     如果成员变量给了初始值 只会生成一个无参的构造函数 不会像结构体一样生成好几个构造函数
     如果你想要那样的构造函数可以自己写
     所以得自己写构造函数
     */
    class origin{
        
        var x:Int
        var y:Int
        
        init() {
            x = 100
            y = 100
        }
        init(x:Int,y:Int) {
            self.x = x;
            self.y = y;
        }
    }
    
    let origin1 = origin();
    print(MemoryLayout.size(ofValue: origin1));
    let origin2 = origin(x: 100, y: 100);
    print("origin:",origin1.x,origin1.y,"\norigin2:",origin2.x,origin2.y);
    
    
    
    
    /*
     探究闭包的变量捕捉
     */
    
    /*
     闭包
     一个函数和它捕获的变量或者常量组合起来称为闭包
     一般是指函数内定义的函数函数
     
     这里就是返回的mul函数和num局部变量 形成了一个闭包
     */
    typealias sub = (Int,Int)->Int
    
    func add(a:Int,b:Int)->sub{
        
        var num:Int = 0;
        /*
         这里的变量捕捉和bloclk一样。这里的num也会拷贝到堆空间
         堆空间前面有16个字节是有用的 前8个是类信息 后8个是引用计数  然后后面才是存储成员变量的内存
         因为内存对齐 所以其实最小的也是分配32个字节
         是函数作为返回值的时候才会捕获num的
         */
        func mul(a:Int,b:Int)->Int{
            
            num = num + 1
            return num
        }
        
        return mul(a:b:)
        
    }
    /*
     fn1就是一个变量 可以帮你h找到mul方法
     调用一次add就会alloc一片堆空间（汇编可看）
     */
    let fn1 = add(a: 10, b: 20)
    let fn2 = add(a: 11, b: 22)
    /*
     正常来说add执行完 栈空间就会被释放，但是这里的栈空间的num貌似没有被释放
     
     */
    let result = fn1(20,10)  //200
    let result1 = fn1(20,10) //400
    let result2 = fn1(20,10) //600
    let result3 = fn2(20,10) //600
    print(result,result1,result2);
    
    
    func sum(a :Int, b :Int)->Int{
        return a + b
    }
    
    /*
     汇编可以看到使用leaq赋值 然后可以rip的地址+偏移量 = LMDB p输出的sum1地址是一样的
     可以确认sum1里面16个字节 前面8个装的是sum的地址 后8个还没用
     */
    let sum1 = sum;
    /*
     汇编可以看到使用leaq赋值 然后可以rip的地址+偏移量 = LMDB p输出的sum1地址是一样的
     可以确认sum1里面16个字节 前面8个装的是sum的地址 后8放的是堆空间num的地址值
     */
    let fn3 = add(a: 100, b: 100)
    
    
    print("函数变量占用内存:",MemoryLayout.stride(ofValue: sum1))
    print("闭包占用内存:",MemoryLayout.stride(ofValue: fn3))
    
    
    let num1: Int? = 10;
    let num2: Int? = nil;
    
    num1 ?? num2;
    
    
    
    
    enum season:Int{
        
        case spring = 1
        case summer = 2
        
        /*
         计算属性不占用内存  所以枚举只能定义计算属性
         这就是rawValue的底层实现
         */
        //    var  rawValue : Int {
        //
        //        switch self {
        //        case .spring:
        //            return 11
        //        case .summer:
        //            return 22
        //        default:
        //            return 0
        //        }
        //
        //    }
        
    }
    let seasonEx = season.summer
    
    seasonEx.rawValue
    
    
}



