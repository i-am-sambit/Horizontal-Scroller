//
//  QuizContest.h
//  iOSTask
//
//  Created by GLB-311-PC on 30/11/17.
//  Copyright © 2017 SambitPrakash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizContest : NSObject

+ (void) saveQuizDetails:(NSDictionary *) quizDetails;
+ (NSDictionary *) fetchQuizDetails: (NSString *) username;

@end
