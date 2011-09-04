// -----------------------------------------------------------------------------
// Copyright 2011 Patrick Näf (herzbube@herzbube.ch)
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// -----------------------------------------------------------------------------


// System includes
#import <UIKit/UIKit.h>

// Forward declarations
@class PlayView;


// -----------------------------------------------------------------------------
/// @brief The PlayViewController class is responsible for managing user
/// interaction on the "Play" view.
///
/// PlayViewController reacts to the following user input:
/// - Dragging, or panning, gesture in the view's Go board area
///   This is used to place a stone on the board.
/// - Tapping gesture on buttons that trigger a Go move
/// - Tapping gesture on the "Game Actions" button
// -----------------------------------------------------------------------------
@interface PlayViewController : UIViewController <UIGestureRecognizerDelegate>
{
}

/// @brief The view that PlayViewController is responsible for.
@property(nonatomic, retain) IBOutlet PlayView* playView;
/// @brief The toolbar that displays action buttons.
@property(nonatomic, retain) IBOutlet UIToolbar* toolbar;
/// @brief The "Play for me" button. Tapping this button causes the computer
/// player to generate a move for the human player whose turn it currently is.
@property(nonatomic, retain) IBOutlet UIBarButtonItem* playForMeButton;
/// @brief The "Pass" button. Tapping this button generates a "Pass" move for
/// the human player whose turn it currently is.
@property(nonatomic, retain) IBOutlet UIBarButtonItem* passButton;
/// @brief The "Undo" button. Tapping this button takes back the last move made
/// by a human player, including any computer player moves that were made in
/// response.
@property(nonatomic, retain) IBOutlet UIBarButtonItem* undoButton;
/// @brief The "Pause" button. Tapping this button causes the game to pause if
/// two computer players play against each other.
@property(nonatomic, retain) IBOutlet UIBarButtonItem* pauseButton;
/// @brief The "Continue" button. Tapping this button causes the game to
/// continue if it is paused while two computer players play against each other.
@property(nonatomic, retain) IBOutlet UIBarButtonItem* continueButton;
/// @brief Dummy button that creates an expanding space between the "New"
/// button and its predecessors.
@property(nonatomic, retain) IBOutlet UIBarButtonItem* flexibleSpaceButton;
/// @brief The "Game Actions" button. Tapping this button displays an action
/// sheet with actions that relate to Go games as a whole.
@property(nonatomic, retain) IBOutlet UIBarButtonItem* gameActionsButton;
/// @brief The gesture recognizer used to detect the dragging, or panning,
/// gesture.
@property(nonatomic, retain) UIPanGestureRecognizer* panRecognizer;
/// @brief True if a panning gesture is currently allowed, false if not (e.g.
/// while a computer player is thinking).
@property(getter=isPanningEnabled) bool panningEnabled;

@end
