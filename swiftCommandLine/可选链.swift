//
//  test.swift
//  swiftCommandLine
//
//  Created by coder on 2019/9/27.
//  Copyright © 2019 coder. All rights reserved.
//

import Foundation

class Teacher {
    var age = 28
}

fileprivate class Person {
    
    var name = "初始Name"
    var age = 11
}

fileprivate class Student: Person {
    var score = 0
   
    var index = 0
    
    var teach:Teacher = Teacher()
    
    func exam() -> Int {
        
        score = Int(arc4random_uniform(100))
        return score
    }
    
    subscript(Index:Int)->Int{
        set{
            
            index = newValue
        }
        get{
            
            return index
        }
    }
    
    
    deinit {
        print("Student被释放了")
    }
    
}


func testOptionChaining(){
    
    /*
     !解包也可以(nil解包会崩溃)    但是？更好(代表先检查一下per是不是nil。如果是nil就不会执行run 如果不是nil就会解包调用run）
     而且可选项对象+？调用方法 属性  返回值一定都是可选项
     */
    let per:Person? = Person()
    let stu:Student? = Student()
    
    let name = per?.name
    
    stu?[0] = 100
    print(name ?? "空的",stu![0])

    
    /*
     可选链  通过可选项去访问的 不管中间经过多少层返回值都是可选项
     如果链中任意一个吊用失败 则返回为空
      dic["a"] 返回也是可选类型 【其实只要有可能为空 返回值都是可选类型】
     */
    print("老师年纪:",  stu?.teach.age != nil ? stu!.teach.age : "可选项为空")
    
    
    var dic:[String: Int] = ["a":1,"b":2]
    let aValue = dic["a"] //这里返回的也是可选项 因为你的键有可能是瞎写的
    let isHaskey:Bool = dic.keys.contains("a")
    if  isHaskey{
        print(dic["a"] ?? "空",aValue!)
    }
    
    
    var num:Int? = 10;
    num? = 10//这种是判断num是不是nil 是nil就不会走后面的赋值操作了
    
    let func1: (Int,Int)->Int = {
        
        (a :Int,b:Int)->Int in
        return 10
    }
    let func2Value = func1(11,20)
    
    //这种定义太神奇了 第一个参数String,后面是一个函数
    _ = Dictionary<String,Int>()
    _ = Array<Int>()
    _ = [Int]()
    
    var dict: [String: (Int,Int)-> Int] = [
        "sum":(+),
        "defrence":(-)
    ]
    
    var dictValue = dict["sum"]?(10,20)//取出来有可能是nil
    
    
    
    
    /**************************关键字**************************/
    /**
    is  判断是不是子类或者本身类型
    as! 代表可能失败过后还会强制解包（不太好）
    as? 代表可能失败过后返回nil
    as  as就是强制类型转换（子类转父类 大转小）
     any  任意类型
     anyclass 任意类类型
    */
    let test:Any = 1
    
    print(test is Int)
    
    
    let perq = Student()
    
    _ = (perq as Person).name
    _ = (test as? Person)?.name
//    _ = (test as! Person).name //(test as? Person)!  因为返回nil 强制解包 所以崩溃
    
    
    
    /**
     X.self  元类型指针（指向类对象的共有信息那块内存） 其实就是类对象的前8个字节  返回值是X.type类型的  相当于oc的class 类对象
     X.type
     Self     作为返回值类型 限定返回值跟方法调用者是同一类型（也可以作为参数类型） 类似于instanceType
     */

    let mateData = Person.self
    
    
    
    
    let p = Person() 
    _ = Person.self()//Person.self = Person
    
    let type11 = type(of: p)//看汇编可知道就是取p的前8个字节赋值给type11 所以后面打印的两个结果是一样的
    
    print("类型信息",type11,mateData)
    //runtime有些也是可以用在纯swift中的   不写任何继承的其实还是继承Swift._SwiftObject
    print("runtime查看类型",class_getInstanceSize(Person.self),class_getSuperclass(Person.self)!)
    
    
    
    
}



/**
 可选项本质
 其实就是枚举 -》optional内部就是枚举
 */


func testNativeOption(){
    let aa:Int? = 10//等于下面的这段代码
    let a:Optional<Int> = Optional.some(10)
    
    let bb:Int? = nil//等于下面的这段代码
    let b:Optional<Int> = Optional.none
    
}

class HJOptionChaining {
    init() {
        
        print("**************HJOptionChaining********************")
        testOptionChaining()
        testNativeOption()
    }
    
    func testSelf() -> Self {
        
        return self
    }
}
