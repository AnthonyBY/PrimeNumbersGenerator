//
//  DBManager.m
//  PrimeNumbersGenerator
//
//  Created by Anthony Marchenko on 4/29/15.
//  Copyright (c) 2015 Anthony Marchenko. All rights reserved.
//

#import "DBManager.h"
#import "PrimeNumber.h"


@interface DBManager () <NSFetchedResultsControllerDelegate>
@end

@implementation DBManager

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Instacetype Manager Init

+ (instancetype) manager {
    static DBManager *_manager = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[DBManager alloc] init];
    });
    return _manager;
}

-(id) init
{
    self = [super init];
    [self initFetchResultController];
    return self;
}

- (void) initFetchResultController
{
    // Initialize Fetch Request
 //   NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    
    // Add Sort Descriptors
   // [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"userId" ascending:YES]]];
    
    // Initialize Fetched Results Controller
   // self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    
    // Configure Fetched Results Controller
    [self.fetchedResultsController setDelegate:self];
    
    // Perform Fetch
    NSError *error = nil;
    [self.fetchedResultsController performFetch:&error];
    
    if (error) {
        NSLog(@"Unable to perform fetch.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"PrimeNumbersGenerator" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"PrimeNumbersGenerator.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma  mark - Methods

- (void) savePrimeNumbers:(NSArray *) items
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    for(NSString *value in items)
    {
        //Check if Prime Number alredy exist
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"PrimeNumber" inManagedObjectContext:self.managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"value == %@", value];
        [fetchRequest setPredicate:predicate];
        
        NSError *error = nil;
        PrimeNumber *managedObject = [[self.managedObjectContext executeFetchRequest:fetchRequest error:&error] firstObject];
        
        if(!managedObject)
        {
            // Create a new managed object
            NSManagedObject *newPrimeNumber = [NSEntityDescription insertNewObjectForEntityForName:@"PrimeNumber" inManagedObjectContext:context];
            
            [newPrimeNumber setValue:value forKey:@"value"];
        }
    }

    
    NSError *error = nil;
    // Save the object to persistent store
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

- (NSArray *) getCurrentItems
{
    NSDate *startDate = [NSDate date];
    
    // Fetch the devices from persistent data store
    NSManagedObjectContext *managedObjectContext = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"PrimeNumber"];
    [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"value" ascending:YES]]];
    
    NSArray *primeNumbersArray = [[managedObjectContext executeFetchRequest:fetchRequest error:nil] mutableCopy];
    
    NSDate *endDate = [NSDate date];
    NSTimeInterval distanceBetweenDates = [endDate timeIntervalSinceDate:startDate];
    
    self.readingFromCoreDataTime = distanceBetweenDates;
   return primeNumbersArray;
}
@end
