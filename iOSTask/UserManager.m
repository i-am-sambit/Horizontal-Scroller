//
//  UserManager.m
//  iOSTask
//
//  Created by GLB-311-PC on 30/11/17.
//  Copyright © 2017 SambitPrakash. All rights reserved.
//

#import "UserManager.h"
#import "AppDelegate.h"

@implementation UserManager

+ (UserManager *) sharedManager {
    static UserManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[UserManager alloc] init];
    });
    return sharedManager;
}

+ (BOOL) saveUser:(NSDictionary *)user {
    if ([[[self sharedManager] fetchUserDetails:[user objectForKey:@"username"] password:[user objectForKey:@"password"]] count] == 0) {
        if ([[self sharedManager] saveAccountDetails:user]) {
            return true;
        }
        else {
            return false;
        }
    }
    else {
        return false;
    }
}

+ (NSArray *) fetchUser:(NSString *)username password:(NSString *)password {
    return [[self sharedManager] fetchUserDetails:username password:password];
}

/**
 * Save account details will save user's details
 */
- (BOOL) saveAccountDetails:(NSDictionary *)account {
    
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [[delegate persistentContainer] viewContext];
    NSManagedObject *accounts = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    
    [accounts setValue:[account objectForKey:@"username"] forKey:@"username"];
    [accounts setValue:[account objectForKey:@"password"] forKey:@"password"];
    
    NSError *error = nil;
    @try {
        [context save:&error];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception);
        return NO;
    } @finally {
        NSLog(@"finally block executed");
    }
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        return NO;
    }
    else {
        return YES;
    }
}

/**
 * Retrive user's details using user's screen name
 * It will return list of user if client will not provide a screen name
 * Or else it will provide particular user details according to screen name
 */
- (NSArray *) fetchUserDetails:(NSString *)username password:(NSString *)password {
    
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [[delegate persistentContainer] viewContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"User"];
    if (![username isEqualToString:@""]) {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"username == %@ && password == %@", username, password];
    }
    
    NSArray *users = nil;
    @try {
        users = [context executeFetchRequest:fetchRequest error:nil];
        NSLog(@"user : %@", users);
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception);
    } @finally {
        NSLog(@"finally block executed");
    }
    return users;
}

@end
