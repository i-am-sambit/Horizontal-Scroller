//
//  QuizViewController.m
//  iOSTask
//
//  Created by Neeraj Sonaro on 29/11/17.
//  Copyright © 2017 SambitPrakash. All rights reserved.
//

#import "QuizViewController.h"
#import "HorizontalScroller.h"
#import "HorizontalScrollerCell.h"
#import "QuizModel.h"
#import "QuizContest.h"

@interface QuizViewController () <HorizontalScrollerDelegate> {
    
    BOOL startQuiz;
    
    int correctAnswerCount;
    int remainingCounts;
    int currentQuestionIndex;
    HorizontalScroller *horizontalScroller;
    
    NSTimer *timer;
    
    UIView *transparentView;
    NSMutableArray *userAnswers;
}

@property (weak, nonatomic) IBOutlet UIView *quizView;
@property (weak, nonatomic) IBOutlet UIView *backgroundView;

@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation QuizViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    gradient.colors = @[(id)[UIColor colorWithRed:(19/255.0) green:(64/255.0) blue:(136/255.0) alpha:1].CGColor, (id)[UIColor blackColor].CGColor];
    [_backgroundView.layer insertSublayer:gradient atIndex:0];
    
    horizontalScroller = [[HorizontalScroller alloc] initWithFrame:CGRectMake(0, 0, _quizView.bounds.size.width, _quizView.bounds.size.height)];
    horizontalScroller.backgroundColor = [UIColor clearColor];
    horizontalScroller.delegate = self;
    [_quizView addSubview:horizontalScroller];
    [horizontalScroller reload];
    
    transparentView = [[UIView alloc] initWithFrame:_quizView.bounds];
    transparentView.backgroundColor = [UIColor clearColor];
    [_quizView addSubview:transparentView];
    
    remainingCounts = 600;
    if (_username) {
        
        _usernameLabel.text = _username;
        
        NSDictionary *userQuiz = [QuizContest fetchQuizDetails:_username];
        
        if (userQuiz && [[userQuiz valueForKey:@"completed"] boolValue] == false) {
            
            remainingCounts = [[userQuiz valueForKey:@"remainingTime"] intValue];
            int min = remainingCounts/60;
            int sec = remainingCounts - (min * 60);
            _timerLabel.text = [NSString stringWithFormat:@"%d : %0.2d", min, sec];
            
            int attaindedQuestions = [[userQuiz valueForKey:@"attendQuestion"] intValue];
            horizontalScroller.questionIndex += attaindedQuestions;
            _questionLabel.text = [NSString stringWithFormat:@"Questions %d/10", horizontalScroller.questionIndex+1];
            NSData* data = [[userQuiz valueForKey:@"answers"] dataUsingEncoding:NSUTF8StringEncoding];
            NSArray *values = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            for (int i = 0; i < values.count ; i++) {
                [QuizModel userSelectedResults:i];
            }
            correctAnswerCount = [[userQuiz valueForKey:@"result"] intValue];
        }
        else {
            correctAnswerCount = [[userQuiz valueForKey:@"result"] intValue];
            [self completeQuiz];
        }
    }
    [horizontalScroller reload];
}

- (void) countDown {
    remainingCounts -= 1;
    
    int min = remainingCounts/60;
    int sec = remainingCounts - (min * 60);
    
    _timerLabel.text = [NSString stringWithFormat:@"%d : %0.2d", min, sec];
}

- (IBAction)backAction:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You want to quit this quiz?" message:@"We will store all your progress. You can continue this quiz anytime." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:true completion:nil];
    }];
    [alert addAction:okay];
    [alert addAction:cancel];
    [self presentViewController:alert animated:true completion:nil];
}

- (IBAction)nextAction:(UIButton *)sender {
    
    if (horizontalScroller.questionIndex < [[QuizModel quizQuestions] count] - 1) {
        horizontalScroller.questionIndex += 1;
        _questionLabel.text = [NSString stringWithFormat:@"Questions %d/10", horizontalScroller.questionIndex+1];
        [QuizModel userSelectedResults:0];
    }
    else if (horizontalScroller.questionIndex == [[QuizModel quizQuestions] count]){
        [self completeQuiz];
    }
}

- (void) completeQuiz {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Quiz Completed!!!" message:[NSString stringWithFormat:@"You have complete this quiz contest. Your score is %d", correctAnswerCount] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okay = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        startQuiz = false;
        [_quizView addSubview:transparentView];
        [timer invalidate];
        timer = nil;
        
        NSData* data = [ NSJSONSerialization dataWithJSONObject:[QuizModel sharedQuiz].userResults options:NSJSONWritingPrettyPrinted error:nil ];
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [QuizContest saveQuizDetails:@{@"user":_username, @"completed":[NSNumber numberWithBool:true], @"remainingTime": [NSNumber numberWithInt:remainingCounts], @"attendQuestion": [NSNumber numberWithInt:horizontalScroller.questionIndex], @"answers": jsonString, @"result":[NSNumber numberWithInt:correctAnswerCount]}];
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    [alert addAction:okay];
    [self presentViewController:alert animated:true completion:nil];
}

- (IBAction)submitAction:(UIButton *)sender {
    
    if (startQuiz == false) {
        startQuiz = true;
        [transparentView removeFromSuperview];
        [sender setTitle:@"Stop" forState:UIControlStateNormal];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    else {
        startQuiz = false;
        [_quizView addSubview:transparentView];
        [sender setTitle:@"Start" forState:UIControlStateNormal];
        [timer invalidate];
        timer = nil;
        
        NSData* data = [ NSJSONSerialization dataWithJSONObject:[QuizModel sharedQuiz].userResults options:NSJSONWritingPrettyPrinted error:nil ];
        NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        [QuizContest saveQuizDetails:@{@"user":_username, @"completed":[NSNumber numberWithBool:false], @"remainingTime": [NSNumber numberWithInt:remainingCounts], @"attendQuestion": [NSNumber numberWithInt:horizontalScroller.questionIndex], @"answers": jsonString}];
    }
}

- (void) chooseFirstOptionAction: (UIButton *) sender {
    
    if ([[[[QuizModel quizAnswers] objectAtIndex:sender.tag] objectForKey:@"correctAnswer"] intValue] == sender.tag) {
        sender.backgroundColor = [UIColor greenColor];
        correctAnswerCount += 1;
    }
    else {
        sender.backgroundColor = [UIColor orangeColor];
    }
    
    if (horizontalScroller.questionIndex < [[QuizModel quizQuestions] count] - 1) {
        horizontalScroller.questionIndex += 1;
        _questionLabel.text = [NSString stringWithFormat:@"Questions %d/10", horizontalScroller.questionIndex+1];
    }
    else {
        _nextButton.enabled = false;
        [self completeQuiz];
    }
    [QuizModel userSelectedResults:1];
}

- (void) chooseSecondOptionAction: (UIButton *) sender {
    if ([[[[QuizModel quizAnswers] objectAtIndex:sender.tag] objectForKey:@"correctAnswer"] intValue] == sender.tag) {
        sender.backgroundColor = [UIColor greenColor];
        correctAnswerCount += 1;
    }
    else {
        sender.backgroundColor = [UIColor orangeColor];
    }
    if (horizontalScroller.questionIndex < [[QuizModel quizQuestions] count] - 1) {
        horizontalScroller.questionIndex += 1;
        _questionLabel.text = [NSString stringWithFormat:@"Questions %d/10", horizontalScroller.questionIndex+1];
    }
    else {
        _nextButton.enabled = false;
        [self completeQuiz];
    }
    [QuizModel userSelectedResults:2];
}

- (void) chooseThirdOptionAction: (UIButton *) sender {
    if ([[[[QuizModel quizAnswers] objectAtIndex:sender.tag] objectForKey:@"correctAnswer"] intValue] == sender.tag) {
        sender.backgroundColor = [UIColor greenColor];
        correctAnswerCount += 1;
    }
    else {
        sender.backgroundColor = [UIColor orangeColor];
    }
    if (horizontalScroller.questionIndex < [[QuizModel quizQuestions] count] - 1) {
        horizontalScroller.questionIndex += 1;
        _questionLabel.text = [NSString stringWithFormat:@"Questions %d/10", horizontalScroller.questionIndex+1];
    }
    else {
        _nextButton.enabled = false;
        [self completeQuiz];
    }
    [QuizModel userSelectedResults:3];
}

- (void) chooseFourthOptionAction: (UIButton *) sender {
    if ([[[[QuizModel quizAnswers] objectAtIndex:sender.tag] objectForKey:@"correctAnswer"] intValue] == sender.tag) {
        sender.backgroundColor = [UIColor greenColor];
        correctAnswerCount += 1;
    }
    else {
        sender.backgroundColor = [UIColor orangeColor];
    }
    if (horizontalScroller.questionIndex < [[QuizModel quizQuestions] count] - 1) {
        horizontalScroller.questionIndex += 1;
        _questionLabel.text = [NSString stringWithFormat:@"Questions %d/10", horizontalScroller.questionIndex+1];
    }
    else {
        _nextButton.enabled = false;
        [self completeQuiz];
    }
    [QuizModel userSelectedResults:4];
}

#pragma mark : Horizontal Scroller Delegates
- (NSInteger)numberOfViewsForHorizontalScroller:(HorizontalScroller*)scroller {
    return [[QuizModel quizQuestions] count];
}

- (CGSize) contentSizeForView:(HorizontalScroller *)scroller {
    return CGSizeMake(scroller.bounds.size.width, scroller.bounds.size.height);
}

- (UIView*)horizontalScroller:(HorizontalScroller*)scroller viewAtIndex:(int)index {
    
    HorizontalScrollerCell *cell = [[HorizontalScrollerCell alloc] initWithFrame:CGRectMake(0, 0, scroller.frame.size.width, scroller.frame.size.height)];
    
    cell.questionLabel.text = [[QuizModel quizQuestions] objectAtIndex:index];
    
    cell.firstOptionButton.tag = index;
    [cell.firstOptionButton setTitle:[[[[QuizModel quizAnswers] objectAtIndex:index] objectForKey:@"options"] objectAtIndex:0] forState:UIControlStateNormal];
    [cell.firstOptionButton addTarget:self action:@selector(chooseFirstOptionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.secondOptionButton.tag = index;
    [cell.secondOptionButton setTitle:[[[[QuizModel quizAnswers] objectAtIndex:index] objectForKey:@"options"] objectAtIndex:1] forState:UIControlStateNormal];
    [cell.secondOptionButton addTarget:self action:@selector(chooseSecondOptionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.thirdOptionButton.tag = index;
    [cell.thirdOptionButton setTitle:[[[[QuizModel quizAnswers] objectAtIndex:index] objectForKey:@"options"] objectAtIndex:2] forState:UIControlStateNormal];
    [cell.thirdOptionButton addTarget:self action:@selector(chooseThirdOptionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.fourthOptionButton.tag = index;
    [cell.fourthOptionButton setTitle:[[[[QuizModel quizAnswers] objectAtIndex:index] objectForKey:@"options"] objectAtIndex:3] forState:UIControlStateNormal];
    [cell.fourthOptionButton addTarget:self action:@selector(chooseFourthOptionAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)horizontalScroller:(HorizontalScroller *)scroller clickedViewAtIndex:(int)index {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
