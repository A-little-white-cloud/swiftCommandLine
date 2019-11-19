//
//  基本的语法(for while switch where 运算符).swift
//  swiftCommandLine
//
//  Created by coder on 2019/9/26.
//  Copyright © 2019 coder. All rights reserved.
//

import Foundation

/*
 never  __always都是在优化的情况下
 */
@inline(never) func test2(){} 
/*
 一直都会被内联（只有代码过长的代码会一直内联 但是递归。。。还是不会在优化的时候被内联）
 */
@inline(__always) func test1(){}

func testBaseGrammer() {
    
    /**************************************typealias 有点像typedef*******************************************/
    typealias Byte = Int8;
    typealias date = (year: Int,month :Int,day: Int);
    typealias intFn = (Int,Int) ->Int;
    
    /**************************************基本语法*******************************************/
    
    /*
     if后面不能写整数
     */
    var times = 100;
    
    if true {
        
    }else{
        
        
    }
    /* swift中不支持-- ++*/
    while times > 0 {
        
        times -= times;
    };
    
    /*相当于do while*/
    repeat{
        
        print(times);
    }while times<0;
    
    /*
     #区间运算符  _表示忽略
     1.闭区间运算符  a...b  ClosedRange<Int>(类型)
     2.半开区间运算符  a...<b*  a<=取值<b/   Range<Int>(类型)
     3.单侧区间 2...  ...100    PartialRangeThrough(类型)
     4.where可以添加判断条件（用来过滤）
     */
    
    
    var i = 0;
    let range = 0...3;
    let range1 : ClosedRange = 0...2;
    let string = "aa"..."ff";
    
    print("测试区间:",string.contains("ac"));
    print("测试区间:",range.contains(7));
    
    for _ in range {
        print("测试for",i);
    }
    
    for var i in range {
        i = 5;
        print("测试for",i);
    }
    
    for var i in range where i <= 1{
        i = 5;
        print("测试for",i);
    }
    
    //从4-11 没次加2
    for i in stride(from: 4, to: 11, by: 2){
        
        print(i);
        
    }
    
    let switchT = arc4random_uniform(12)
    
    /*
     switchT 可以是字符串 元组
     case 0:大括号是不能写的
     break;可以省略。其实默认加了break
     fallthrough就是可以执行下面一行（我认为没什么用）
     */
    switch switchT {
    case 0,1:
        print("switch",1);
        fallthrough;
    case 2:
        print("switch",2);
        break;
    case 3:
        print("switch",3);
        break;
    case 4...9:
        print("switch",4...9);
        break;
    default:
        print("default");
        break;
    }
    
    
    let point = (arc4random_uniform(12),arc4random_uniform(12),arc4random_uniform(12),arc4random_uniform(12));
    
    switch point {//绑定 将point的值分别绑定到x y m n
        
    case (let x, let y,let m,let n) where x == 1:
        print(x,y,m,n);
        break;
    case (let x, let y,let m,let n) where m == n:
        print(x,y,m,n);
        break;
        
    default:
        break
    }
    
    
    var age111:Int? = 10
    switch age111 {
        /*
         1.不加？其实是直接将age111的值g付给v。
         2.+？ 如果age111不为nil 赋值给v 如果为空走case nil
         */
    case let v?:
        print("")
    case nil:
        print("")
    }
    
    
    
    /*
     标签语句
     */
    
    wall: for i in 0...100 {
        
        wall1: for j in 0...100 {
            
            if i == 50 {
                continue wall;
            }
            if j == 10{
                continue wall1;
            }
        }
    }
    
    
    
    
    /**************************************函数（函数文档注释）*******************************************/
    ///
    /// 求和
    /// - Parameters:
    ///   - a: 参数
    ///   - b: 参数
    /// - Returns: 返回值
    @discardableResult func add(a:Int,b:Int) ->Int{
        
        return a+b;
    };
    
    add(a: 1,b: 2);
    
    @discardableResult func addAndReturn(a:Int,b:Int) ->(a:Int,b:Int,c:Int,d:String){
        
        return (1,2,3,"4");
    };
    
    addAndReturn(a: 1,b: 2);
    
    /*
     参数都是let 所以内部不能修改 +inout本质是地址传递 &的意思
     参数标签 目的是为函数名和参数读起来像一个句子
     可以设置默认参数（和c++一样 但是c++只能从右往左设置 swift可以随便 因为有参数标签）
     也支持重载
     _代表忽略的意思
     函数的内联函数在swift是release下自动开启的。有些函数在优化的时候自动内联
     可以用汇编查看是否内联
     函数内部修改函数内部（地址传递）
     */
    
    
    var number = 10;
    
    @discardableResult func DefaultValueParater(at a:inout Int,at b:Int ,at c:String = "name") ->(a:Int,b:Int,c:Int,d:String){
        a = 20;
        return (a,b,2,"ll");
    };
    func ignorPara(_ a:Int = 1, b:Int ,_ c:String = "name") ->Void{
        
        print("ignorPara");
    };
    DefaultValueParater(at: &number, at: 2,at: "name1");
    ignorPara(b: 10);
    print("函数内部修改函数内部:",number);
    
    
    
    /**************************************可选项Optional*******************************************/
    /*
     类型? 就是可选型  可选类型才能置为nil 而且可选类型的默认值就是nil
     !是从可选项中取值 解包
     可选项就是其他类型的一层包装 形成一个新的类型
     如果是nil就是空盒子
     如果不为nil 那么盒子里装的是：被包装类型的数据
     */
    var name:String? = "fadfs";
    let nameEx = name!
    name = nil;
    
    let age = 10;
    let age1:Int? = 10;
    //可选项绑定的多条件判断用,代替&&
    enum char : Int{
        case A = 1,B,C
        
    }
    let a = Int("afad");
    let charB = char(rawValue: 1)
    print("可选类型a:",a);
    print("可选类型char:",charB);
    
    if let charA = char(rawValue: 1) , age1! == 10  {
        
        //可选项作为判断条件都会自动解包了
        print(charA);
        switch charA {
        case .B:
            break;
        default:
            break;
        }
        
    }
    /**************************************空合并运算符？？*******************************************/
    //a ?? b a必须是可选项  b的类型必须是和a相同或者和a解包过后的类型。
    //如果a!=nil return a否则return b 类似三目运算符  三木运算符在swift中也是能用的
    //如果b不是可选项 返回a时自动解包了
    
    let temp = Int("32") ?? Int("31");
    let temp1 = Int("fads") ?? Int("31");
    let temp2 = Int("11") ?? 222;
    
    print("可选类型:", temp!,temp1!,temp2);
    
    
    /**************************************discardableResult||mutating*******************************************/
    /*
     struct enum 方法内部不允许修改存储属性的值  class 方法里面是可以直接修改得
     mutating 允许在方法内修改存储属性的值
     
     
     @discardableResult  可以消除函数调用返回值未被使用的警告
     subscript 可以给任意类型添加下标（枚举 结构体 类 ） 类似于实例方法 计算属性（本质就是方法）
     */
    
    struct Car{
        
        var type = "suv"
        var corlor = "black"
        var count = 1
        
        @discardableResult mutating func run() ->String{
            
            self.type = "temp"
            return self.type
        }
        
        subscript(Index:Int)->Car{
            set{
                
                
            }
            get{
                
                return Car(type: "11", corlor: "22", count: 2);
            }
        }
    }
    
    var car = Car(type: "111", corlor: "222", count: 12)
    car.run();

}





class HJBasicGrammar{
    init() {
        print("/************************HJBasicGrammar*********************************/")
        testBaseGrammer()
    }
    
    
}





