// -----------------------------------------------------------------------------
// Copyright 2011-2014 Patrick Näf (herzbube@herzbube.ch)
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


// -----------------------------------------------------------------------------
/// @brief The UiElementMetrics class is a container for functions that return
/// the sizes of various user interface elements.
///
/// The metrics returned by functions of UiElementMetrics take into account the
/// device that the application is running on, and the current orientation of
/// the device.
///
/// For the latter to work, someone must invoke setInterfaceOrientationSource:()
/// before clients start to invoke metrics methods. Usually this is done by the
/// application delegate early on during application startup.
///
/// All functions in UiElementMetrics are class methods, so there is no need to
/// create an instance of UiElementMetrics.
///
/// Useful references and functions:
/// - http://www.idev101.com/code/User_Interface/sizes.html
///
/// @note Most of the values returned by the methods in this class have been
/// determined experimentally, either in Interface Builder, or by running a
/// debug session and looking at the various UI element's frames.
// -----------------------------------------------------------------------------
@interface UiElementMetrics : NSObject
{
}

+ (void) setInterfaceOrientationSource:(UIViewController*)interfaceOrientationSource;

+ (int) screenWidth;
+ (int) screenHeight;
+ (int) screenWidthLandscape;
+ (CGRect) applicationFrame;
+ (int) statusBarHeight;
+ (CGFloat) horizontalSpacingSiblings;
+ (CGFloat) verticalSpacingSiblings;
+ (CGFloat) horizontalSpacingSuperview;
+ (CGFloat) verticalSpacingSuperview;
+ (int) switchWidth;
+ (int) tableViewCellWidth;
+ (int) tableViewCellMarginHorizontal;
+ (int) tableViewCellContentViewWidth;
+ (int) tableViewCellContentViewHeight;
+ (int) tableViewCellContentViewAvailableWidth;
+ (int) tableViewCellContentDistanceFromEdgeHorizontal;
+ (int) tableViewCellContentDistanceFromEdgeVertical;
+ (int) tableViewCellDisclosureIndicatorWidth;
+ (int) splitViewControllerLeftPaneWidth;
+ (CGSize) toolbarIconSize;

@end
