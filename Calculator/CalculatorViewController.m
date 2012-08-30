//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Adam Fortuna on 8/28/12.
//  Copyright (c) 2012 Adam Fortuna. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property(nonatomic) BOOL userIsInTheMiddleOfEnterANumber;
@property(nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController
@synthesize display;
@synthesize userIsInTheMiddleOfEnterANumber;
@synthesize brain = _brain;

-(CalculatorBrain *) brain {
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    
    if(self.userIsInTheMiddleOfEnterANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.userIsInTheMiddleOfEnterANumber = TRUE;
        self.display.text = digit;
    }
}

- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnterANumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfEnterANumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

@end
