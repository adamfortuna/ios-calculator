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

// Assignment 1-4 - Add ability to track activity
- (void)addToActivity:(NSString *)activity {
    // Remove the "=" from the end of the activity string if there is one
    NSRange range = [self.activity.text rangeOfString:@"="];
    if (range.location != NSNotFound) {
        self.activity.text = [self.activity.text substringToIndex:range.location-1];
    }

    // If the last activity added was a space, don't add another space
    NSUInteger length = [self.activity.text length];
    NSString *lastActivity;
    if(length > 0) {
        lastActivity = [self.activity.text substringFromIndex:length-1];
    }

    if(!([lastActivity isEqualToString:@" "] && [activity isEqualToString:@" "])) {
        self.activity.text = [self.activity.text stringByAppendingString:activity];
    }
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = [sender currentTitle];
    [self addToActivity:digit];
    
    if(self.userIsInTheMiddleOfEnterANumber) {
        self.display.text = [self.display.text stringByAppendingString:digit];
    } else {
        self.userIsInTheMiddleOfEnterANumber = TRUE;
        self.display.text = digit;
    }
}

// Assignment 1-2 - Add ability to use a decimal
- (IBAction)decimalPressed {
    NSRange range = [self.display.text rangeOfString:@"."];
    if (range.location == NSNotFound) {
        self.display.text = [self.display.text stringByAppendingString:@"."];

        NSString *activity = @".";
        if(!self.userIsInTheMiddleOfEnterANumber) {
            self.userIsInTheMiddleOfEnterANumber = TRUE;
            activity = @"0.";
        }
        [self addToActivity:activity];
    }
}

// Assignment 1 EC2 - Add an "=" sign when hitting enter
- (IBAction)enterPressed {
    [self addToActivity:@" "];
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnterANumber = NO;
}


- (void)performOperation:(NSString *)operation {
    [self addToActivity:[NSString stringWithFormat:@" %@ ", operation]];
    [self addToActivity:@" = "];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
}

- (IBAction)operationPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfEnterANumber) {
        [self enterPressed];
    }
    [self performOperation:sender.currentTitle];
}

// Assignment 1-5 - "Clear" button to reset calculator
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


#pragma mark Extra Credit

// Assignment 1 EC1 - "Backspace" button
- (IBAction)backspace {
    if(self.userIsInTheMiddleOfEnterANumber) {
        [self.brain popOperand];
        
        // Adjust Display
        NSUInteger length = [self.display.text length];
        if(length > 0) {
            self.display.text = [self.display.text substringToIndex:(length-1)];
        }
        
        // Adjust Activity
        length = [self.activity.text length];
        if(length > 0) {
            self.activity.text = [self.activity.text substringToIndex:(length-1)];
        }
        
        // If no digits, no number in progress
        if([self.display.text length] == 0) {
            self.userIsInTheMiddleOfEnterANumber = FALSE;
        }
    } else {
        // There is nothing to backspace, show an alert
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Uh Oh!"
                              message:@"You can only backspace digits, and you're not currently entering anything!"
                              delegate:nil
                              cancelButtonTitle: @"OK"
                              otherButtonTitles:nil,
                              nil];
        [alert show];
    }
}

// Assignment 1 EC2 - "Change Sign" button
- (IBAction)changeSignPressed {
    
    /*
     If the user is in the middle of entering a number,
     change the sign on the current number.
    */
    if(self.userIsInTheMiddleOfEnterANumber) {
        NSRange range = [self.display.text rangeOfString:@"-"];
        NSString *newDisplay;
        // Currently positive, should make it negative
        if (range.location == NSNotFound) {
            newDisplay = [NSString stringWithFormat:@"-%@", self.display.text];
        } else { // Currently negative, should make positive
            newDisplay = [self.display.text substringFromIndex:1];
        }
        
        // Update activity
        NSInteger activityLength = [self.activity.text length],
                  displayLength = [self.display.text length];
        NSString *newActivity = [self.activity.text substringToIndex:(activityLength - displayLength)];
        self.activity.text = [newActivity stringByAppendingString:newDisplay];

        self.display.text = newDisplay;
    } else {
        NSLog(@"Todo: change sign pressed not in the middle of entering a number.");
        [self performOperation:@"+/-"];
    }
}


@end
