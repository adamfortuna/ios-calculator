//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Adam Fortuna on 8/28/12.
//  Copyright (c) 2012 Adam Fortuna. All rights reserved.
//

#import <UIKit/UIKit.h>

static int const MAX_LENGTH_CALCULATIONLABEL = 35;
static NSString *const DECIMAL_SEPARATOR = @".";


@interface CalculatorViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *activity;
@property (weak, nonatomic) IBOutlet UILabel *variables;
@end
