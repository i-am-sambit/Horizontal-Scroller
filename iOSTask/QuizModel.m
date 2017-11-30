//
//  QuizModel.m
//  iOSTask
//
//  Created by Neeraj Sonaro on 29/11/17.
//  Copyright © 2017 SambitPrakash. All rights reserved.
//

#import "QuizModel.h"

@interface QuizModel()

@property (nonatomic, strong) NSMutableArray *userResults;

@end

@implementation QuizModel

+ (QuizModel *) sharedQuiz {
    static QuizModel *sharedQuiz = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQuiz = [[QuizModel alloc] init];
    });
    return sharedQuiz;
}

+ (NSArray *) quizQuestions {
    return @[@"Grand Central Terminal, Park Avenue, New York is the world's",
             @"Entomology is the science that studies",
             @"Eritrea, which became the 182nd member of the UN in 1993, is in the continent of",
             @"Garampani sanctuary is located at",
             @"For which of the following disciplines is Nobel Prize awarded?",
             @"Hitler party which came into power in 1933 is known as",
             @"In which year of First World War Germany declared war on Russia and France?",
             @"ICAO stands for",
             @"India's first Technicolor film ____ in the early 1950s was produced by ____",
             @"India has largest deposits of ____ in the world."];
}

+ (NSArray *) quizAnswers {
    return @[
             @{@"options":@[@"largest railway station", @"highest railway station", @"longest railway station",@"None of the above"],@"correctAnswer": @"1"},
             @{@"options":@[@"Behavior of human beings", @"Insects", @"The origin and history of technical and scientific terms",@"The formation of rocks"], @"correctAnswer": @"2"},
             @{@"options":@[@"Asia", @"Africa", @"Europe",@"Australia"], @"correctAnswer": @"2"},
             @{@"options":@[@"Junagarh, Gujarat", @"Diphu, Assam", @"Kohima, Nagaland",@"Gangtok, Sikkim"], @"correctAnswer": @"2"},
             @{@"options":@[@"Physics and Chemistry", @"Physiology or Medicine", @"Literature, Peace and Economics",@"All of the above"], @"correctAnswer": @"4"},
             @{@"options":@[@"Labour Party", @"Nazi Party", @"Ku-Klux-Klan",@"Democratic Party"], @"correctAnswer": @"2"},
             @{@"options":@[@"1914", @"1915", @"1916",@"1917"], @"correctAnswer": @"1"},
             @{@"options":@[@"International Civil Aviation Organization", @"Indian Corporation of Agriculture Organization", @"Institute of Company of Accounts Organization",@"None of the above"], @"correctAnswer": @"1"},
             @{@"options":@[@"'Jhansi Ki Rani', Sohrab Modi", @"'Jhansi Ki Rani', Sir Syed Ahmed", @"'Mirza Ghalib', Sohrab Modi",@"'Mirza Ghalib', Munshi Premchand"], @"correctAnswer": @"1"},
             @{@"options":@[@"gold", @"copper", @"mica",@"None of the above"], @"correctAnswer": @"3"},
             ];
}

+ (void) userSelectedResults:(int)selectedOption {
    if ([[QuizModel sharedQuiz] userResults] == nil) {
        [QuizModel sharedQuiz].userResults = [[NSMutableArray alloc] init];
    }
    
    [[QuizModel sharedQuiz].userResults addObject:[NSNumber numberWithInt:selectedOption]];
}

@end
