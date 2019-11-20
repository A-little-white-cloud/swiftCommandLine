//
//  字面量.swift
//  swiftCommandLine
//
//  Created by coder on 2019/11/18.
//  Copyright © 2019 coder. All rights reserved.
//

import Foundation
/**
 系统的字面量就是这么实现的
 可以通过这个修改字面量的类型
 
 swift 自带的绝大部分类型 都可以通过字面量直接进行初始化
 Dictionary，Array，Set，String，Int，Bool，Double，optional等。这些类型能通过字面量创建 是遵守了对应的协议
 */

///FloatLitralType 相当于10 定义为Int
public typealias IntegerLitralType = Int
///FloatLitralType 相当于1.0 定义为float
public typealias FloatLitralType = Int
///FloatLitralType 相当于true false 定义为Bool
public typealias BooleanLitralType = Int
///FloatLitralType 相当于“ ” 定义为String
public typealias StringLitralType = Int



func HJ_literalTest(){
    var a = 1.0
}




class HJ_literal{
    init() {
        print("/*****************************************HJ_literal*****************************************/")
        HJ_literalTest()
    }
}
