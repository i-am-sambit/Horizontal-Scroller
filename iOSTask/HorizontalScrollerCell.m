//
//  HorizontalScrollerCell.m
//  iOSTask
//
//  Created by Neeraj Sonaro on 29/11/17.
//  Copyright © 2017 SambitPrakash. All rights reserved.
//

#import "HorizontalScrollerCell.h"

@interface HorizontalScrollerCell ()

@property (strong, nonatomic) UIView *contentView;


@end

@implementation HorizontalScrollerCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI:frame];
    }
    return self;
}


- (void) createUI:(CGRect) frame {
    
    UIView *questionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    questionView.backgroundColor = [UIColor clearColor];
    [self addSubview:questionView];
    
    _questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, questionView.frame.size.width, questionView.frame.size.height/2)];
    _questionLabel.textAlignment = NSTextAlignmentCenter;
    _questionLabel.textColor = [UIColor whiteColor];
    _questionLabel.text = @"What is delegates in iOS?";
    _questionLabel.font = [UIFont fontWithName:@"Optima" size:18];
    _questionLabel.numberOfLines = 0;
    _questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [questionView addSubview:_questionLabel];
    
    _firstOptionButton = [[UIButton alloc] initWithFrame:CGRectMake(20, _questionLabel.frame.origin.y + _questionLabel.frame.size.height, questionView.frame.size.width - 40, (questionView.frame.size.height - _questionLabel.frame.size.height)/4 - 10)];
    [_firstOptionButton setTitle:@"first option" forState:UIControlStateNormal];
    [_firstOptionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _firstOptionButton.backgroundColor = [UIColor colorWithRed:(19/255.0) green:(64/255.0) blue:(136/255.0) alpha:1];
    _firstOptionButton.layer.shadowColor = [UIColor blackColor].CGColor;
    _firstOptionButton.layer.shadowOffset = CGSizeMake(0.5f, 2.0f);
    _firstOptionButton.layer.shadowOpacity = 0.5f;
    [questionView addSubview:_firstOptionButton];
    
    _secondOptionButton = [[UIButton alloc] initWithFrame:CGRectMake(20, _firstOptionButton.frame.origin.y + _firstOptionButton.frame.size.height + 10, questionView.frame.size.width - 40, (questionView.frame.size.height - _questionLabel.frame.size.height)/4 - 10)];
    [_secondOptionButton setTitle:@"second option" forState:UIControlStateNormal];
    [_secondOptionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _secondOptionButton.backgroundColor = [UIColor colorWithRed:(19/255.0) green:(64/255.0) blue:(136/255.0) alpha:1];
    _secondOptionButton.layer.shadowColor = [UIColor blackColor].CGColor;
    _secondOptionButton.layer.shadowOffset = CGSizeMake(0.5f, 2.0f);
    _secondOptionButton.layer.shadowOpacity = 0.5f;
    [questionView addSubview:_secondOptionButton];
    
    _thirdOptionButton = [[UIButton alloc] initWithFrame:CGRectMake(20, _secondOptionButton.frame.origin.y + _secondOptionButton.frame.size.height + 10, questionView.frame.size.width - 40, (questionView.frame.size.height - _questionLabel.frame.size.height)/4 - 10)];
    [_thirdOptionButton setTitle:@"third option" forState:UIControlStateNormal];
    [_thirdOptionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _thirdOptionButton.backgroundColor = [UIColor colorWithRed:(19/255.0) green:(64/255.0) blue:(136/255.0) alpha:1];
    _thirdOptionButton.layer.shadowColor = [UIColor blackColor].CGColor;
    _thirdOptionButton.layer.shadowOffset = CGSizeMake(0.5f, 2.0f);
    _thirdOptionButton.layer.shadowOpacity = 0.5f;
    [questionView addSubview:_thirdOptionButton];
    
    _fourthOptionButton = [[UIButton alloc] initWithFrame:CGRectMake(20, _thirdOptionButton.frame.origin.y + _thirdOptionButton.frame.size.height + 10, questionView.frame.size.width - 40, (questionView.frame.size.height - _questionLabel.frame.size.height)/4 - 10)];
    [_fourthOptionButton setTitle:@"fourth option" forState:UIControlStateNormal];
    [_fourthOptionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _fourthOptionButton.backgroundColor = [UIColor colorWithRed:(19/255.0) green:(64/255.0) blue:(136/255.0) alpha:1];
    _fourthOptionButton.layer.shadowColor = [UIColor blackColor].CGColor;
    _fourthOptionButton.layer.shadowOffset = CGSizeMake(0.5f, 2.0f);
    _fourthOptionButton.layer.shadowOpacity = 0.5f;
    [questionView addSubview:_fourthOptionButton];
}

@end
