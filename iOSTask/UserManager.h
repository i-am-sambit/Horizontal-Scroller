//
//  UserManager.h
//  iOSTask
//
//  Created by GLB-311-PC on 30/11/17.
//  Copyright © 2017 SambitPrakash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject

+ (UserManager *) sharedManager;

+ (BOOL) saveUser:(NSDictionary *)user;
+ (NSArray *) fetchUser:(NSString *)username password:(NSString *)password;

@end
