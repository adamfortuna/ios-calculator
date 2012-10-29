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
@property(nonatomic) BOOL isEnteringNewNumber;
@property(nonatomic, strong) CalculatorBrain *brain;
@property(nonatomic) NSMutableDictionary *testVariableValues;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize activity = _activity;
@synthesize variables = _variables;
@synthesize isEnteringNewNumber;
@synthesize brain = _brain;
@synthesize testVariableValues = _testVariableValues;

-(CalculatorBrain *) brain {
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

-(NSMutableDictionary *) testVariableValues {
    if(!_testVariableValues) {
        _testVariableValues = [[NSMutableDictionary alloc] init];
    }
    return _testVariableValues;
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit = sender.currentTitle;
    if (self.isEnteringNewNumber) {
        self.display.text = digit;
        self.isEnteringNewNumber = NO;
    } else {
        [self appendToResultLabel:digit];
    }
}

// Assignment 1-2 - Add ability to use a decimal
- (IBAction)decimalPressed {
    if (self.isEnteringNewNumber) {
        self.display.text = @"0.";
        self.isEnteringNewNumber = NO;
    } else if ([self.display.text rangeOfString:DECIMAL_SEPARATOR].location == NSNotFound) {
        [self appendToResultLabel:DECIMAL_SEPARATOR];
    }
}

- (void) updateActivity {
    self.activity.text = [CalculatorBrain descriptionOfProgram:[self.brain program]];
}

// Assignment 1 EC2 - Add an "=" sign when hitting enter
- (IBAction)enterPressed {
    [self.brain pushOperand:[self.display.text doubleValue]];
    [self updateActivity];
    self.isEnteringNewNumber = YES;
}

- (void)performOperation:(NSString *)operation {
    double result = [self.brain performOperation:operation];
    [self updateActivity];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (!self.isEnteringNewNumber) {
        [self enterPressed];
    }
    NSString *operation = sender.currentTitle;
    [self.brain performOperation:operation];
    [self updateLabels];
}

// Assignment 1-5 - "Clear" button to reset calculator
- (IBAction)clearPressed {
    self.isEnteringNewNumber = YES;
    self.brain = [[CalculatorBrain alloc] init];
    [self updateLabels];
}

- (void)viewDidUnload {
    [self setActivity:nil];
    [self setVariables:nil];
    [super viewDidUnload];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"texturetastic_gray"]];
    [self clearPressed];
}

#pragma mark Extra Credit

// Assignment 1 EC1 - "Backspace" button
- (IBAction)backspace {
    if(!self.isEnteringNewNumber) {
        // Adjust Display
        NSUInteger length = [self.display.text length];
        if(length > 0) {
            self.display.text = [self.display.text substringToIndex:(length-1)];
        }

        // If no digits, no number in progress
        if([self.display.text length] == 0) {
            self.isEnteringNewNumber = TRUE;
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
    if(!self.isEnteringNewNumber) {
        if ([self.display.text doubleValue] > 0) {
            self.display.text = [@"-" stringByAppendingString:self.display.text];
        }
        else if ([self.display.text doubleValue] < 0) {
            self.display.text = [self.display.text substringFromIndex:1];
        }
    } else {
        [self performOperation:@"+/-"];
    }
}



// Assignment #2.3e
- (IBAction)setVariables1 {
    
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:   [NSNumber numberWithInt:3], @"x",
                           [NSNumber numberWithInt:4], @"y",
                           [NSNumber numberWithDouble:2.3], @"a",
                           [NSNumber numberWithDouble:-5], @"b",
                           nil];
    [self updateLabels];
}
- (IBAction)setVariables2 {
    self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:   [NSNumber numberWithInt:1], @"x",
                           [NSNumber numberWithInt:0], @"y",
                           [NSNumber numberWithDouble:-1], @"a",
                           [NSNumber numberWithDouble:2], @"b",
                           nil];
    [self updateLabels];

}
- (IBAction)setVariablesNil {
    self.testVariableValues = nil;
    [self updateLabels];
}

// Assignment #2.3c, #2.3d
- (void)updateLabels {
    self.activity.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    double result = [CalculatorBrain runProgram:self.brain.program
                                 usingVariables:self.testVariableValues];
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    NSMutableArray* variableValuesTexts = [[NSMutableArray alloc] init];
    for (NSString* usedVariable in [CalculatorBrain variablesUsedInProgram:self.brain.program]) {
        [variableValuesTexts addObject:[NSString stringWithFormat:@"%@ = %g", usedVariable, [[self.testVariableValues objectForKey:usedVariable] doubleValue]]];
    }
    self.variables.text = [variableValuesTexts componentsJoinedByString:@", "];
    
}

- (void)appendToResultLabel:(NSString *)suffix {
    self.display.text = [self.display.text stringByAppendingString:suffix];
}

@end
