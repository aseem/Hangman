//
//  EvilHangmanGame.m
//  Hangman
//
//  Created by Aseem on 7/20/13.
//  Copyright (c) 2013 edu.harvard. All rights reserved.
//

#import "EvilHangmanGame.h"

#define MYDEBUG 0

@interface EvilHangmanGame ()
{
    // PRIVATE INSTANCE VARIABLES
    
    int _numLettersRemainingInWord;     // number of letters to be guessed in the word
    NSMutableArray *_allWords;          // all the words loaded from the plist
    NSMutableArray *_currentWords;      // the current set of words
    int _wordLength;                    // the length the word can be
    NSMutableDictionary *_eqClasses;    // dictionary to hold equivalence classes
}

// PRIVATE HELPER METHODS
- (int) numSpacesRemaining: (NSString *) word;
- (NSMutableString *) generateEquivalenceClassWithLetter: (NSString *) letter
                                    usingWord: (NSMutableString *) word;

@end



@implementation EvilHangmanGame


// default initializer
- (EvilHangmanGame *) init
{
    self = [super init];
    
    if (self)
    {
        _displayWord = [[NSMutableString alloc] initWithCapacity:_longestWordLength];
        _numGuessesRemaining = 10;
        _wordLength = 5;
        _numLettersRemainingInWord = 0;
        _currentWords = [[NSMutableArray alloc] init];
        _eqClasses = [[NSMutableDictionary alloc] init];
        
        // read the plist and set appropriate metadata about the word list
        [self loadAllWords];
        
        // start a new game with the given params
        [self startGameWithNumGuesses:_numGuessesRemaining withNumLetters:_wordLength];
    }
    
    return self;
}



- (EvilHangmanGame *) initWithNumGuessesAllowed: (int) numGuesses
                                 withNumLetters: (int) numLetters
{
    self = [super init];
    
    if (self)
    {
        _displayWord = [[NSMutableString alloc] initWithCapacity:_longestWordLength];
        _numGuessesRemaining = numGuesses;
        _wordLength = numLetters;
        _numLettersRemainingInWord = numLetters;
        _currentWords = [[NSMutableArray alloc] init];
        _eqClasses = [[NSMutableDictionary alloc] init];
        
        // read the plist and set appropriate metadata about the word list
        [self loadAllWords];
        
        // start a new game with the given params
        [self startGameWithNumGuesses:numGuesses withNumLetters:numLetters];
    }
    
    return self;
}



- (void) loadAllWords
{
    // initializations
    int length = 0;
    _longestWordLength = 1;
    _shortestWordLength = 1;
    
    // load the plist into the _allWords array
    NSString *fileWithPath = [[NSBundle mainBundle] pathForResource:@"words" ofType:@"plist"];
    _allWords = [[NSMutableArray alloc] initWithContentsOfFile:fileWithPath];
    
    // Find the shortest/longest word in _allWords
    for (NSString *myWord in _allWords)
    {
        length = [myWord length];
        if (length > _longestWordLength)
            _longestWordLength = length;
        
        if (length < _shortestWordLength)
            _shortestWordLength = length;
    }
}



- (void) startGameWithNumGuesses: (int)numGuesses
                    withNumLetters: (int)numLetters
{
    // get words of the appropriate length
    
    // initializations
    int length = 0;
    _numGuessesRemaining = numGuesses;
    _wordLength = numLetters;
    
    // place only the words of the right length from _allWords
    // into _currentWords
    [_currentWords removeAllObjects];
    for (NSString *myWord in _allWords)
    {
        length = [myWord length];
        if (length == _wordLength)
            [_currentWords addObject:myWord];
    }
    
    // update the word to be displayed to the user
    [_displayWord setString:@""];
    [_displayWord setString:[_displayWord stringByPaddingToLength:_wordLength
                                                       withString:@"-"
                                                  startingAtIndex:0]];

    #if MYDEBUG
        NSLog(@" ");
        NSLog(@"Starting game...");
        NSLog(@"%d words possible out of a total of %d",
              [_currentWords count], [_allWords count]);
    #endif
   

    
    // we won't need the entire dictionary anymore
    [_allWords removeAllObjects];
    _allWords = nil;
    
    
}



- (void) updateGame:(NSString *)letter
{
    NSMutableString *eqClass;
    NSMutableArray *wordEntries;
    
    // capture the number of spaces remaining to be guessed ... use this for
    // comparison later
    int startingNumberOfSpacesInWord = [self numSpacesRemaining:_displayWord];
    
    // clear the eq Class dictionary
    [_eqClasses removeAllObjects];   
    
    // this loop goes through each word in the current set of words
    // and determines each equivalence class.  It then adds
    // the word into the dictionary of all equivalence classes
    for (NSMutableString *myWord in _currentWords)
    {
        // Generate the NSString that represents the equivalence class
        // for a specific word
        eqClass = [self generateEquivalenceClassWithLetter:letter usingWord:myWord];
        
        wordEntries = (NSMutableArray *)[_eqClasses objectForKey:eqClass];
        
        if (wordEntries == nil)
        {
            wordEntries = [[NSMutableArray alloc] init];
        }
        
        [wordEntries addObject:myWord];
        [_eqClasses setObject:wordEntries forKey:eqClass];
    }
    
    // This section of code determines the largest equivalence class
    // and provides a pseudo-random algorithm for breaking ties in order
    // to prolong the game.
    
    BOOL completeEquivalenceClassIsLargest = NO;
    int largestNumberOfEntries = 0;
    
    // loop to determine the largest equivalence class remaining
    for (NSMutableString *eqClass in _eqClasses)
    {
        int numEntries = [[_eqClasses objectForKey:eqClass] count];
        
        // the tie breaker is if we can choose an equivalence class
        // that does not lead to the player winning.
        if ((numEntries == largestNumberOfEntries) &&
            completeEquivalenceClassIsLargest == YES)
        {
            largestNumberOfEntries = numEntries;
            _displayWord = [NSMutableString stringWithString:eqClass];
            [_currentWords removeAllObjects];
            _currentWords = [_eqClasses objectForKey:eqClass];
        }
        
        if (numEntries > largestNumberOfEntries)
        {
            if ([self numSpacesRemaining:eqClass] == 0)
                completeEquivalenceClassIsLargest = YES;
            else
                completeEquivalenceClassIsLargest = NO;
            
            largestNumberOfEntries = numEntries;
            _displayWord = [NSMutableString stringWithString:eqClass];
            [_currentWords removeAllObjects];
            _currentWords = [_eqClasses objectForKey:eqClass];
        }
    }
    
    // Now that we have the largest equivalence class and know what to
    // display to the user via _displayWord, the last thing to do is
    // to determine how many (if any) spaces have been updated and
    // adjust the remaining guesses accordingly.
    _numLettersRemainingInWord = [self numSpacesRemaining:_displayWord];
    if (_numLettersRemainingInWord == startingNumberOfSpacesInWord)
        _numGuessesRemaining--;
    
    #if MYDEBUG
        NSLog(@"No. of possible words remaining: %d", [_currentWords count]);
    #endif  
}



- (int) isGameOver
{
    if (_numLettersRemainingInWord == 0)
        return 1;
    if (_numGuessesRemaining == 0)
        return 2;
    
    return 0;
}



- (NSString *) getGuessWord
{
    return [_currentWords objectAtIndex:0];
}


- (void) saveWords
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:_currentWords forKey:@"words"];
    [defaults synchronize];
    _currentWords = nil;
}



- (void) loadWords
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _currentWords = [NSMutableArray arrayWithArray:[defaults objectForKey:@"words"]];
}



- (BOOL) wordsNeedToBeLoadedFromMemory
{
    if (_currentWords == nil)
        return YES;
    else
        return NO;
    
}



// HELPER METHODS


// helper method to determine the number of "-" in a given word
- (int) numSpacesRemaining: (NSString *) word
{
    int count = 0;
    int length = [word length];
    NSRange range = NSMakeRange(0, length);
    
    while (range.location != NSNotFound)
    {
        range = [word rangeOfString:@"-" options:0 range:range];
        if (range.location != NSNotFound)
        {
            range = NSMakeRange(range.location + range.length, length - (range.location + range.length));
            count++;
        }
    }
    
    return count;
}

// helper method that determines the equivalence class for a given word
- (NSMutableString *) generateEquivalenceClassWithLetter: (NSString *) letter
                                               usingWord: (NSMutableString *) word;
{
    // initializations
    NSMutableString *wordToCheck = [word copy];     // make a copy of the word we want to check
    NSMutableString *eqClass = [_displayWord copy]; // starting point for the eq class
    NSRange currentIndex = NSMakeRange(0,1);
    int previousIndex = 0;
    
    while (YES)
    {
        //NSLog(@"Word: %@", tempWord);
        currentIndex = [wordToCheck rangeOfString:letter];
        
        if (currentIndex.location != NSNotFound)
        {
            currentIndex.location += previousIndex;
            eqClass = (NSMutableString *)[eqClass
                                               stringByReplacingCharactersInRange:currentIndex
                                               withString:letter ];
            currentIndex.location -= previousIndex;
            previousIndex += currentIndex.location + 1;
            
        }
        else
        {
            break;
        }
        
        // remove the part of the string we have already scanned
        wordToCheck = (NSMutableString *)[wordToCheck substringFromIndex:(currentIndex.location+1)];
    }
    
    return eqClass;
}

@end
