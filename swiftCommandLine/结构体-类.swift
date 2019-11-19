//
//  结构体-类.swift
//  swiftCommandLine
//
//  Created by coder on 2019/9/26.
//  Copyright © 2019 coder. All rights reserved.
//

import Foundation
/*: #oc c语言结构体
 struct ll{
 int lla = 0;
 
 };
 - (void)test{

 stu aa = stu_ns;
 student bb = stu1_ns;
 sss s = sss_ns;
 struct ll cc;
 cc.lla = 100;
 }
 */

/**
 问题: 大写的Self代表类型为什么这里没有用
 */
class temp{
    var tempx = 1
}

struct date{
    var year :Int = 2019
    var month :Int = 9
    var day :Int?  = 10
}

struct size{
    
    /*存储属性*/
    var x :Float = 10.0
    var y :Float = 9.0
    /*
     类型实例 属性
     static修饰的 是线程安全的
     count 是只有一份内存的（全局）不在实例对象里面的 存在哪呢
     类型属性可以先不给初始值 因为类型属性是没有init初始化器来初始化它的
     类型属性默认是lazy 在使用的时候赋值
     汇编查看
     */
    static var count:Int = 10
    static let count2:Int = 10
    /*
     延迟存储属性
     只能用var 因为是使用的时候才复制 所以用let是冲突的（let在定义的时候必须有值）
     这也是一个成员变量 存储的是返回值
     这个不是线程安全的
     延时属性 对象生成时 这里的tempEx不会先走tempeEx的构造函数  但是内存还是会先预留给这个成员变量
     */
    lazy var tempEx = temp()
    
    init(x:Float,y:Float) {
        self.x = x
        self.y = y
        age = 100
    }
    
    init() {
        age = 100
    }
    
    func test() {
    }
    /*
     存储属性
     属性观察器
     只有非lazy的var的存储属性设置属性观察器（有点类似kvo）
     在构造函数里面初始化age是不会触发属性观察器的
     */
    var age:Int {
        willSet{
            print("即将set",newValue)
            
        }
        didSet{
            print("didset",oldValue)
            
        }
    }
    
    /*
     计算属性
     */
    var harfWidth : Double {
        set{
            print(newValue);
        }
        get{
            print(self.x);
            return 10
        }
    }
  
    lazy var image:Int = {
        let a = 5
        let b = 10
        return a+b
    }()
    
    /*
     类型计算属性
     */
    static var count1:Int{
        
        set{
            
        }
        
        get{
            return 10
        }
    }
}


class testCountProperty{
    var a:Int = 10
    var b:Int {
        set{
            print("a",newValue)
        }
        get{
            print("b");
            return 1
        }
    }
    var c:Int = 0 {
        
        willSet{}
        
        didSet{}
    }
    /*
     1.指定初始化器：至少要有一个
     2.如果重写指定初始化器的话 默认的那个初始化器就不存在了
     3.子类的初始化器必须调用父类的初始化器 且调用父类的初始化器在后面调用
     4.如果子类没有定义任何指定初始化器 它会自动继承父类的所有初始化器
     5.如果子类定义了指定初始化器 父类的初始化器智能在子类初始化器中调用
     6.required 修饰的指定初始化器 表明子类都必须实现该初始化器（继承 重写）
     7.如果子类要重写 也得加上required 不用override了（required其实就包含了重写的意思）
     8.子类的初始化器修改成员变量会触发willset didset属性观察期（其实就是初始化过后的修改会触发）
     */
    required init() {
        
    }
    
    init(a:Int, b:Int) {

    }
    /*
     便捷初始化器
     内部必须调用指定初始化器 且指定初始化器的调用得放在最前面
     */
    
    
    convenience init(at a:Int, at b:Int, at c:Int){
        
        self.init(a:10,b:20)    
    }
    /*
     可失败初始化器
     var aa = Int("")  源码就是可失败初始化器
     返回的是一个可选类型 可选类型才能是nil
     */
    init?(c:Int,d:Int) {
        
        if c == 0 {
            return nil
        }
    }
    /*
     自动解包的可失败初始化器。返回的就是该对象。不是可选类型
     */
//    init!(c:Int,d:Int) {
//
//        if c == 0 {
//            return nil
//        }
//    }
    /*
     反初始化器 ->类对象的内存被释放的时候会调用
     相当于oc的dealloc  c++的析构函数一样
     */
    deinit {
        
    }
}

class origin{
    
    var x:Int = 0
    var y:Int = 0
    
    init() {
        x = 100
        y = 100
    }
    
    func test() {
        
    }
}

/*
 1.常见类型都是结构体
 2.所有的初始化都有一个初始化方法，构造函数
 3.传入参数 初始化成员变量
 4. 自定义构造函数 如果你自己写了构造函数它就不默认帮你生成了
 */
func testStruct() {
    _ = date(year: 2019, month: 08, day: 21);
    //var date2 = date(year: 1);
    _ = date(year: 1, month: 1, day: 21);
    _ = date();
    
    
    _ = size(x: 100, y: 200);
}


/**
 类和结构体的区别
 结构体是值类型（枚举也是值类型）         类是引用类型（指针类型 ）
 值类型在函数里面创建的是存在栈空间        指针在栈区（指向的对象在堆空间）
 值类型的赋值是深拷贝                    指针地址的赋值（指针拷贝 浅拷贝）
 
 swift标准库中的 String，Dictionary，Array，Set标准库中的这些事结构体 但是在需要的时候也会自动进行浅拷贝 节省内存和性能的优化
 自己定义struct 赋值都是深拷贝
 */
class x {
    var a:Int
    init() {
        a = 10
    }
    
}
/**
 /// 1.如果成员变量你没有给默认值 连无参数的构造函数也不会自动生成 (存储变量必须有初始值 原因:->4)
 /// 2.如果成员变量给了初始值 只会生成一个无参的构造函数 不会像结构体一样生成好几个构造函数
 /// 3.如果你想要那样的构造函数可以自己写  所以得自己写构造函数
 /// 4.其实给初始值就是为了传递到默认的构造函数里面去，如果你写的构造函数里面　赋值了 写了初始值也没用

 
 /// 5.堆空间前面有16个字节是有用的 前8个是类信息 后8个是引用计数  然后后面才是存储成员变量的内存
    类型信息：指向代码区该类型的方法列表
 /// 6.枚举和结构体 类里面都可以定义方法
 /// 7.和oc一样 只有成员变量才占用对象的空间。  方法都放在代码区
 /// 8.写在类. 结构体.枚举里面的方法能直接访问成员变量。其实就是默认传了参数 和oc的  __cmd,self是一样的 和c++的this
 
 问题: 如何打印指针指向的地址的内存

 */
func testClass(){
    
    _ = origin();
}







/**********************************属性***************************************************/

enum season:Int{
    
    case spring = 1
    case summer = 2
    
    /*
     计算属性不占用内存  所以枚举只能定义计算属性
     这就是rawValue的底层实现
     汇编可以正式这些
     */
    var  rawValue : Int {
        get{
            switch self {
            case .spring:
                return 11
            case .summer:
                return 22
            }
        }
        
    }
    
}

/*
 1.这个方法就是直接修改传进来内存地址指向的值
 2.如果实参是有物理内存地址的，且没有设置属性观察器的直接将实参的内存地址直接传过去
 3.如果实参是计算属性或者设置了属性c观察器的 采取了copy in copy out （先copy产生一个局部变量->再将局部变量的内存地址传入函数->函数调用完毕 再用局部变量覆盖掉实参的值）
 */

func changeValue(value:inout Int){
    
    value = 40;
}
/*
 跟实例相关的属性2大类（只能通过实例去访问的）
    1.存储属性  成员变量  struct class 生成的对象存储属性都必须要有初始值 不卸载定义里面 就要创建的时候传参
    2.计算属性  本质是函数 不占用对象的内存 （用于两个属性有关联的时候）
 
 类型属性（只能通过类型去访问，oc就是类方法 c++静态方法）
    1.存储类型属性
 
 延迟存储属性
    1.因为lazy lazy修饰的在使用的时候才会走该类型的init函数
 */

func testProperty(){
    
    let seasonEx = season.summer
    print(seasonEx.rawValue)
    
    let simple = testCountProperty()
    ///这里传递的是a的地址值 也就是simple的地址（因为是第一个存储属性）
    changeValue(value: &simple.a)
    ///这里是先get给一个局部变量 然后把这个局部变量的地址传到changeValue里面  然后在调用set把这个局部变量传进去
    changeValue(value: &simple.b)
    //这也是先get给一个局部变量，然后把这个局部变量的地址传到changevalue里面  然后修改这个局部变量
    //changevalue方法调用结束后 在把这个局部变量赋值给c 再调用willset didset 是这么设计的 就是为了触发属性观察器
    changeValue(value: &simple.c)
    
    /*
     延时属性 这里的tempEx不会先走tempeEx的构造函数  但是内存还是会先预留给这个成员变量
     */
    var sizex1 = size(x: 200, y: 200)
    print("实际占用内存",MemoryLayout.size(ofValue: sizex1))
    sizex1.tempEx.tempx = 100
    print("实际占用内存",MemoryLayout.size(ofValue: sizex1))
    
    downLoadManager.shareManager.download();
}

/*
 类型属性（type instance）
 */
///单利
class downLoadManager{
    //跟汇编 可以看见底层是调用的dispatch_once{}相当于第一次初始化 dispatch_once{downLoadManager = downLoadManager()}
    //这也是为什么他线程安全的原因
    public static let shareManager:downLoadManager = downLoadManager()
    
    
    func download(){
        print("测试简单的单利 利用的就是类型属性")
    }
     
    private init() {
        
    }
    
}


//入口
class struct_class{
    
    init() {
        print("/************************struct_class*********************************/")
        testStruct()
        testClass()
        testProperty()
        
    }
}
