//
//  DBManager.h
//  PrimeNumbersGenerator
//
//  Created by Anthony Marchenko on 4/29/15.
//  Copyright (c) 2015 Anthony Marchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DBManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

+ (instancetype) manager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

#pragma  mark - Methods


//- (NSArray *) getCardsForUser: (User *) user;

@end
