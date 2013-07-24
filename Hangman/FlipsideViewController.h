//
//  FlipsideViewController.h
//  Hangman
//
//  Created by Aseem on 7/20/13.
//  Copyright (c) 2013 edu.harvard. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

// some definitions for the max/min no. of guesses allowed
#define MAX_GUESS 26;
#define MIN_GUESS 1;

// protocol to be a delegate for the FlipsideViewController
@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

// definition of the FlipsideViewController
@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

// various UI in the nib
@property (nonatomic) IBOutlet UISlider *sliderWordLength;
@property (nonatomic) IBOutlet UILabel *labelWordLength;
@property (nonatomic) IBOutlet UISlider *sliderNumGuessesAllowed;
@property (nonatomic) IBOutlet UILabel *labelNumGuessesAllowed;

// properties to hold the shortest and longest word length allowed
@property (assign) int longestWordLength;
@property (assign) int shortestWordLength;

- (IBAction)done:(id)sender;
- (IBAction)wordLengthSliderMoved:(UISlider *)sender;
- (IBAction)numberOfGuessesSliderMoved:(UISlider *)sender;

@end
