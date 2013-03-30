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
#import "HandleDocumentInteraction.h"
#import "../archive/ArchiveViewModel.h"
#import "../main/ApplicationDelegate.h"
#import "../utility/PathUtilities.h"


@implementation HandleDocumentInteraction

// -----------------------------------------------------------------------------
/// @brief Executes this command. See the class documentation for details.
// -----------------------------------------------------------------------------
- (bool) doIt
{
  bool success = [self moveDocumentInteractionFileToArchive];
  if (success)
  {
    [[NSNotificationCenter defaultCenter] postNotificationName:archiveContentChanged object:nil];
    [[ApplicationDelegate sharedDelegate] activateTab:TabTypeArchive];
  }
  return success;
}

// -----------------------------------------------------------------------------
/// @brief Private helper for doIt().
// -----------------------------------------------------------------------------
- (bool) moveDocumentInteractionFileToArchive
{
  ApplicationDelegate* delegate = [ApplicationDelegate sharedDelegate];
  if (! delegate.documentInteractionURL)
    return false;
  NSString* documentInteractionFilePath = [delegate.documentInteractionURL path];
  NSString* documentInteractionFileName = [documentInteractionFilePath lastPathComponent];
  NSString* preferredGameName = [documentInteractionFileName stringByDeletingPathExtension];
  ArchiveViewModel* model = delegate.archiveViewModel;
  NSString* uniqueGameName = [model uniqueGameNameForName:preferredGameName];
  NSString* uniqueFilePath = [model filePathForGameWithName:uniqueGameName];
  NSError* error;
  BOOL success = [PathUtilities moveItemAtPath:documentInteractionFilePath overwritePath:uniqueFilePath error:&error];
  if (success)
  {
    NSString* message = [NSString stringWithFormat:@"You will find the imported game in the archive under this name:\n\n%@",
                         uniqueGameName];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Game import succeeded"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Ok", nil];
    alert.tag = AlertViewTypeHandleDocumentInteractionSucceeded;
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    [alert release];
    return true;
  }
  else
  {
    // We don't know what exactly went wrong, so we delete both files to be on
    // the safe side
    [PathUtilities deleteItemIfExists:documentInteractionFilePath];
    [PathUtilities deleteItemIfExists:uniqueFilePath];
    NSString* message = [NSString stringWithFormat:@"Failed to import game into archive. Reason: %@",
                         [error localizedDescription]];
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Failed to import game"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Ok", nil];
    alert.tag = AlertViewTypeHandleDocumentInteractionFailed;
    [alert performSelectorOnMainThread:@selector(show) withObject:nil waitUntilDone:YES];
    [alert release];
    return false;
  }
}

@end
