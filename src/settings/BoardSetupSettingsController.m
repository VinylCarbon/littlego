// -----------------------------------------------------------------------------
// Copyright 2019 Patrick Näf (herzbube@herzbube.ch)
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
#import "BoardSetupSettingsController.h"
#import "../main/ApplicationDelegate.h"
#import "../play/model/BoardSetupModel.h"
#import "../ui/TableViewCellFactory.h"


// -----------------------------------------------------------------------------
/// @brief Enumerates the sections presented in the "Board setup" user
/// preferences table view.
// -----------------------------------------------------------------------------
enum BoardSetupTableViewSection
{
  DoubleTapToZoomSection,
  AutoEnableBoardSetupModeSection,
  ChangeHandicapAlertSection,
  TryNotToPlaceIllegalStonesSection,
  MaxSection
};

// -----------------------------------------------------------------------------
/// @brief Enumerates items in the DoubleTapToZoomSection.
// -----------------------------------------------------------------------------
enum DoubleTapToZoomSectionItem
{
  DoubleTapToZoomItem,
  MaxDoubleTapToZoomSectionItem
};

// -----------------------------------------------------------------------------
/// @brief Enumerates items in the AutoEnableBoardSetupModeSection.
// -----------------------------------------------------------------------------
enum AutoEnableBoardSetupModeSectionItem
{
  AutoEnableBoardSetupModeItem,
  MaxAutoEnableBoardSetupModeSectionItem
};

// -----------------------------------------------------------------------------
/// @brief Enumerates items in the ChangeHandicapAlertSection.
// -----------------------------------------------------------------------------
enum ChangeHandicapAlertSectionItem
{
  ChangeHandicapAlertItem,
  MaxChangeHandicapAlertSectionItem
};

// -----------------------------------------------------------------------------
/// @brief Enumerates items in the TryNotToPlaceIllegalStonesSection.
// -----------------------------------------------------------------------------
enum TryNotToPlaceIllegalStonesSectionItem
{
  TryNotToPlaceIllegalStonesItem,
  MaxTryNotToPlaceIllegalStonesSectionItem
};


// -----------------------------------------------------------------------------
/// @brief Class extension with private properties for
/// BoardSetupSettingsController.
// -----------------------------------------------------------------------------
@interface BoardSetupSettingsController()
@property(nonatomic, assign) BoardSetupModel* boardSetupModel;
@end


@implementation BoardSetupSettingsController

#pragma mark - Initialization and deallocation

// -----------------------------------------------------------------------------
/// @brief Convenience constructor. Creates a BoardSetupSettingsController
/// instance of grouped style.
// -----------------------------------------------------------------------------
+ (BoardSetupSettingsController*) controller
{
  BoardSetupSettingsController* controller = [[BoardSetupSettingsController alloc] initWithStyle:UITableViewStyleGrouped];
  if (controller)
  {
    [controller autorelease];
    controller.boardSetupModel = [ApplicationDelegate sharedDelegate].boardSetupModel;
  }
  return controller;
}

// -----------------------------------------------------------------------------
/// @brief Deallocates memory allocated by this BoardSetupSettingsController
/// object.
// -----------------------------------------------------------------------------
- (void) dealloc
{
  self.boardSetupModel = nil;
  [super dealloc];
}

#pragma mark - UIViewController overrides

// -----------------------------------------------------------------------------
/// @brief UIViewController method.
// -----------------------------------------------------------------------------
- (void) viewDidLoad
{
  [super viewDidLoad];
  self.title = @"Board setup settings";
}

#pragma mark - UITableViewDataSource overrides

// -----------------------------------------------------------------------------
/// @brief UITableViewDataSource protocol method.
// -----------------------------------------------------------------------------
- (NSInteger) numberOfSectionsInTableView:(UITableView*)tableView
{
  return MaxSection;
}

// -----------------------------------------------------------------------------
/// @brief UITableViewDataSource protocol method.
// -----------------------------------------------------------------------------
- (NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
  switch (section)
  {
    case DoubleTapToZoomSection:
      return MaxDoubleTapToZoomSectionItem;
    case AutoEnableBoardSetupModeSection:
      return MaxAutoEnableBoardSetupModeSectionItem;
    case ChangeHandicapAlertSection:
      return MaxChangeHandicapAlertSectionItem;
    case TryNotToPlaceIllegalStonesSection:
      return MaxTryNotToPlaceIllegalStonesSectionItem;
    default:
      assert(0);
      break;
  }
  return 0;
}

// -----------------------------------------------------------------------------
/// @brief UITableViewDataSource protocol method.
// -----------------------------------------------------------------------------
- (NSString*) tableView:(UITableView*)tableView titleForFooterInSection:(NSInteger)section
{
  switch (section)
  {
    case DoubleTapToZoomSection:
      return @"In board setup mode you may want to quickly tap on the same intersection several times in a row, to cycle through the differently colored setup stones. This may trigger an unwanted double-tap gesture which causes the board to zoom in. When you find that this negatively affects you, you can disable the double-tap gesture for board setup mode only.";
    case AutoEnableBoardSetupModeSection:
      return @"If you enable this the app automatically switches to board setup mode when you start a new game. This can be useful if you want to create many games in a row that start with a board setup, for instance if you work on creating a Go problem collection.";
    case ChangeHandicapAlertSection:
      return @"You cannot undo removing a handicap stone in board setup mode, i.e. you cannot re-add a handicap stone once it is gone. Because of this an alert asks for confirmation each time you remove a handicap stone. If this alert annoys you, you can turn it off here.";
    case TryNotToPlaceIllegalStonesSection:
      return @"Instead of showing an alert each time you accidentally place an illegal stone in board setup mode, the app can try to find an alternative for you. This can help to improve the flow of setting up stairs or other complex board positions consisting of intertwined stone groups.";
    default:
      break;
  }
  return nil;
}

// -----------------------------------------------------------------------------
/// @brief UITableViewDataSource protocol method.
// -----------------------------------------------------------------------------
- (UITableViewCell*) tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
  UITableViewCell* cell = [TableViewCellFactory cellWithType:SwitchCellType tableView:tableView];
  UISwitch* accessoryView = (UISwitch*)cell.accessoryView;

  switch (indexPath.section)
  {
    case DoubleTapToZoomSection:
    {
      cell.textLabel.text = @"Double-tap to zoom";
      cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
      cell.textLabel.numberOfLines = 0;
      accessoryView.on = self.boardSetupModel.doubleTapToZoom;
      [accessoryView addTarget:self action:@selector(toggleDoubleTapToZoom:) forControlEvents:UIControlEventValueChanged];
      break;
    }
    case AutoEnableBoardSetupModeSection:
    {
      cell = [TableViewCellFactory cellWithType:SwitchCellType tableView:tableView];
      UISwitch* accessoryView = (UISwitch*)cell.accessoryView;
      cell.textLabel.text = @"Auto-enable board setup";
      accessoryView.on = self.boardSetupModel.autoEnableBoardSetupMode;
      [accessoryView addTarget:self action:@selector(toggleAutoEnableBoardSetupMode:) forControlEvents:UIControlEventValueChanged];
      break;
    }
    case ChangeHandicapAlertSection:
    {
      cell.textLabel.text = @"Change handicap alert";
      cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
      cell.textLabel.numberOfLines = 0;
      accessoryView.on = self.boardSetupModel.changeHandicapAlert;
      [accessoryView addTarget:self action:@selector(toggleChangeHandicapAlert:) forControlEvents:UIControlEventValueChanged];
      break;
    }
    case TryNotToPlaceIllegalStonesSection:
    {
      cell.textLabel.text = @"Try not to place illegal stones";
      cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
      cell.textLabel.numberOfLines = 0;
      accessoryView.on = self.boardSetupModel.tryNotToPlaceIllegalStones;
      [accessoryView addTarget:self action:@selector(toggleTryNotToPlaceIllegalStones:) forControlEvents:UIControlEventValueChanged];
      break;
    }
    default:
    {
      assert(0);
      break;
    }
  }
  return cell;
}

// -----------------------------------------------------------------------------
/// @brief UITableViewDelegate protocol method.
// -----------------------------------------------------------------------------
- (void) tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
  [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - Action handlers

// -----------------------------------------------------------------------------
/// @brief Reacts to a tap gesture on the "Double-tap to zoom" switch.
/// Writes the new value to the appropriate model.
// -----------------------------------------------------------------------------
- (void) toggleDoubleTapToZoom:(id)sender
{
  UISwitch* accessoryView = (UISwitch*)sender;
  self.boardSetupModel.doubleTapToZoom = accessoryView.on;
}

// -----------------------------------------------------------------------------
/// @brief Reacts to a tap gesture on the "Auto-enable board setup mode" switch.
/// Writes the new value to the appropriate model.
// -----------------------------------------------------------------------------
- (void) toggleAutoEnableBoardSetupMode:(id)sender
{
  UISwitch* accessoryView = (UISwitch*)sender;
  self.boardSetupModel.autoEnableBoardSetupMode = accessoryView.on;
}

// -----------------------------------------------------------------------------
/// @brief Reacts to a tap gesture on the "Change handicap alert" switch.
/// Writes the new value to the appropriate model.
// -----------------------------------------------------------------------------
- (void) toggleChangeHandicapAlert:(id)sender
{
  UISwitch* accessoryView = (UISwitch*)sender;
  self.boardSetupModel.changeHandicapAlert = accessoryView.on;
}

// -----------------------------------------------------------------------------
/// @brief Reacts to a tap gesture on the "Foo foo" switch.
/// Writes the new value to the appropriate model.
// -----------------------------------------------------------------------------
- (void) toggleTryNotToPlaceIllegalStones:(id)sender
{
  UISwitch* accessoryView = (UISwitch*)sender;
  self.boardSetupModel.tryNotToPlaceIllegalStones = accessoryView.on;
}

@end
