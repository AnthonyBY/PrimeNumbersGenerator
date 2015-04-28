//
//  PrimeNumbersGenerator.h
//  PrimeNumbersGenerator
//
//  Created by Anthony Marchenko on 4/29/15.
//  Copyright (c) 2015 Anthony Marchenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SieveOfAtkin : NSObject

@property (atomic) double generationTime;

- (NSArray *) generatePrimeNumberTill: (int) limit;

@end
