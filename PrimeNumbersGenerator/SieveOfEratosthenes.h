//
//  SieveOfEratosthenes.h
//  PrimeNumbersGenerator
//
//  Created by Anthony Marchenko on 5/3/15.
//  Copyright (c) 2015 Anthony Marchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SieveOfEratosthenes : NSObject

@property (atomic) double generationTime;
@property (atomic) double threadsGenerationTime;

- (NSArray *) generatePrimeNumberTill: (int) limit;

- (NSArray *) threadsPrimeNumberGenetrationTill: (int) limit;

@end
