//
//  MainViewController.m
//  Hangman
//
//  Created by Aseem on 7/20/13.
//  Copyright (c) 2013 edu.harvard. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
{
     EvilHangmanGame *_myGame;      // represents the game's state
     int _desiredWordLength;        // the desired word length based on configuration
     int _desiredNumberOfGuesses;   // the desired no. of guesses based on configuration
}

@end

@implementation MainViewController

// called when the view first loads
// setup the initial game state
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // read the default configuration -- add the longest/shortest word lengths too
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _desiredWordLength = [defaults integerForKey:@"desiredWordLength"];
    if (_desiredWordLength == 0)
    {
        _desiredWordLength = 5;
        [defaults setInteger:_desiredWordLength forKey:@"desiredWordLength"];
    }
    
    _desiredNumberOfGuesses = [defaults integerForKey:@"desiredNumberOfGuesses"];
    if (_desiredNumberOfGuesses == 0)
    {
        _desiredNumberOfGuesses = 10;
        [defaults setInteger:_desiredNumberOfGuesses forKey:@"desiredNumberOfGuesses"];
    }

    
    // create and start the Game object
    _myGame = [[EvilHangmanGame alloc] initWithNumGuessesAllowed:_desiredNumberOfGuesses
                                                  withNumLetters:_desiredWordLength];

    // update the UI
    self.wordDisplay.text = _myGame.displayWord;
    self.labelNumGuesses.text = [NSString stringWithFormat:@"Guesses Remaining: %d", _myGame.numGuessesRemaining];
    self.labelEndOfGameStatus.hidden = YES;
    self.labelCorrectWord.hidden = YES;
}


// called when the OS sends a low-memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // store the current list of words to disk
    [_myGame saveWords];
    
}

#pragma mark - Flipside View

// called when the FlipsideViewController is finished
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // When called by the FlipsideViewController, save the slider values
    // into the appropriate instance variables
    _desiredWordLength = (int)controller.sliderWordLength.value;
    _desiredNumberOfGuesses = (int) controller.sliderNumGuessesAllowed.value;
}



// sets this controller as the delegate of the FlipsideViewController
// and then transitions to the FlipSide view
- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.shortestWordLength = _myGame.shortestWordLength;
    controller.longestWordLength = _myGame.longestWordLength;
    
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}



// called when the "New" button is selected.
// restarts the game
- (IBAction)newGame:(UIButton *)sender
{
    // re-start the Game object
    [_myGame loadAllWords];
    [_myGame startGameWithNumGuesses:_desiredNumberOfGuesses withNumLetters:_desiredWordLength];
    
    // update the UI
    [_inputButtons setValue:[NSNumber numberWithBool:NO] forKey:@"hidden"];
    self.wordDisplay.text = _myGame.displayWord;
    self.labelNumGuesses.text = [NSString stringWithFormat:@"Guesses Remaining: %d", _myGame.numGuessesRemaining];
    self.labelEndOfGameStatus.hidden = YES;
    self.labelCorrectWord.hidden = YES;
}



// called when a key in the "keyboard" is pressed
// updates the game status accordingly
- (IBAction)keyPress:(UIButton *)sender
{
    NSString *letter = [sender titleForState:UIControlStateNormal];
    int gameStatus = 0;
    
    // reload from memory if there was a low-memory warning
    if ([_myGame wordsNeedToBeLoadedFromMemory])
    {
        [_myGame loadWords];
    }
    
    // update the game status based on the letter selection
    [_myGame updateGame:letter];
    
    // update the UI
    self.wordDisplay.text = _myGame.displayWord;
    self.labelNumGuesses.text = [NSString stringWithFormat:@"Guesses Remaining: %d", _myGame.numGuessesRemaining];
    sender.hidden=YES;
    
    // check if the game is over and update the UI accordingly
    gameStatus = [_myGame isGameOver];
    
    if (gameStatus != 0)
    {
        // hide the keyboard
        [_inputButtons setValue:[NSNumber numberWithBool:YES] forKey:@"hidden"];
        
        if (gameStatus == 1)    // you won!
        {
            self.labelEndOfGameStatus.text = @"YOU WON!";
        }
        else    // you lost :-(
        {
            NSString *correctWord = [_myGame getGuessWord];
            self.labelEndOfGameStatus.text = @"YOU LOST! CORRECT WORD:";
            self.labelCorrectWord.text = correctWord;
            self.labelCorrectWord.hidden = NO;
            
        }
        
        self.labelEndOfGameStatus.hidden = NO;
        
    }
}



// keep the screen in portrait mode
-(BOOL)shouldAutorotate
{
    return NO;
}

@end
