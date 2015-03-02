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
#import "../gameaction/GameActionManager.h"
#import "../gesture/PanGestureController.h"


// -----------------------------------------------------------------------------
/// @brief The DiscardFutureMovesAlertController class displays an alert and
/// executes a command, working as a delegate on behalf of PanGestureController
/// and NavigationBarController.
// -----------------------------------------------------------------------------
@interface DiscardFutureMovesAlertController : NSObject <UIAlertViewDelegate,
                                                         PanGestureControllerDelegate,
                                                         GameActionManagerCommandDelegate>
{
}

@end
