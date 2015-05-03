//
//  SieveOfEratosthenes.m
//  PrimeNumbersGenerator
//
//  Created by Anthony Marchenko on 5/3/15.
//  Copyright (c) 2015 Anthony Marchenko. All rights reserved.
//

#import "SieveOfEratosthenes.h"
#import <SVProgressHUD.h>

@implementation SieveOfEratosthenes

- (NSArray *) generatePrimeNumberTill: (int) limit
{
    NSDate *startDate = [NSDate date];
    
    [SVProgressHUD show];
    
    bool is_prime[limit + 1];
    int i, j;
    
    // make all index to false
    for (i = 0; i <= limit; i++)
        is_prime[i] = true;
    
    is_prime[0] = false;
    is_prime[1] = false;
    
    for (i=2;i<sqrt(limit);i++) // loop through all the numbers up to the sqrt(n)
        for (j=i*i;j<limit;j+=i) // mark off each factor of i by setting it to 0 (False)
            is_prime[j] = false;
    
    NSDate *endDate = [NSDate date];
    
    NSTimeInterval distanceBetweenDates = [endDate timeIntervalSinceDate:startDate];
    
    self.generationTime = distanceBetweenDates;
    
    NSLog(@"Atkin Time - %f", distanceBetweenDates);
    
    [SVProgressHUD dismiss];
    
    
    //Add frist three values of primes numbers
    NSMutableArray *primeArray = [@[@"2", @"3", @"5"] mutableCopy];
    
    //Add value from Array
    for (i = 6; i <= limit; i++) {
        if(is_prime[i])
        {
            [primeArray addObject:[NSString stringWithFormat:@"%i", i]];
        }
    }
    
    return primeArray;
    
    
}

- (NSArray *) threadsPrimeNumberGenetrationTill: (int) limit
{
    NSDate *startDate = [NSDate date];
    
    [SVProgressHUD show];
    
    bool is_prime[limit + 1];
    int i, j;
    
    // make all index to false
   // dispatch_async(dispatch_get_global_queue(0, 0), ^{
    for (i = 0; i <= limit; i++)
        is_prime[i] = true;
   // });
    
    is_prime[0] = false;
    is_prime[1] = false;
    
    for (i=2;i<sqrt(limit);i++) // loop through all the numbers up to the sqrt(n)
        for (j=i*i;j<limit;j+=i) // mark off each factor of i by setting it to 0 (False)
            is_prime[j] = false;
    
    NSDate *endDate = [NSDate date];
    
    NSTimeInterval distanceBetweenDates = [endDate timeIntervalSinceDate:startDate];
    
    self.generationTime = distanceBetweenDates;
    
    NSLog(@"Atkin Time - %f", distanceBetweenDates);
    
    [SVProgressHUD dismiss];
    
    
    //Add frist three values of primes numbers
    NSMutableArray *primeArray = [@[@"2", @"3", @"5"] mutableCopy];
    
    //Add value from Array
    for (i = 6; i <= limit; i++) {
        if(is_prime[i])
        {
            [primeArray addObject:[NSString stringWithFormat:@"%i", i]];
        }
    }
    
    return primeArray;
}

@end
