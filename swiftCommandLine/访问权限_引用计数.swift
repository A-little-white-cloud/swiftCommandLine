//
//  访问权限.swift
//  swiftCommandLine
//
//  Created by coder on 2019/10/14.
//  Copyright © 2019 coder. All rights reserved.
//

import Foundation
import Dispatch
/**
 1.访问权限大小顺序：
 open
    1.允许定义实体的模块，其他模块内访问，允许其他模块进行继承 重写（open只能用在类，类成员上）
    2.这里swiftCommandLine就是一个模块 动态库什么的也算是一个模块
 public
    1..允许定义实体的模块，其他模块内访问，但是不允许其他模块进行h继承重写
 internal(模块内部可以访问，超出模块内部就不可被访问了,默认权限)
    1.只允许定义实体的模块访问，不允许其他模块内访问
 fileprivate（本文件使用 ）
    1.只允许在定义实体的源文件访问
 private，可以修饰属性、类、方法等
    1.只允许在定义实体封闭声明中访问，跟修饰的地方的作用域有关
 */

fileprivate  class Person{
    //写的权限可以设置比get权限低
    private(set) var age = 1
    weak var dog:Dog? = nil
    
    deinit {
        print("Person.deinit")
    }
    var hasDog:(()->Void)?
    //这里面要注意循环引用,只有初始化完成的时候才能使用self   只有吊用selfRerence 才会生成对应的方法
    ///这里Person的fn变量引用着闭包表达式  闭包表达式有个self引用Person
    lazy var selfRerence:(()->()) = {
        [weak self] in
        print("dog.age is",(self?.age != nil ? self!.age : "nil"))
    }
    ///这种事不造成循环引用的
    ///这里不是agenum指向闭包的。而是给agenun附上这个表达式的结果的值。这里相当于 lazy var ageNum:Int = age
    lazy var ageNum:Int = {
        
        return self.age
    }()
    
}





/*****************************************引用计数*****************************************/
class HJ_RefrenceAccout {
    init() {
        print("/*****************************************HJ_RefrenceAccout*****************************************/")
        testAutomaticRefrenceCount()
        testPoint()
    }
}
//1.强引用弱引用和iOS的一样
//2.unowned 无主引用-》和weak一样就是指针不会主动置为nil 和OC的unsafe_unretained一样
fileprivate class Dog {
    var name = ""
    var age = 0
    var person:Person? = nil
    deinit {
        print("Dog.deinit")
    }
    
}
 func testAutomaticRefrenceCount() {
    
    unowned var dog1:Dog?
    weak var dog2:Dog?
    func run(){

        let dog = Dog()
        dog1 = dog
        dog2 = dog

    }

    run();
    //dog1是野指针 dog2是nil
    //print(dog1,dog2)
    
    //自动释放池子
    autoreleasepool {
    }
    
    ///循环引用 和OC是一样的
    ///闭包表达式里面用到的对象 默认引用计数+1
    ///闭包内部如果用到了实例成员（方法 属性） 编译器会强制要求写self.
    let per = Person()
    let dog = Dog()
    
    per.hasDog = {
        [weak per,weak dog] in
        print(per!,dog!)
    }
    per.dog = dog
    dog.person = per
    
    
    per.selfRerence()
    
    
    /**
     1.非逃逸闭包: 闭包在作用域范围内完成调用  可以捕获inout修饰的变量
     2.逃逸闭包: 闭包又可能在函数结束后调用   需要用@escaping声明   逃逸闭包不能捕获inout变量
     */
    typealias closorType = ()->()
    var escaping:closorType
    
    func NoEscaping(fn:closorType) {
        fn()
    }
    //方法内的两种都是逃逸闭包
    func Escaping(fn:@escaping closorType) {
        escaping = fn
        DispatchQueue.global().async {
            fn()
        }
    }
    NoEscaping {
        print("非逃逸闭包")
    }
}

func testPoint() {
    
    var a:Int = 10
    //const Int*
    var p1 = withUnsafePointer(to: &a) { $0 }
    //获取一个UnsafeMutableRawPointer的指针
    var p3 = withUnsafeMutablePointer(to: &a) { UnsafeMutableRawPointer($0)}
    p3.storeBytes(of: 33, as: Int.self)
    print(p3.load(as: Int.self))
    //Int*
    let p2:UnsafeMutablePointer<Int> = withUnsafeMutablePointer(to: &a) { (p) -> UnsafeMutablePointer<Int> in
        return p;
    }
    
    
    ///不带泛型 void *  
//    let p3:UnsafeMutableRawPointer;
//    p3.storeBytes(of: 20, as: Int.self);
//    p3.load(as: Int.self)
    
    
    var arr = NSArray(objects: 10,20,30)
    print(arr);
    arr.enumerateObjects { (element, index,isStop) in
        
        if index == 1{
            isStop.pointee = true;
        }
        print(element)
    }
    
    var str:NSMutableString = NSMutableString()
    
    
    
    /**
     获取指向堆空间的指
     Mems那个类就是用这种东西实现的
     */
    
    var per = Person();
    ///per1存储的是per的首地址
    let per1 = withUnsafeMutablePointer(to: &per){UnsafeMutableRawPointer($0)}
    ///取出8个字节 从per的首地址取出8个字节。就是堆区的首地址
    let perAdress = per1.load(as: UInt.self)
    ///通过地址获取指向堆区对象的指针。  bitPattern就是指针指向的地址
    let per2 = UnsafeRawPointer(bitPattern: perAdress)
    print(Mems.ptr(ofRef: per),"----",per2!);
    
    
    
    /**
     创建指针
     1.Darwin malloc
     2.unsafe
     带有mutable的才能申请内存
    UnsafeRawPointer这种事不能allocate
     */
    let point1 = malloc(MemoryLayout<Int>.size * 2)
    point1?.storeBytes(of: 10, as: Int.self)
    point1?.storeBytes(of: 20, toByteOffset: 8, as: Int.self)
    print((point1?.load(fromByteOffset: 0, as: Int.self))!);
    print((point1?.load(fromByteOffset: 8, as: Int.self))!);
    
    
    let point2 = UnsafeMutableRawPointer.allocate(byteCount: 16, alignment: 8)
    point2.storeBytes(of: 10, as: Int.self)
    point2.storeBytes(of: 20, toByteOffset: 8, as: Int.self)
    print(point2.load(fromByteOffset: 0, as: Int.self));
    print(point2.load(fromByteOffset: 8, as: Int.self));
    /**
     point3指向的是point2便宜8个自己的内存
     */
    point2.advanced(by: 8).storeBytes(of: 30, as: Int.self)
    print(point2.advanced(by: 8).load(as: Int.self))
    point2.deallocate();
    
    
    let point4 = UnsafeMutablePointer<Int>.allocate(capacity: 2);
    point4.pointee = 4;
    //10初始化前8个字节
    point4.initialize(to: 10)
    // point4.successor()指向的是下一个Int的首字节
    point4.successor().initialize(to: 20)
    (point4+1).initialize(to: 30)
    print(point4.pointee,(point4+1).pointee);
    print(point4[0],point4[1]);
    
    //如果用了initialize一定要调用这个deinitialize
    point4.deinitialize(count: 2)
    point4.deallocate();
    
  
    ///指针的切换  原声转泛型指针
    let point5 = UnsafeMutableRawPointer.allocate(byteCount: 8, alignment: 0)
    
    let point6 = point5.assumingMemoryBound(to: Int.self)
    let point7 = unsafeBitCast(point5, to: UnsafeMutablePointer<Int>.self)
    print(type(of: point5),type(of: point6),type(of: point7))
    
    /**
     强制转化的原理（忽略类型的一种强制转换）
     Double()这种转化其实是没有改变类型结构的，Double.init 相当于重新改变了内存结构
     unsafeBitCast是不改变内存结构的。也就是他们的二进制存储是一样的
     */
    let age = 10 //0x 00 00 00 00 00 00 00 0A
    let age1 = Double(age) //不是0x 00 00 00 00 00 00 00 0A 而是很复杂的 涉及到科学计算法
    let age2 = unsafeBitCast(age, to: Double.self)  //0x 00 00 00 00 00 00 00 0A 和age相同
    print(age,age1,age2) //按浮点数的读取方式读取出来，所以变成了5e-323
    
    
    
    
    
}
