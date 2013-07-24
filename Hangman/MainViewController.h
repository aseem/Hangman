//
//  MainViewController.h
//  Hangman
//
//  Created by Aseem on 7/20/13.
//  Copyright (c) 2013 edu.harvard. All rights reserved.
//

#import "FlipsideViewController.h"
#import "EvilHangmanGame.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>

// PUBLIC PROPERTIES & ACTIONS

@property (nonatomic) IBOutletCollection(UIButton) NSArray *inputButtons;
@property (nonatomic) IBOutlet UILabel *wordDisplay;
@property (nonatomic) IBOutlet UILabel *labelNumGuesses;
@property (nonatomic) IBOutlet UILabel *labelEndOfGameStatus;
@property (nonatomic) IBOutlet UILabel *labelCorrectWord;

- (IBAction)showInfo:(id)sender;
- (IBAction)newGame:(UIButton *)sender;
- (IBAction)keyPress:(UIButton *)sender;


@end
