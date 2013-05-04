// -----------------------------------------------------------------------------
// Copyright 2013 Patrick Näf (herzbube@herzbube.ch)
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


// Project includes
#include "PlayTabController.h"

// Forward declarations
@class LeftPaneViewController;
@class RightPaneViewController;


// -----------------------------------------------------------------------------
/// @brief The PlayTabControllerPad class is the root view controller on the
/// "Play" tab for the iPad.
///
/// The PlayTabController class method playTabController() should be used to
/// create a PlayTabControllerPad instance.
// -----------------------------------------------------------------------------
@interface PlayTabControllerPad : PlayTabController
{
}

// Cannot name this property splitViewController, there already is a property
// of that name in UIViewController, and it has a different meaning
@property(nonatomic, retain) UISplitViewController* splitViewControllerChild;
@property(nonatomic, retain) LeftPaneViewController* leftPaneViewController;
@property(nonatomic, retain) RightPaneViewController* rightPaneViewController;

@end
