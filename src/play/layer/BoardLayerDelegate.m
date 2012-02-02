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


// Project includes
#import "BoardLayerDelegate.h"
#import "../PlayViewMetrics.h"
#import "../PlayViewModel.h"


// -----------------------------------------------------------------------------
/// @brief Class extension with private methods for BoardLayerDelegate.
// -----------------------------------------------------------------------------
@interface BoardLayerDelegate()
@end


@implementation BoardLayerDelegate


- (void) drawLayer:(CALayer*)layer inContext:(CGContextRef)context
{
  CGContextSetFillColorWithColor(context, self.playViewModel.boardColor.CGColor);
  CGContextFillRect(context, CGRectMake(self.playViewMetrics.topLeftBoardCornerX + gHalfPixel,
                                        self.playViewMetrics.topLeftBoardCornerY + gHalfPixel,
                                        self.playViewMetrics.boardSize,
                                        self.playViewMetrics.boardSize));
}

@end
