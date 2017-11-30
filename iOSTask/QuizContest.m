//
//  QuizContest.m
//  iOSTask
//
//  Created by GLB-311-PC on 30/11/17.
//  Copyright © 2017 SambitPrakash. All rights reserved.
//

#import "QuizContest.h"
#import "AppDelegate.h"

@implementation QuizContest

+ (QuizContest *) sharedContest {
    static QuizContest *sharedContest = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedContest = [[QuizContest alloc] init];
    });
    return sharedContest;
}

+ (void) saveQuizDetails:(NSDictionary *)quizDetails {
    
    NSManagedObject *managedObject = [[self sharedContest] fetch:[quizDetails objectForKey:@"user"]];
    
    if (managedObject) {
        [[self sharedContest] update:quizDetails managedObject:managedObject];
    }
    else {
        [[self sharedContest] save:quizDetails];
    }
}

+ (NSDictionary *) fetchQuizDetails:(NSString *)username {
    NSDictionary *details = (NSDictionary *)[[self sharedContest] fetch:username];
    return details;
}

- (BOOL) save:(NSDictionary  *)quizDetails {
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [[delegate persistentContainer] viewContext];
    NSManagedObject *userQuizDetails = [NSEntityDescription insertNewObjectForEntityForName:@"Quiz" inManagedObjectContext:context];
    
    [userQuizDetails setValue:[quizDetails objectForKey:@"user"] forKey:@"user"];
    [userQuizDetails setValue:[quizDetails objectForKey:@"remainingTime"] forKey:@"remainingTime"];
    [userQuizDetails setValue:[quizDetails objectForKey:@"completed"] forKey:@"completed"];
    [userQuizDetails setValue:[quizDetails objectForKey:@"attendQuestion"] forKey:@"attendQuestion"];
    [userQuizDetails setValue:[quizDetails objectForKey:@"answers"] forKey:@"answers"];
    [userQuizDetails setValue:[quizDetails objectForKey:@"result"] forKey:@"result"];
    
    NSError *error = nil;
    @try {
        [context save:&error];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception);
        return false;
    } @finally {
        NSLog(@"finally block executed");
    }
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        return false;
    }
    else {
        return true;
    }
    return true;
}

- (BOOL) update:(NSDictionary *) quizDetails managedObject:(NSManagedObject *)managedObject {
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [[delegate persistentContainer] viewContext];
    
    [managedObject setValue:[quizDetails objectForKey:@"user"] forKey:@"user"];
    [managedObject setValue:[quizDetails objectForKey:@"remainingTime"] forKey:@"remainingTime"];
    [managedObject setValue:[quizDetails objectForKey:@"completed"] forKey:@"completed"];
    [managedObject setValue:[quizDetails objectForKey:@"attendQuestion"] forKey:@"attendQuestion"];
    [managedObject setValue:[quizDetails objectForKey:@"answers"] forKey:@"answers"];
    [managedObject setValue:[quizDetails objectForKey:@"result"] forKey:@"result"];
    
    NSError *error = nil;
    @try {
        [context save:&error];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@", exception);
        return false;
    } @finally {
        NSLog(@"finally block executed");
    }
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
        return false;
    }
    else {
        return true;
    }
    return true;
}

- (NSManagedObject *) fetch:(NSString *)username {
    id delegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [[delegate persistentContainer] viewContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Quiz"];
    if (![username isEqualToString:@""]) {
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"user == %@", username];
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
    if ([users count] > 0) {
        return [users objectAtIndex:0];
    }
    else {
        return nil;
    }
}

@end
