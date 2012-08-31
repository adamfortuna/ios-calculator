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
@synthesize activity = _activity;
@synthesize userIsInTheMiddleOfEnterANumber;

@synthesize brain = _brain;

-(CalculatorBrain *) brain {
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (void)addToActivity:(NSString *)activity isOperand:(Boolean)isAnOperand {
    NSString *addedActivity = activity;
    if(isAnOperand) {
     addedActivity = [NSString stringWithFormat:@" %@ ", activity];
    }
    self.activity.text = [self.activity.text stringByAppendingString:addedActivity];
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    [self addToActivity:digit isOperand:FALSE];
    
    if(self.userIsInTheMiddleOfEnterANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.userIsInTheMiddleOfEnterANumber = TRUE;
        self.display.text = digit;
    }
}

- (IBAction)decimalPressed {
    NSRange range = [self.display.text rangeOfString:@"."];
    if (range.location == NSNotFound) {
        self.display.text = [self.display.text stringByAppendingString:@"."];

        if(self.userIsInTheMiddleOfEnterANumber) {
            [self addToActivity:@"." isOperand:FALSE];
        } else {
            self.userIsInTheMiddleOfEnterANumber = TRUE;
            [self addToActivity:@"0." isOperand:FALSE];
        }
    }
}

- (IBAction)enterPressed {
    [self addToActivity:@"" isOperand:TRUE];
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnterANumber = NO;
}

- (IBAction)operationPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfEnterANumber) {
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    [self addToActivity:operation isOperand:TRUE];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)clearPressed {
    [self.brain reset];
    self.userIsInTheMiddleOfEnterANumber = FALSE;
    self.display.text = @"0";
    self.activity.text = @"";
}
- (void)viewDidUnload {
    [self setActivity:nil];
    [super viewDidUnload];
}
@end
