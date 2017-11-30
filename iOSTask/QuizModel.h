//
//  QuizModel.h
//  iOSTask
//
//  Created by Neeraj Sonaro on 29/11/17.
//  Copyright © 2017 SambitPrakash. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuizModel : NSObject

@property (nonatomic, strong, readonly) NSMutableArray *userResults;

+ (QuizModel *) sharedQuiz;

+ (NSArray *) quizQuestions;
+ (NSArray *) quizAnswers;
+ (void) userSelectedResults:(int) selectedOption;

@end
