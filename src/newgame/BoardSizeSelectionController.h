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
@class BoardSizeController;


// -----------------------------------------------------------------------------
/// @brief The BoardSizeDelegate protocol must be implemented by the delegate of
/// BoardSizeController.
// -----------------------------------------------------------------------------
@protocol BoardSizeDelegate
/// @brief This method is invoked when the user has finished working with
/// @a controller. The implementation is responsible for dismissing the
/// modal @a controller.
///
/// If @a didMakeSelection is true, the user has made a selection; the selected
/// board size can be queried from the BoardSizeController object's property
/// @a boardSize. If @a didMakeSelection is false, the user has cancelled the
/// selection.
- (void) boardSizeController:(BoardSizeController*)controller didMakeSelection:(bool)didMakeSelection;
@end


// -----------------------------------------------------------------------------
/// @brief The BoardSizeController class is responsible for managing the view
/// that lets the user select the board size.
///
/// BoardSizeController expects to be displayed modally by a navigation
/// controller. For this reason it populates its own navigation item with
/// controls that are then expected to be displayed in the navigation bar of
/// the parent navigation controller.
///
/// BoardSizeController expects to be configured with a delegate that can be
/// informed of the result of data collection. For this to work, the delegate
/// must implement the protocol BoardSizeDelegate.
// -----------------------------------------------------------------------------
@interface BoardSizeController : UITableViewController
{
}

+ (BoardSizeController*) controllerWithDelegate:(id<BoardSizeDelegate>)delegate defaultBoardSize:(enum GoBoardSize)boardSize;

/// @brief This is the delegate that will be informed about the result of data
/// collection.
@property(nonatomic, assign) id<BoardSizeDelegate> delegate;
/// @brief The currently selected board size.
@property enum GoBoardSize boardSize;

@end
