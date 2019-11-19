//
//  inherit(继承).swift
//  codingSwift
//
//  Created by coder on 2019/9/25.
//  Copyright © 2019 许何健. All rights reserved.
//

import Foundation



/*
 字节数 8(类型信息)+8(引用计数)+8+8 32个字节  ---- 前面16相当于oc就是isa占8个字节
 */
/*final*/ class Animal{
    
    /*final*/ var name:String = ""
    public var age:Int = 0
    
    private var isAnimal = true
    
    var countProperty:Int {
        set{
            
        }
        get{
            
            return 1
        }
    }
    
    
    /*final*/ func eat() {
        
        print("Animal eat")
    }
    
    subscript(a:Int,b:Int)->Int{
        
        return a+b
    }
    

    class func run(){
        
        
    }
}


fileprivate class Dog : Animal{
    
    override func eat() {
        
        super.eat();
        print("Dog eat")
    }
    
    override subscript(a:Int,b:Int)->Int{
        
        
        return super[a,b]
    }
    /*
    重写的时候可以用 static来修饰
    这样Dog的子类就不能重写run了
     */
    override class func run(){
        
        
    }
    /*
     重写为计算属性（比如狗比所有动物都大10）
     */
    override var age: Int {
        
        set{
            
            super.age = newValue + 10
        }
        get{
            
            return super.age
        }
    }
    
}

class Cat: Animal{
    
    override func eat() {
        
        print("Cat eat")
    }
}

/**
 1.结构体是不支持继承的
 2.c++是结构体也可以继承的 因为c++的结构体和类除了默认访问权限不一样 其余都一样  而且值类型和指针类型 它们是是否用new
 3.swift没有任何类都继承自一个类的规定 重写 属性 方法 下标 必须加上 override
 4.static定义的类型属性/类型方法不可以被重写 class的可以
 5.子类可以将父类的属性重写为计算属性 但是不可以重写为存储属性  子类重写过后的属性权限不能小于父类（如果父类是可读可以的 子类必须可读可写）
 6.可以在子类中为父类的属性增加属性观察器(任何属性，而且不管父类有没有加属性观察器)
 7.final 修饰的方法或者属性或者class   是不允许被继承的
 8.访问权限大小顺序：open > public > internal(模块内部可以访问，超出模块内部就不可被访问了,默认权限) > fileprivate（本文件使用 ） > private，可以修饰属性、类、方法等
 */
class Inherit {
    
    @discardableResult init() {
        print("/************************Inherit*********************************/")
        
        var anim = Animal();
        let dog = Dog()
        dog.eat()
        /*
         父类指针指向子类对象 多态：
         可以的原因也是一样的就是数据安全（父类的子类都有 所以不会有访问超出内存的情况）
         1.oc runtime实现的（通过isa去找的都是runtime）
         2.c++ 虚表
         3.swift 也是虚函数表
         
         */
        anim = dog
        /*
         通过汇编查看实现原理
         结构体调用方法是确定的 编译完就知道函数地址 class不是 class的f方法地址是不固定的（有点类似于运行时）
         anim其实就是指针 调用方法 先找到类型（对象的前8个字节 然后在找到该方法）
         */
        anim.eat()
        
    }
}
