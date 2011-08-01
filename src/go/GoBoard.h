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
@class GoPoint;


// -----------------------------------------------------------------------------
/// @brief The GoBoard class represents the Go board.
///
/// @ingroup go
///
/// The main property of GoBoard is its size. The size determines the board's
/// horizontal and vertical dimensions and thus the number of GoPoint objects
/// that may exist at any given time.
///
/// GoBoard is responsible for creating GoPoint objects and providing access to
/// these objects. A GoPoint object is identified by the coordinates of the
/// intersection it is located on, or by its association with its neighbouring
/// GoPoint objects in one of several directions (see #GoBoardDirection).
// -----------------------------------------------------------------------------
@interface GoBoard : NSObject
{
@private
  /// @brief Keys = Vertices as NSString objects, values = GoPoint objects
  NSMutableDictionary* m_vertexDict;
}

+ (GoBoard*) board;
+ (NSString*) stringForSize:(enum GoBoardSize)size;
+ (int) dimensionForSize:(enum GoBoardSize)size;
+ (enum GoBoardSize) sizeForDimension:(int)dimension;
- (NSEnumerator*) pointEnumerator;
- (GoPoint*) pointAtVertex:(NSString*)vertex;
- (GoPoint*) neighbourOf:(GoPoint*)point inDirection:(enum GoBoardDirection)direction;

/// @brief The board size, specifying the horizontal and vertical board
/// dimensions.
@property int size;

@end
