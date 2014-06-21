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


// Project includes
#import "TerritoryLayerDelegate.h"
#import "BoardViewDrawingHelper.h"
#import "../BoardTileView.h"
#import "../../model/PlayViewMetrics.h"
#import "../../model/ScoringModel.h"
#import "../../../go/GoBoard.h"
#import "../../../go/GoBoardRegion.h"
#import "../../../go/GoGame.h"
#import "../../../go/GoPoint.h"
#import "../../../go/GoScore.h"
#import "../../../go/GoVertex.h"
#import "../../../utility/UIColorAdditions.h"


CGLayerRef blackTerritoryLayer;
CGLayerRef whiteTerritoryLayer;
CGLayerRef inconsistentFillColorTerritoryLayer;
CGLayerRef inconsistentDotSymbolTerritoryLayer;
CGLayerRef deadStoneSymbolLayer;
CGLayerRef blackSekiStoneSymbolLayer;
CGLayerRef whiteSekiStoneSymbolLayer;


// -----------------------------------------------------------------------------
/// @brief Class extension with private properties for TerritoryLayerDelegate.
// -----------------------------------------------------------------------------
@interface BVTerritoryLayerDelegate()
@property(nonatomic, retain) ScoringModel* scoringModel;
/// @brief Store list of points to draw between notify:eventInfo:() and
/// drawLayer:inContext:(), and also between drawing cycles.
@property(nonatomic, retain) NSMutableDictionary* drawingPointsTerritory;
/// @brief Store list of points to draw between notify:eventInfo:() and
/// drawLayer:inContext:(), and also between drawing cycles.
@property(nonatomic, retain) NSMutableDictionary* drawingPointsStoneGroupState;
@property(nonatomic, retain) UIColor* territoryColorBlack;
@property(nonatomic, retain) UIColor* territoryColorWhite;
@property(nonatomic, retain) UIColor* territoryColorInconsistent;
@end


@implementation BVTerritoryLayerDelegate

// -----------------------------------------------------------------------------
/// @brief Initializes a TerritoryLayerDelegate object.
///
/// @note This is the designated initializer of TerritoryLayerDelegate.
// -----------------------------------------------------------------------------
- (id) initWithTileView:(BoardTileView*)tileView
                metrics:(PlayViewMetrics*)metrics
           scoringModel:(ScoringModel*)scoringModel
{
  // Call designated initializer of superclass (BoardViewLayerDelegateBase)
  self = [super initWithTileView:tileView metrics:metrics];
  if (! self)
    return nil;
  self.scoringModel = scoringModel;
  self.drawingPointsTerritory = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
  self.drawingPointsStoneGroupState = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
  self.territoryColorBlack = [UIColor colorWithWhite:0.0 alpha:scoringModel.alphaTerritoryColorBlack];
  self.territoryColorWhite = [UIColor colorWithWhite:1.0 alpha:scoringModel.alphaTerritoryColorWhite];
  self.territoryColorInconsistent = [scoringModel.inconsistentTerritoryFillColor colorWithAlphaComponent:scoringModel.inconsistentTerritoryFillColorAlpha];
  blackTerritoryLayer = NULL;
  whiteTerritoryLayer = NULL;
  inconsistentFillColorTerritoryLayer = NULL;
  inconsistentDotSymbolTerritoryLayer = NULL;
  deadStoneSymbolLayer = NULL;
  blackSekiStoneSymbolLayer = NULL;
  whiteSekiStoneSymbolLayer = NULL;
  return self;
}

// -----------------------------------------------------------------------------
/// @brief Deallocates memory allocated by this TerritoryLayerDelegate object.
// -----------------------------------------------------------------------------
- (void) dealloc
{
  self.scoringModel = nil;
  self.drawingPointsTerritory = nil;
  self.drawingPointsStoneGroupState = nil;
  self.territoryColorBlack = nil;
  self.territoryColorWhite = nil;
  self.territoryColorInconsistent = nil;
  [self invalidateLayers];
  [super dealloc];
}

// -----------------------------------------------------------------------------
/// @brief Invalidates the layers for marking up territory, and for marking dead
/// or seki stones.
///
/// When it is next invoked, drawLayer:inContext:() will re-create the layers.
// -----------------------------------------------------------------------------
- (void) invalidateLayers
{
  if (blackTerritoryLayer)
  {
    CGLayerRelease(blackTerritoryLayer);
    blackTerritoryLayer = NULL;
  }
  if (whiteTerritoryLayer)
  {
    CGLayerRelease(whiteTerritoryLayer);
    whiteTerritoryLayer = NULL;
  }
  if (inconsistentFillColorTerritoryLayer)
  {
    CGLayerRelease(inconsistentFillColorTerritoryLayer);
    inconsistentFillColorTerritoryLayer = NULL;
  }
  if (inconsistentDotSymbolTerritoryLayer)
  {
    CGLayerRelease(inconsistentDotSymbolTerritoryLayer);
    inconsistentDotSymbolTerritoryLayer = NULL;
  }
  if (deadStoneSymbolLayer)
  {
    CGLayerRelease(deadStoneSymbolLayer);
    deadStoneSymbolLayer = NULL;
  }
  if (blackSekiStoneSymbolLayer)
  {
    CGLayerRelease(blackSekiStoneSymbolLayer);
    blackSekiStoneSymbolLayer = NULL;
  }
  if (whiteSekiStoneSymbolLayer)
  {
    CGLayerRelease(whiteSekiStoneSymbolLayer);
    whiteSekiStoneSymbolLayer = NULL;
  }
}

// -----------------------------------------------------------------------------
/// @brief BoardViewLayerDelegate method.
// -----------------------------------------------------------------------------
- (void) notify:(enum BoardViewLayerDelegateEvent)event eventInfo:(id)eventInfo
{
  switch (event)
  {
    case BVLDEventRectangleChanged:
    {
      CGRect layerFrame = CGRectZero;
      layerFrame.size = self.playViewMetrics.tileSize;
      self.layer.frame = layerFrame;
      [self invalidateLayers];
      self.drawingPointsTerritory = [self calculateDrawingPointsTerritory];
      self.drawingPointsStoneGroupState = [self calculateDrawingPointsStoneGroupState];
      self.dirty = true;
      break;
    }
    case BVLDEventBoardSizeChanged:
    {
      [self invalidateLayers];
      self.drawingPointsTerritory = [self calculateDrawingPointsTerritory];
      self.drawingPointsStoneGroupState = [self calculateDrawingPointsStoneGroupState];
      self.dirty = true;
      break;
    }
    case BVLDEventScoreCalculationEnds:
    case BVLDEventInconsistentTerritoryMarkupTypeChanged:
    case BVLDEventScoringModeDisabled:
    {
      NSMutableDictionary* oldDrawingPointsTerritory = self.drawingPointsTerritory;
      NSMutableDictionary* newDrawingPointsTerritory = [self calculateDrawingPointsTerritory];
      // The dictionary must contain the territory markup style so that the
      // dictionary comparison detects whether the territory color changed, or
      // the inconsistent territory markup type changed
      if (! [oldDrawingPointsTerritory isEqualToDictionary:newDrawingPointsTerritory])
      {
        self.drawingPointsTerritory = newDrawingPointsTerritory;
        // Re-draw the entire layer. Further optimization could be made here
        // by only drawing that rectangle which is actually affected by
        // self.drawingPointsTerritory.
        self.dirty = true;
      }

      if (event != BVLDEventInconsistentTerritoryMarkupTypeChanged)
      {
        NSMutableDictionary* oldDrawingPointsStoneGroupState = self.drawingPointsStoneGroupState;
        NSMutableDictionary* newDrawingPointsStoneGroupState = [self calculateDrawingPointsStoneGroupState];
        // The dictionary must contain the stone group state so that the
        // dictionary comparison detects whether a state change occurred
        if (! [oldDrawingPointsStoneGroupState isEqualToDictionary:newDrawingPointsStoneGroupState])
        {
          self.drawingPointsStoneGroupState = newDrawingPointsStoneGroupState;
          // Re-draw the entire layer. Further optimization could be made here
          // by only drawing that rectangle which is actually affected by
          // self.drawingPointsStoneGroupState.
          self.dirty = true;
        }
      }
      break;
    }
    default:
    {
      break;
    }
  }
}

// -----------------------------------------------------------------------------
/// @brief CALayer delegate method.
// -----------------------------------------------------------------------------
- (void) drawLayer:(CALayer*)layer inContext:(CGContextRef)context
{
  CGRect tileRect = [BoardViewDrawingHelper canvasRectForTileView:self.tileView
                                                          metrics:self.playViewMetrics];
  GoBoard* board = [GoGame sharedGame].board;

  // Make sure that layers are created before drawing methods that use them are
  // invoked
  [self createLayersIfNecessaryWithContext:context];

  // Order is important: Later drawing methods draw their content over earlier
  // content
  [self drawTerritoryWithContext:context inTileRect:tileRect withBoard:board];
  [self drawStoneGroupStateWithContext:context inTileRect:tileRect withBoard:board];
}

// -----------------------------------------------------------------------------
/// @brief Private helper for drawLayer:inContext:().
// -----------------------------------------------------------------------------
- (void) createLayersIfNecessaryWithContext:(CGContextRef)context
{
  if (! blackTerritoryLayer)
    blackTerritoryLayer = BVCreateTerritoryLayer(context, TerritoryLayerTypeBlack, self.territoryColorBlack, 0, self.playViewMetrics);
  if (! whiteTerritoryLayer)
    whiteTerritoryLayer = BVCreateTerritoryLayer(context, TerritoryLayerTypeWhite, self.territoryColorWhite, 0, self.playViewMetrics);
  if (! inconsistentFillColorTerritoryLayer)
    inconsistentFillColorTerritoryLayer = BVCreateTerritoryLayer(context, TerritoryLayerTypeInconsistentFillColor, self.territoryColorInconsistent, 0, self.playViewMetrics);
  if (! inconsistentDotSymbolTerritoryLayer)
    inconsistentDotSymbolTerritoryLayer = BVCreateTerritoryLayer(context,
                                                                 TerritoryLayerTypeInconsistentDotSymbol,
                                                                 self.scoringModel.inconsistentTerritoryDotSymbolColor,
                                                                 self.scoringModel.inconsistentTerritoryDotSymbolPercentage,
                                                                 self.playViewMetrics);
  if (! deadStoneSymbolLayer)
    deadStoneSymbolLayer = BVCreateDeadStoneSymbolLayer(context, self.scoringModel.deadStoneSymbolPercentage, self.scoringModel.deadStoneSymbolColor, self.playViewMetrics);
  if (! blackSekiStoneSymbolLayer)
    blackSekiStoneSymbolLayer = BVCreateSquareSymbolLayer(context, self.scoringModel.blackSekiSymbolColor, self.playViewMetrics);
  if (! whiteSekiStoneSymbolLayer)
    whiteSekiStoneSymbolLayer = BVCreateSquareSymbolLayer(context, self.scoringModel.whiteSekiSymbolColor, self.playViewMetrics);
}

// -----------------------------------------------------------------------------
/// @brief Private helper for drawLayer:inContext:().
// -----------------------------------------------------------------------------
- (void) drawTerritoryWithContext:(CGContextRef)context inTileRect:(CGRect)tileRect withBoard:(GoBoard*)board
{
  [self.drawingPointsTerritory enumerateKeysAndObjectsUsingBlock:^(NSString* vertexString, NSNumber* territoryLayerTypeAsNumber, BOOL* stop){
    enum TerritoryLayerType territoryLayerType = [territoryLayerTypeAsNumber intValue];
    CGLayerRef layerToDraw = 0;
    switch (territoryLayerType)
    {
      case TerritoryLayerTypeBlack:
        layerToDraw = blackTerritoryLayer;
        break;
      case TerritoryLayerTypeWhite:
        layerToDraw = whiteTerritoryLayer;
        break;
      case TerritoryLayerTypeInconsistentFillColor:
        layerToDraw = inconsistentFillColorTerritoryLayer;
        break;
      case TerritoryLayerTypeInconsistentDotSymbol:
        layerToDraw = inconsistentDotSymbolTerritoryLayer;
        break;
      default:
        return;
    }
    GoPoint* point = [board pointAtVertex:vertexString];
    [BoardViewDrawingHelper drawLayer:layerToDraw
                          withContext:context
                      centeredAtPoint:point
                       inTileWithRect:tileRect
                          withMetrics:self.playViewMetrics];
  }];
}

// -----------------------------------------------------------------------------
/// @brief Private helper for drawLayer:inContext:().
// -----------------------------------------------------------------------------
- (void) drawStoneGroupStateWithContext:(CGContextRef)context inTileRect:(CGRect)tileRect withBoard:(GoBoard*)board
{
  [self.drawingPointsStoneGroupState enumerateKeysAndObjectsUsingBlock:^(NSString* vertexString, NSNumber* stoneGroupStateAsNumber, BOOL* stop){
    GoPoint* point = [board pointAtVertex:vertexString];
    enum GoStoneGroupState stoneGroupState = [stoneGroupStateAsNumber intValue];
    CGLayerRef layerToDraw = 0;
    switch (stoneGroupState)
    {
      case GoStoneGroupStateDead:
      {
        layerToDraw = deadStoneSymbolLayer;
        break;
      }
      case GoStoneGroupStateSeki:
      {
        switch (point.stoneState)
        {
          case GoColorBlack:
            layerToDraw = blackSekiStoneSymbolLayer;
            break;
          case GoColorWhite:
            layerToDraw = whiteSekiStoneSymbolLayer;
            break;
          default:
            DDLogError(@"Unknown value %d for property point.stoneState", point.stoneState);
            return;
        }
        break;
      }
      default:
      {
        DDLogError(@"Unknown value %d for property point.region.stoneGroupState", stoneGroupState);
        return;
      }
    }
    [BoardViewDrawingHelper drawLayer:layerToDraw
                          withContext:context
                      centeredAtPoint:point
                       inTileWithRect:tileRect
                          withMetrics:self.playViewMetrics];
  }];
}

// -----------------------------------------------------------------------------
/// @brief Returns a dictionary that identifies the points whose intersections
/// are located on this tile, and the markup style that should be used to draw
/// the territory for these points.
///
/// Dictionary keys are NSString objects that contain the intersection vertex.
/// The vertex string can be used to get the GoPoint object that corresponds to
/// the intersection.
///
/// Dictionary values are NSNumber objects that store a TerritoryLayerType enum
/// value. The value identifies the layer that needs to be drawn at the
/// intersection.
// -----------------------------------------------------------------------------
- (NSMutableDictionary*) calculateDrawingPointsTerritory
{
  NSMutableDictionary* drawingPoints = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
  GoGame* game = [GoGame sharedGame];
  if (! game.score.scoringEnabled)
    return drawingPoints;

  CGRect tileRect = [BoardViewDrawingHelper canvasRectForTileView:self.tileView
                                                          metrics:self.playViewMetrics];
  enum InconsistentTerritoryMarkupType inconsistentTerritoryMarkupType = self.scoringModel.inconsistentTerritoryMarkupType;

  // TODO: Currently we always iterate over all points. This could be
  // optimized: If the tile rect stays the same, we should already know which
  // points intersect with the tile, so we could fall back on a pre-filtered
  // list of points. On a 19x19 board this could save us quite a bit of time:
  // 381 points are iterated on 16 tiles (iPhone), i.e. over 6000 iterations.
  // on iPad where there are more tiles it is even worse.
  NSEnumerator* enumerator = [game.board pointEnumerator];
  GoPoint* point;
  while (point = [enumerator nextObject])
  {
    CGRect stoneRect = [BoardViewDrawingHelper canvasRectForStoneAtPoint:point
                                                                 metrics:self.playViewMetrics];
    if (! CGRectIntersectsRect(tileRect, stoneRect))
      continue;
    enum GoColor territoryColor = point.region.territoryColor;
    enum TerritoryLayerType territoryLayerType;
    switch (territoryColor)
    {
      case GoColorBlack:
      {
        territoryLayerType = TerritoryLayerTypeBlack;
        break;
      }
      case GoColorWhite:
      {
        territoryLayerType = TerritoryLayerTypeWhite;
        break;
      }
      case GoColorNone:
      {
        if (! point.region.territoryInconsistencyFound)
          continue;  // territory is truly neutral, no markup needed
        switch (inconsistentTerritoryMarkupType)
        {
          case InconsistentTerritoryMarkupTypeNeutral:
            continue;  // territory is inconsistent, but user does not want markup
          case InconsistentTerritoryMarkupTypeDotSymbol:
            territoryLayerType = TerritoryLayerTypeInconsistentDotSymbol;
            break;
          case InconsistentTerritoryMarkupTypeFillColor:
            territoryLayerType = TerritoryLayerTypeInconsistentFillColor;
            break;
          default:
            DDLogError(@"Unknown value %d for property ScoringModel.inconsistentTerritoryMarkupType", inconsistentTerritoryMarkupType);
            continue;
        }
        break;
      }
      default:
      {
        DDLogError(@"Unknown value %d for property point.region.territoryColor", territoryColor);
        continue;
      }
    }

    NSNumber* territoryLayerTypeAsNumber = [[[NSNumber alloc] initWithInt:territoryLayerType] autorelease];
    [drawingPoints setObject:territoryLayerTypeAsNumber forKey:point.vertex.string];
  }

  return drawingPoints;
}

// -----------------------------------------------------------------------------
/// @brief Returns a dictionary that identifies the points whose intersections
/// are located on this tile, and the stone group state of the region that each
/// point belongs to.
///
/// Dictionary keys are NSString objects that contain the intersection vertex.
/// The vertex string can be used to get the GoPoint object that corresponds to
/// the intersection.
///
/// Dictionary values are NSNumber objects that store a GoStoneGroupState enum
/// value.
// -----------------------------------------------------------------------------
- (NSMutableDictionary*) calculateDrawingPointsStoneGroupState
{
  NSMutableDictionary* drawingPoints = [[[NSMutableDictionary alloc] initWithCapacity:0] autorelease];
  GoGame* game = [GoGame sharedGame];
  if (! game.score.scoringEnabled)
    return drawingPoints;

  CGRect tileRect = [BoardViewDrawingHelper canvasRectForTileView:self.tileView
                                                          metrics:self.playViewMetrics];

  // TODO: Currently we always iterate over all points. This could be
  // optimized: If the tile rect stays the same, we should already know which
  // points intersect with the tile, so we could fall back on a pre-filtered
  // list of points. On a 19x19 board this could save us quite a bit of time:
  // 381 points are iterated on 16 tiles (iPhone), i.e. over 6000 iterations.
  // on iPad where there are more tiles it is even worse.
  NSEnumerator* enumerator = [game.board pointEnumerator];
  GoPoint* point;
  while (point = [enumerator nextObject])
  {
    if (! point.hasStone)
      continue;
    CGRect stoneRect = [BoardViewDrawingHelper canvasRectForStoneAtPoint:point
                                                                 metrics:self.playViewMetrics];
    if (! CGRectIntersectsRect(tileRect, stoneRect))
      continue;
    enum GoStoneGroupState stoneGroupState = point.region.stoneGroupState;
    NSNumber* stoneGroupStateAsNumber = [[[NSNumber alloc] initWithInt:stoneGroupState] autorelease];
    [drawingPoints setObject:stoneGroupStateAsNumber forKey:point.vertex.string];
  }

  return drawingPoints;
}

@end
