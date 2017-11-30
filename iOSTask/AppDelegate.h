//
//  AppDelegate.h
//  iOSTask
//
//  Created by Neeraj Sonaro on 28/11/17.
//  Copyright © 2017 SambitPrakash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

