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
#import "SieveOfEratosthenes.h"
#import "DBManager.h"
#import <SVProgressHUD.h>
#import "PrimeNumber.h"

#define RGB(r,g,b,a) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a]

@interface ViewController ()

@property (weak, nonatomic) IBOutlet NMRangeSlider *labelSlider;

@property (weak, nonatomic) IBOutlet UILabel *lowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;


@property (weak, nonatomic) IBOutlet UILabel *atkingPerformanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *coreDataTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *eratostehnTimeLabel;


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
   
    [self generateAtkin];
    [self generateEratosthen];
  //  [self saveCurrentValueToDB];
}



// Handle control value changed events just like a normal slider
- (IBAction)labelSliderChanged:(NMRangeSlider*)sender
{
    [self updateSliderLabels];
    
}

- (IBAction)getValueFromCoreDataPressed:(UIButton *)sender {
    
    NSMutableString *primeNumbersString = [@"" mutableCopy];
    NSArray *primeNumbersArray = [[DBManager manager] getCurrentItems];
    for(PrimeNumber *primeNumber in primeNumbersArray)
    {
        if([primeNumbersString isEqualToString:@""])
        {
            primeNumbersString = [[primeNumber.value stringValue] mutableCopy];
        } else {
          [primeNumbersString appendString:[NSString stringWithFormat:@", %@", primeNumber.value]];
        }
    }
        
    self.textView.text = primeNumbersString;
    
    self.coreDataTimeLabel.text = [NSString stringWithFormat:@"%f mls", [DBManager manager].readingFromCoreDataTime];
}


- (void) configureLabelSlider
{
    self.labelSlider.minimumValue = 0;
    self.labelSlider.maximumValue = 50000;
    
    self.labelSlider.lowerValue = 0;
    self.labelSlider.upperValue = 50000;
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

#pragma mark - Generator

- (void) generateAtkin
{
    SieveOfAtkin *atkin = [[SieveOfAtkin alloc] init];
    self.textView.text = [[[atkin generatePrimeNumberTill:[self.upperLabel.text intValue]]  valueForKey:@"description"] componentsJoinedByString:@", "];
    self.atkingPerformanceLabel.text = [NSString stringWithFormat:@"%f mls", atkin.generationTime];
}

-(void) generateEratosthen
{
    SieveOfEratosthenes *eratoshten = [[SieveOfEratosthenes alloc] init];
       self.textView.text = [[[eratoshten generatePrimeNumberTill:[self.upperLabel.text intValue]]  valueForKey:@"description"] componentsJoinedByString:@", "];
    self.eratostehnTimeLabel.text = [NSString stringWithFormat:@"%f mls", eratoshten.generationTime];
}

#pragma mark - DB Helper

-(void) saveCurrentValueToDB
{
    [SVProgressHUD showInfoWithStatus:@"Saving to DB"];
    SieveOfAtkin *atkin = [[SieveOfAtkin alloc] init];
    [[DBManager manager] savePrimeNumbers:[atkin generatePrimeNumberTill:[self.upperLabel.text intValue]]];
    [SVProgressHUD dismiss];
}


@end
