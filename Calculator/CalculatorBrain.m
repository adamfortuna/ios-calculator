//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Adam Fortuna on 8/29/12.
//  Copyright (c) 2012 Adam Fortuna. All rights reserved.
//

#import "CalculatorBrain.h"
#import "Math.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@end

@implementation CalculatorBrain

@synthesize programStack = _programStack;

-(NSMutableArray *) programStack {
    if(!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

-(void)pushOperand:(double)operand {
    NSNumber *operandToAdd = [NSNumber numberWithDouble:operand];
    [self.programStack addObject:operandToAdd];
}

-(double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

-(id)program {
    return [self.programStack copy];
}

+(NSString *)descritionOfProgram:(id)program {
    return @"todo";
}

+(double)popOperandOffStack:(NSMutableArray *)stack {
    double result = 0;
    id topOfStack = [stack lastObject];
    if(topOfStack) [stack removeLastObject];
    if([topOfStack isKindOfClass:[NSNumber class]]) {
        result = [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if([operation isEqualToString:@"+"]) {
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if([operation isEqualToString:@"*"]) {
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if([operation isEqualToString:@"-"]) {
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if([operation isEqualToString:@"/"]) {
            double divisor = [self popOperandOffStack:stack];
            if(divisor) result = [self popOperandOffStack:stack] / divisor;
        } else if([operation isEqualToString:@"sin"]) {
            result = sin([self popOperandOffStack:stack] * M_PI / 180);
        } else if([operation isEqualToString:@"cos"]) {
            result = cos([self popOperandOffStack:stack] * M_PI / 180);
        } else if([operation isEqualToString:@"sqrt"]) {
            result = sqrt([self popOperandOffStack:stack]);
        } else if([operation isEqualToString:@"log2"]) {
            result = log2([self popOperandOffStack:stack]);
        } else if([operation isEqualToString:@"π"]) {
            result = M_PI;
        } else if([operation isEqualToString:@"+/-"]) {
            result = [self popOperandOffStack:stack] * -1;
        }
    }
    return result;
}

+(double)runProgram:(id)program {
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

- (void)reset {
    [self.program removeAllObjects];
}
@end
