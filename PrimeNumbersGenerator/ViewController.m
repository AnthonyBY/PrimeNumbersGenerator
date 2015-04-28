//
//  ViewController.m
//  PrimeNumbersGenerator
//
//  Created by Anthony Marchenko on 4/28/15.
//  Copyright (c) 2015 Anthony Marchenko. All rights reserved.
//

#import "ViewController.h"
#import "NMRangeSlider.h"
#import "SieveOfAtkin.h"

#define RGB(r,g,b,a) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a]

@interface ViewController ()

@property (weak, nonatomic) IBOutlet NMRangeSlider *labelSlider;

@property (weak, nonatomic) IBOutlet UILabel *lowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;


@property (weak, nonatomic) IBOutlet UILabel *atkingPerformanceLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureLabelSlider];
    [self updateSliderLabels];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self updateSliderLabels];
    
    if([self.view respondsToSelector:@selector(setTintColor:)])
    {
        self.view.tintColor = RGB(0, 51, 51, 1);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)generateButtonPressed:(UIButton *)sender {
    
    SieveOfAtkin *atkin = [[SieveOfAtkin alloc] init];
    self.textView.text = [[[atkin generatePrimeNumberTill:[self.upperLabel.text intValue]]  valueForKey:@"description"] componentsJoinedByString:@", "];
    
    self.atkingPerformanceLabel.text = [NSString stringWithFormat:@"%f mls", atkin.generationTime];
}

// Handle control value changed events just like a normal slider
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender
{
    [self updateSliderLabels];
    
}

- (void) configureLabelSlider
{
    self.labelSlider.minimumValue = 0;
    self.labelSlider.maximumValue = 327670;
    
    self.labelSlider.lowerValue = 0;
    self.labelSlider.upperValue = 327670;
    self.labelSlider.minimumRange = 10;
}

- (void) updateSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    //lowerCenter.x = (self.labelSlider.lowerCenter.x + self.labelSlider.frame.origin.x);
    lowerCenter.x = (self.labelSlider.lowerCenter.x + self.labelSlider.frame.origin.x);
    lowerCenter.y = (self.labelSlider.center.y - 30.0f);
    self.lowerLabel.center = lowerCenter;
    self.lowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.labelSlider.upperCenter.x + self.labelSlider.frame.origin.x);
    upperCenter.y = (self.labelSlider.center.y - 30.0f);
    self.upperLabel.center = upperCenter;
    self.upperLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.upperValue];
}


@end
