//
//  EvilHangmanGame.h
//  Hangman
//
//  Created by Aseem on 7/20/13.
//  Copyright (c) 2013 edu.harvard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EvilHangmanGame : NSObject


// PROPERTIES

// string displayed to the user and the basis for the equivalence classes
@property (copy, nonatomic, readonly) NSMutableString *displayWord; 

// no. of guesses displayed to user
@property (assign, readonly) int numGuessesRemaining;

// longest word length in plist
@property (assign, readonly) int longestWordLength;

// shortest word length in plist
@property (assign, readonly) int shortestWordLength;    


// PUBLIC METHODS


// initializer that takes in the no. of guesses allowed
// and the number of letters allowed in the word
- (EvilHangmanGame *) initWithNumGuessesAllowed: (int) numGuesses
                                 withNumLetters: (int) numLetters;


// reads in the entire plist into an array and determines the
// shortest and longest word lengths
- (void) loadAllWords;


// resets the game to the current settings and scopes the current
// word list to those that meet the word length requirements
- (void) startGameWithNumGuesses: (int)numGuesses
                  withNumLetters: (int)numLetters;


// updates the game's state based on the letter chosen by the user
// does the appropriate equivalence class analysis
- (void) updateGame: (NSString *) letter;


// Determine if game is over
// 0 - game is NOT over
// 1 - the user won (no remaining spaces to be guessed)
// 2 - the user lost (no guesses remaining)
- (int) isGameOver;



// returns the first word in the current set of possible word choices
- (NSString *) getGuessWord;

// These methods are used to handle low memory warnings.
// They will save & reload the current list of words to &
// from disk respectively.
- (void) saveWords;
- (void) loadWords;
- (BOOL) wordsNeedToBeLoadedFromMemory;


@end
