//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Adam Fortuna on 8/29/12.
//  Copyright (c) 2012 Adam Fortuna. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

-(void)pushOperand:(double)operand;
-(double)performOperation:(NSString *)operation;
-(void)reset;

@property (readonly) id program;
+(double)runProgram:(id)program;
+(NSString *)descritionOfProgram:(id)program;

@end
