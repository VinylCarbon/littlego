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


// Forward declarations
@class GtpEngineProfileSelectionController;
@class GtpEngineProfile;


// -----------------------------------------------------------------------------
/// @brief The GtpEngineProfileSelectionDelegate protocol must be implemented
/// by the delegate of GtpEngineProfileSelectionController.
// -----------------------------------------------------------------------------
@protocol GtpEngineProfileSelectionDelegate
/// @brief This method is invoked when the user has finished working with
/// @a controller. The implementation is responsible for dismissing the modal
/// @a controller.
///
/// If @a didMakeSelection is true, the user has made a selection; the selected
/// profile object can be queried from the GtpEngineProfileSelectionController
/// object's property @a profile. If @a didMakeSelection is false, the user has
/// cancelled the selection.
- (void) gtpEngineProfileSelectionController:(GtpEngineProfileSelectionController*)controller didMakeSelection:(bool)didMakeSelection;
@end


// -----------------------------------------------------------------------------
/// @brief The GtpEngineProfileSelectionController class is responsible for
/// managing the view that lets the user select a GTP engine profile.
///
/// GtpEngineProfileSelectionController expects to be displayed modally by a
/// navigation controller. For this reason it populates its own navigation item
/// with controls that are then expected to be displayed in the navigation bar
/// of the parent navigation controller.
///
/// GtpEngineProfileSelectionController expects to be configured with a delegate
/// that can be informed of the result of data collection. For this to work, the
/// delegate must implement the protocol GtpEngineProfileSelectionDelegate.
// -----------------------------------------------------------------------------
@interface GtpEngineProfileSelectionController : UITableViewController
{
}

+ (GtpEngineProfileSelectionController*) controllerWithDelegate:(id<GtpEngineProfileSelectionDelegate>)delegate defaultProfile:(GtpEngineProfile*)profile;

/// @brief This is the delegate that will be informed about the result of data
/// collection.
@property(nonatomic, assign) id<GtpEngineProfileSelectionDelegate> delegate;
/// @brief The currently selected profile.
@property(nonatomic, retain) GtpEngineProfile* profile;

@end
