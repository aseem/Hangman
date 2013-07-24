//
//  FlipsideViewController.m
//  Hangman
//
//  Created by Aseem on 7/20/13.
//  Copyright (c) 2013 edu.harvard. All rights reserved.
//

#import "FlipsideViewController.h"

@interface FlipsideViewController ()

@end

@implementation FlipsideViewController


// called the when the view first loads
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set the MAX/MIN for the two sliders
    self.sliderWordLength.maximumValue = self.longestWordLength;
    self.sliderWordLength.minimumValue = self.shortestWordLength;
    self.sliderNumGuessesAllowed.maximumValue = MAX_GUESS;
    self.sliderNumGuessesAllowed.minimumValue = MIN_GUESS;
    
    // read the current slider values from defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.sliderWordLength.value = [defaults integerForKey:@"desiredWordLength"];
    self.sliderNumGuessesAllowed.value = [defaults integerForKey:@"desiredNumberOfGuesses"];
    
    // update the UI to show the current values
    self.labelWordLength.text = [NSString stringWithFormat:@"Desired Word Length: %d",
                                 (int)self.sliderWordLength.value];
    self.labelNumGuessesAllowed.text = [NSString stringWithFormat:@"Number of Guesses Allowed: %d",
                                        (int)self.sliderNumGuessesAllowed.value];    
}


// called when the OS sends a low-memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions


// called when the "done" button is clicked
- (IBAction)done:(id)sender
{
    // save the settings to NSDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:(int)self.sliderWordLength.value forKey:@"desiredWordLength"];
    [defaults setInteger:(int)self.sliderNumGuessesAllowed.value forKey:@"desiredNumberOfGuesses"];
    
    // call the appropriate method on the delegate controller to switch back
    [self.delegate flipsideViewControllerDidFinish:self];
}



// called when the word length slider is moved
- (IBAction)wordLengthSliderMoved:(UISlider *)sender
{
    // update the UI label with the current value
    self.labelWordLength.text = [NSString stringWithFormat:@"Desired Word Length: %d",
                                 (int)self.sliderWordLength.value];
}



// called when the number of guesses slider is moved
- (IBAction)numberOfGuessesSliderMoved:(UISlider *)sender
{
    // update the UI label with the current value
    self.labelNumGuessesAllowed.text = [NSString stringWithFormat:@"Number of Guesses Allowed: %d",
                                        (int)self.sliderNumGuessesAllowed.value];
}


// keep the screen in portrait mode
-(BOOL)shouldAutorotate
{
    return NO;
}
@end
