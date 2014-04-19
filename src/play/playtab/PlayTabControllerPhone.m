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
#import "PlayTabControllerPhone.h"
#import "../boardposition/BoardPositionToolbarController.h"
#import "../controller/DiscardFutureMovesAlertController.h"
#import "../controller/NavigationBarController.h"
#import "../controller/StatusViewController.h"
#import "../gesture/PanGestureController.h"
#import "../playview/PlayView.h"
#import "../playview/PlayViewController.h"
#import "../playview/ScrollViewController.h"
#import "../../ui/UiElementMetrics.h"


@implementation PlayTabControllerPhone

// -----------------------------------------------------------------------------
/// @brief Initializes a PlayTabControllerPhone object.
///
/// @note This is the designated initializer of PlayTabControllerPhone.
// -----------------------------------------------------------------------------
- (id) init
{
  // Call designated initializer of superclass (PlayTabController)
  self = [super initWithNibName:nil bundle:nil];
  if (! self)
    return nil;
  [self setupChildControllers];
  return self;
}

// -----------------------------------------------------------------------------
/// @brief Deallocates memory allocated by this PlayTabControllerPhone object.
// -----------------------------------------------------------------------------
- (void) dealloc
{
  [self releaseObjects];
  [super dealloc];
}

// -----------------------------------------------------------------------------
/// This is an internal helper invoked during initialization.
// -----------------------------------------------------------------------------
- (void) setupChildControllers
{
  self.navigationBarController = [[[NavigationBarController alloc] init] autorelease];
  self.scrollViewController = [[[ScrollViewController alloc] init] autorelease];
  self.boardPositionToolbarController = [[[BoardPositionToolbarController alloc] init] autorelease];
  self.discardFutureMovesAlertController = [[[DiscardFutureMovesAlertController alloc] init] autorelease];

  self.scrollViewController.playViewController.panGestureController.delegate = self.discardFutureMovesAlertController;
  self.navigationBarController.delegate = self.discardFutureMovesAlertController;
}

// -----------------------------------------------------------------------------
/// @brief Private helper.
// -----------------------------------------------------------------------------
- (void) releaseObjects
{
  self.navigationBarController = nil;
  self.scrollViewController = nil;
  self.boardPositionToolbarController = nil;
  self.discardFutureMovesAlertController = nil;
}

// -----------------------------------------------------------------------------
/// @brief Private setter implementation.
// -----------------------------------------------------------------------------
- (void) setNavigationBarController:(NavigationBarController*)navigationBarController
{
  if (_navigationBarController == navigationBarController)
    return;
  if (_navigationBarController)
  {
    [_navigationBarController willMoveToParentViewController:nil];
    // Automatically calls didMoveToParentViewController:
    [_navigationBarController removeFromParentViewController];
    [_navigationBarController release];
    _navigationBarController = nil;
  }
  if (navigationBarController)
  {
    // Automatically calls willMoveToParentViewController:
    [self addChildViewController:navigationBarController];
    [_navigationBarController didMoveToParentViewController:self];
    [navigationBarController retain];
    _navigationBarController = navigationBarController;
  }
}

// -----------------------------------------------------------------------------
/// @brief Private setter implementation.
// -----------------------------------------------------------------------------
- (void) setScrollViewController:(ScrollViewController*)scrollViewController
{
  if (_scrollViewController == scrollViewController)
    return;
  if (_scrollViewController)
  {
    [_scrollViewController willMoveToParentViewController:nil];
    // Automatically calls didMoveToParentViewController:
    [_scrollViewController removeFromParentViewController];
    [_scrollViewController release];
    _scrollViewController = nil;
  }
  if (scrollViewController)
  {
    // Automatically calls willMoveToParentViewController:
    [self addChildViewController:scrollViewController];
    [scrollViewController didMoveToParentViewController:self];
    [scrollViewController retain];
    _scrollViewController = scrollViewController;
  }
}

// -----------------------------------------------------------------------------
/// @brief Private setter implementation.
// -----------------------------------------------------------------------------
- (void) setBoardPositionToolbarController:(BoardPositionToolbarController*)boardPositionToolbarController
{
  if (_boardPositionToolbarController == boardPositionToolbarController)
    return;
  if (_boardPositionToolbarController)
  {
    [_boardPositionToolbarController willMoveToParentViewController:nil];
    // Automatically calls didMoveToParentViewController:
    [_boardPositionToolbarController removeFromParentViewController];
    [_boardPositionToolbarController release];
    _boardPositionToolbarController = nil;
  }
  if (boardPositionToolbarController)
  {
    // Automatically calls willMoveToParentViewController:
    [self addChildViewController:boardPositionToolbarController];
    [boardPositionToolbarController didMoveToParentViewController:self];
    [boardPositionToolbarController retain];
    _boardPositionToolbarController = boardPositionToolbarController;
  }
}

// -----------------------------------------------------------------------------
/// @brief UIViewController method.
// -----------------------------------------------------------------------------
- (void) loadView
{
  [super loadView];

  [self setupViewHierarchy];
  [self setupAutoLayoutConstraints];
  [self configureViewObjects];
}

// -----------------------------------------------------------------------------
/// @brief Private helper for loadView.
// -----------------------------------------------------------------------------
- (void) setupViewHierarchy
{
  [self.view addSubview:self.navigationBarController.view];
  [self.view addSubview:self.boardPositionToolbarController.view];
  [self.view addSubview:self.scrollViewController.view];
  NSArray* scrollViews = [NSArray arrayWithObjects:
                          self.scrollViewController.playViewController.playView.coordinateLabelsLetterViewScrollView,
                          self.scrollViewController.playViewController.playView.coordinateLabelsNumberViewScrollView,
                          nil];
  for (UIView* scrollView in scrollViews)
  {
    [self.view addSubview:scrollView];
  }
}

// -----------------------------------------------------------------------------
/// @brief Private helper for loadView.
// -----------------------------------------------------------------------------
- (void) setupAutoLayoutConstraints
{
  PlayView* playView = self.scrollViewController.playViewController.playView;
  NSDictionary* viewsDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                   self.navigationBarController.view, @"navigationBarView",
                                   self.scrollViewController.view, @"scrollView",
                                   playView.coordinateLabelsLetterViewScrollView, @"coordinateLabelsLetterView",
                                   playView.coordinateLabelsNumberViewScrollView, @"coordinateLabelsNumberView",
                                   self.boardPositionToolbarController.view, @"boardPositionToolbarView",
                                   nil];
  // TODO xxx use methods from UiElementMetrics
  // - 20 = [UiElementMetrics statusBarHeight], this should be 0 in iOS 6
  // - 44 = [UiElementMetrics navigationBarHeight] or
  //        [UiElementMetrics toolbarHeight]
  // - 49 = [UiElementMetrics tabBarHeight]
  NSArray* visualFormats = [NSArray arrayWithObjects:
                            @"H:|-0-[navigationBarView]-0-|",
                            @"H:|-0-[scrollView]-0-|",
                            @"H:|-0-[boardPositionToolbarView]-0-|",
                            @"H:|-0-[coordinateLabelsLetterView]-0-|",
                            @"H:|-0-[coordinateLabelsNumberView]",
                            @"V:|-20-[navigationBarView(>=44,<=44)]-0-[scrollView]-0-[boardPositionToolbarView(>=44,<=44)]-49-|",
                            @"V:|-20-[navigationBarView(>=44,<=44)]-0-[coordinateLabelsLetterView]",
                            @"V:|-20-[navigationBarView(>=44,<=44)]-0-[coordinateLabelsNumberView]",
                            nil];
  for (NSString* visualFormat in visualFormats)
  {
    NSArray* constraint = [NSLayoutConstraint constraintsWithVisualFormat:visualFormat
                                                                  options:0
                                                                  metrics:nil
                                                                    views:viewsDictionary];

    [self.view addConstraints:constraint];
  }
}

// -----------------------------------------------------------------------------
/// @brief Private helper for loadView.
// -----------------------------------------------------------------------------
- (void) configureViewObjects
{
  self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:woodenBackgroundImageResource]];
  self.navigationBarController.statusViewController.playView = self.scrollViewController.playViewController.playView;
}

@end
