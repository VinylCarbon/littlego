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


/// @file

// -----------------------------------------------------------------------------
/// @name GUI constants
// -----------------------------------------------------------------------------
//@{
/// @brief The value of this constant should be added to all drawing operations'
/// parameters to prevent anti-aliasing. See README.developer for details.
extern const float gHalfPixel;
/// @brief On the smallest board size, how far from the fingertip should the
/// cross-hair point be displayed when placing stones on the Play view. The unit
/// used by this constant is "distances between two adjacent intersections".
extern const int crossHairPointDistanceFromFingerOnSmallestBoard;
//@}

// -----------------------------------------------------------------------------
/// @name Logging constants
///
/// @brief These constants need to be declared static instead of extern, so that
/// they can be initialized with values. This is required so that the compiler
/// can see the values when it encounters DDLog statements, which will enable it
/// to optimize away unneeded DDLog statements which are above the log level
/// threshold.
// -----------------------------------------------------------------------------
//@{
#ifdef LITTLEGO_NDEBUG
static const int ddLogLevel = LOG_LEVEL_OFF;
#else
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#endif
//@}

/// @brief Enumerates possible types of GoMove objects.
enum GoMoveType
{
  GoMoveTypePlay,   ///< @brief The player played a stone in this move.
  GoMoveTypePass    ///< @brief The player passed in this move.
};

/// @brief Enumerates colors in Go. The values from this enumeration can be
/// attributed to various things: stones, players, points, moves, etc.
enum GoColor
{
  GoColorNone,   ///< @brief Used, among other things, to say that a GoPoint is empty and has no stone placed on it.
  GoColorBlack,
  GoColorWhite
};

/// @brief Enumerates the possible types of GoGame objects.
enum GoGameType
{
  GoGameTypeUnknown,             ///< @brief Unknown game type.
  GoGameTypeComputerVsHuman,     ///< @brief A computer and a human player play against each other.
  GoGameTypeComputerVsComputer,  ///< @brief Two computer players play against each other.
  GoGameTypeHumanVsHuman         ///< @brief Two human players play against each other.
};

/// @brief Enumerates the possible states of a GoGame.
enum GoGameState
{
  GoGameStateGameHasNotYetStarted,  ///< @brief Denotes a new game that is ready to begin.
  GoGameStateGameHasStarted,        ///< @brief Denotes a game that has started and has at least 1 GoMove.
  GoGameStateGameIsPaused,          ///< @brief Denotes a computer vs. computer game that is paused.
  GoGameStateGameHasEnded           ///< @brief Denotes a game that has ended, no moves can be played anymore.
};

/// @brief Enumerates the possible reasons why a GoGame has reached the state
/// #GoGameStateGameHasEnded.
enum GoGameHasEndedReason
{
  GoGameHasEndedReasonNotYetEnded,   ///< @brief The game has not yet ended.
  GoGameHasEndedReasonTwoPasses,     ///< @brief The game ended due to two consecutive pass moves.
  GoGameHasEndedReasonResigned,      ///< @brief The game ended due to one of the players resigning.
  GoGameHasEndedReasonNoStonesLeft,  ///< @brief The game ended due to both players running out of stones.
  GoGameHasEndedReasonTimeExceeded   ///< @brief The game ended due to one of the players having no time left.
};

/// @brief Enumerates the possible results of a game that has reached the state
/// #GoGameStateGameHasEnded.
enum GoGameResult
{
  GoGameResultNone,         ///< @brief The game has not been decided yet, usually because the game has not yet ended.
  GoGameResultBlackHasWon,  ///< @brief Black has won the game.
  GoGameResultWhiteHasWon,  ///< @brief White has won the game.
  GoGameResultTie           ///< @brief The game is a tie.
};

/// @brief Enumerates the possible directions one can take to get from one
/// GoPoint to another neighbouring GoPoint.
enum GoBoardDirection
{
  GoBoardDirectionLeft,     ///< @brief Used for navigating to the left neighbour of a GoPoint.
  GoBoardDirectionRight,    ///< @brief Used for navigating to the right neighbour of a GoPoint.
  GoBoardDirectionUp,       ///< @brief Used for navigating to the neighbour that is above a GoPoint.
  GoBoardDirectionDown,     ///< @brief Used for navigating to the neighbour that is below a GoPoint.
  GoBoardDirectionNext,     ///< @brief Used for iterating all GoPoints. The first point is always A1, on a 19x19 board the last point is Q19.
  GoBoardDirectionPrevious  ///< @brief Same as #GoBoardDirectionNext, but for iterating backwards.
};

/// @brief How should Play view mark up inconcistent territory during scoring?
enum InconsistentTerritoryMarkupType
{
  InconsistentTerritoryMarkupTypeDotSymbol,  ///< @brief Mark up territory using a dot symbol
  InconsistentTerritoryMarkupTypeFillColor,  ///< @brief Mark up territory by filling it with a color
  InconsistentTerritoryMarkupTypeNeutral     ///< @brief Don't mark up territory
};

/// @brief Enumerates all existing tabs in the GUI.
///
/// Values in this enumeration must match the "tag" property values of each
/// TabBarItem in MainWindow.xib.
enum TabType
{
  TabTypePlay,
  TabTypeSettings,
  TabTypeArchive,
  TabTypeDebug,
  TabTypeManual,
  TabTypeAbout,
  TabTypeSourceCode,
  TabTypeLicenses,
  TabTypeCredits
};

/// @brief Enumerates the supported board sizes.
enum GoBoardSize
{
  GoBoardSize7 = 7,
  GoBoardSize9 = 9,
  GoBoardSize11 = 11,
  GoBoardSize13 = 13,
  GoBoardSize15 = 15,
  GoBoardSize17 = 17,
  GoBoardSize19 = 19,
  GoBoardSizeMin = GoBoardSize7,
  GoBoardSizeMax = GoBoardSize19,
  GoBoardSizeUndefined = 0
};
/// @brief Default board size that should be used if no sensible user default
/// is available.
extern const enum GoBoardSize gDefaultBoardSize;
extern const int gNumberOfBoardSizes;

/// @brief Enumerates the types of alert views used across the application.
///
/// Enumeration values are used as UIView tags so that an alert view delegate
/// that manages several alert views knows how to distinguish between them.
enum AlertViewType
{
  AlertViewTypeGameHasEnded,
  AlertViewTypeNewGame,
  AlertViewTypeSaveGame,
  AlertViewTypeRenameGame,
  AlertViewTypeLoadGameFailed,
  AlertViewTypeUndoMoveFailed,
  AlertViewTypeAddToCannedCommands,
  AlertViewTypeMemoryWarning
};

/// @brief Enumerates the types of buttons used by the various alert views in
/// #AlertViewType.
enum AlertViewButtonType
{
  AlertViewButtonTypeOk = 0,  ///< @brief Used as the single button in a simple alert view
  AlertViewButtonTypeNo = 0,  ///< @brief Used as the "cancel" button in a Yes/No alert view
  AlertViewButtonTypeYes = 1  ///< @brief Used as the first "other" button in a Yes/No alert view
};

/// @brief Enumerates the supported sort criteria on the Archive view.
enum ArchiveSortCriteria
{
  ArchiveSortCriteriaFileName,
  ArchiveSortCriteriaFileDate
};

// -----------------------------------------------------------------------------
/// @name Filesystem related constants
// -----------------------------------------------------------------------------
//@{
/// @brief Simple file name that violates none of the GTP protocol restrictions
/// for file names. Is used for the "loadsgf" and "savesgf" GTP commands.
extern NSString* sgfTemporaryFileName;
/// @brief Name of the .sgf file used for backup/restore when the app goes
// to/returns from the background. The file is stored in the Library folder.
extern NSString* sgfBackupFileName;
//@}

// -----------------------------------------------------------------------------
/// @name Application notifications
// -----------------------------------------------------------------------------
//@{
/// @brief Is sent after the application delegate has finished setting up the
/// application (includes creating all objects that are important for the
/// application's lifecycle). The application is now "ready for action".
///
/// This notification is sent exactly once.
extern NSString* applicationIsReadyForAction;
//@}

// -----------------------------------------------------------------------------
/// @name GTP notifications
// -----------------------------------------------------------------------------
//@{
/// @brief Is sent just before a command is submitted to the GTP engine. The
/// GtpCommand instance that is submitted is associated with the notification.
///
/// @attention This notification is delivered in a secondary thread.
extern NSString* gtpCommandWillBeSubmittedNotification;
/// @brief Is sent after a response is received from the GTP engine. The
/// GtpResponse instance that was received is associated with the notification.
///
/// @attention This notification is delivered in a secondary thread.
extern NSString* gtpResponseWasReceivedNotification;
/// @brief Is sent to indicate that the GTP engine is no longer idle.
extern NSString* gtpEngineRunningNotification;
/// @brief Is sent to indicate that the GTP engine is idle.
extern NSString* gtpEngineIdleNotification;
//@}

// -----------------------------------------------------------------------------
/// @name GoGame notifications
// -----------------------------------------------------------------------------
//@{
/// @brief Is sent to indicate that a new GoGame object is about to be created
/// and and old GoGame object (if one exists) is about to be deallocated.
///
/// This notification is sent while the old GoGame object and its dependent
/// objects (e.g. GoBoard) are still around and fully functional.
extern NSString* goGameWillCreate;
/// @brief Is sent to indicate that a new GoGame object has been created. This
/// notification is sent after the GoGame object and its dependent objects (e.g.
/// GoBoard) have been fully configured.
///
/// The GoGame object is associated with the notification.
extern NSString* goGameDidCreate;
/// @brief Is sent to indicate that the GoGame state has changed in some way,
/// i.e. the game has started or ended.
///
/// The GoGame object is associated with the notification.
extern NSString* goGameStateChanged;
/// @brief Is sent to indicate that the first move of the game has changed. May
/// occur when the first move of the game is played, or when the first move is
/// removed by an undo.
///
/// The GoGame object is associated with the notification.
extern NSString* goGameFirstMoveChanged;
/// @brief Is sent to indicate that the last move of the game has changed. May
/// occur whenever a move is played, or when the most recent move of the game
/// is removed by an undo.
///
/// The GoGame object is associated with the notification.
extern NSString* goGameLastMoveChanged;
//@}

// -----------------------------------------------------------------------------
/// @name Computer player notifications
// -----------------------------------------------------------------------------
//@{
/// @brief Is sent to indicate that the computer player has started to think
/// about its next move.
///
/// The GoGame object is associated with the notification.
extern NSString* computerPlayerThinkingStarts;
/// @brief Is sent to indicate that the computer player has stopped to think
/// about its next move. Occurs only after the move has actually been made, i.e.
/// any GoGame notifications have already been delivered.
///
/// The GoGame object is associated with the notification.
extern NSString* computerPlayerThinkingStops;
//@}

// -----------------------------------------------------------------------------
/// @name Archive related notifications
// -----------------------------------------------------------------------------
//@{
/// @brief Is sent to indicate that the current game has been saved and a
/// corresponding .sgf file has been placed in the archive. An NSString instance
/// with the game name (not the file name) is associated with the notification.
extern NSString* gameSavedToArchive;
/// @brief Is sent to indicate that a game has been loaded from an .sgf file in
/// the archive. An NSString instance with the game name (not the file name) is
/// associated with the notification.
extern NSString* gameLoadedFromArchive;
/// @brief Is sent to indicate that something about the content of the archive
/// has changed (e.g. a game has been added, removed, renamed etc.).
extern NSString* archiveContentChanged;
//@}

// -----------------------------------------------------------------------------
/// @name GTP log related notifications
// -----------------------------------------------------------------------------
//@{
/// @brief Is sent to indicate that the something about the content of the
/// GTP log has changed (e.g. a new GtpLogItem has been added, the log has
/// been cleared, the log has rotated).
extern NSString* gtpLogContentChanged;
/// @brief Is sent to indicate that the information stored in a GtpLogItem
/// object has changed.
///
//// The GtpLogItem object is associated with the notification.
extern NSString* gtpLogItemChanged;
//@}

// -----------------------------------------------------------------------------
/// @name Scoring related notifications
// -----------------------------------------------------------------------------
//@{
/// @brief Is sent to indicate that scoring mode has been enabled. Is sent
/// before the first score is calculated.
extern NSString* goScoreScoringModeEnabled;
/// @brief Is sent to indicate that scoring mode has been disabled.
extern NSString* goScoreScoringModeDisabled;
/// @brief Is sent to indicate that the calculation of a new score is about to
/// start.
///
/// The GoScore object is associated with the notification.
extern NSString* goScoreCalculationStarts;
/// @brief Is sent to indicate that a new score has been calculated and is
/// available display.
///
/// The GoScore object is associated with the notification.
extern NSString* goScoreCalculationEnds;
//@}

// -----------------------------------------------------------------------------
/// @name GTP engine profile default values
///
/// @brief See GtpEngineProfile for attribute documentation.
// -----------------------------------------------------------------------------
//@{
extern const int fuegoMaxMemoryMinimum;
extern const int fuegoMaxMemoryMaximum;
extern const int fuegoMaxMemoryDefault;
extern const int fuegoThreadCountMinimum;
extern const int fuegoThreadCountMaximum;
extern const int fuegoThreadCountDefault;
extern const bool fuegoPonderingDefault;
extern const bool fuegoReuseSubtreeDefault;
/// @brief The hardcoded UUID of the default GTP engine profile. This profile
/// is the fallback profile if no other profile is available or appropriate.
/// The user cannot delete this profile.
extern NSString* defaultGtpEngineProfileUUID;
//@}

// -----------------------------------------------------------------------------
/// @name Debug view settings default values
// -----------------------------------------------------------------------------
//@{
extern const int gtpLogSizeMinimum;
extern const int gtpLogSizeMaximum;
//@}

// -----------------------------------------------------------------------------
/// @name Resource file names
// -----------------------------------------------------------------------------
//@{
extern NSString* openingBookResource;
extern NSString* aboutDocumentResource;
extern NSString* sourceCodeDocumentResource;
extern NSString* apacheLicenseDocumentResource;
extern NSString* GPLDocumentResource;
extern NSString* LGPLDocumentResource;
extern NSString* boostLicenseDocumentResource;
extern NSString* readmeDocumentResource;
extern NSString* manualDocumentResource;
extern NSString* creditsDocumentResource;
extern NSString* registrationDomainDefaultsResource;
extern NSString* playStoneSoundFileResource;
//@}

// -----------------------------------------------------------------------------
/// @name Constants (mostly keys) for user defaults
// -----------------------------------------------------------------------------
//@{
// User Defaults versioning
extern const int userDefaultsVersionRegistrationDomain;
extern NSString* userDefaultsVersionRegistrationDomainKey;
extern NSString* userDefaultsVersionApplicationDomainKey;
// Play view settings
extern NSString* playViewKey;
extern NSString* markLastMoveKey;
extern NSString* displayCoordinatesKey;
extern NSString* displayMoveNumbersKey;
extern NSString* playSoundKey;
extern NSString* vibrateKey;
extern NSString* backgroundColorKey;
extern NSString* boardColorKey;
extern NSString* boardOuterMarginPercentageKey;
extern NSString* lineColorKey;
extern NSString* boundingLineWidthKey;
extern NSString* normalLineWidthKey;
extern NSString* starPointColorKey;
extern NSString* starPointRadiusKey;
extern NSString* stoneRadiusPercentageKey;
extern NSString* crossHairColorKey;
extern NSString* placeStoneUnderFingerKey;
// New game settings
extern NSString* newGameKey;
extern NSString* boardSizeKey;
extern NSString* blackPlayerKey;
extern NSString* whitePlayerKey;
extern NSString* handicapKey;
extern NSString* komiKey;
// Players
extern NSString* playerListKey;
extern NSString* playerUUIDKey;
extern NSString* playerNameKey;
extern NSString* isHumanKey;
extern NSString* gtpEngineProfileReferenceKey;
extern NSString* statisticsKey;
extern NSString* gamesPlayedKey;
extern NSString* gamesWonKey;
extern NSString* gamesLostKey;
extern NSString* gamesTiedKey;
extern NSString* starPointsKey;
// GTP engine profiles
extern NSString* gtpEngineProfileListKey;
extern NSString* gtpEngineProfileUUIDKey;
extern NSString* gtpEngineProfileNameKey;
extern NSString* gtpEngineProfileDescriptionKey;
extern NSString* fuegoMaxMemoryKey;
extern NSString* fuegoThreadCountKey;
extern NSString* fuegoPonderingKey;
extern NSString* fuegoReuseSubtreeKey;
// Archive view settings
extern NSString* archiveViewKey;
extern NSString* sortCriteriaKey;
extern NSString* sortAscendingKey;
// GTP Log view settings
extern NSString* gtpLogViewKey;
extern NSString* gtpLogSizeKey;
extern NSString* gtpLogViewFrontSideIsVisibleKey;
// GTP canned commands settings
extern NSString* gtpCannedCommandsKey;
// Scoring settings
extern NSString* scoringKey;
extern NSString* askGtpEngineForDeadStonesKey;
extern NSString* markDeadStonesIntelligentlyKey;
extern NSString* alphaTerritoryColorBlackKey;
extern NSString* alphaTerritoryColorWhiteKey;
extern NSString* alphaTerritoryColorInconsistencyFoundKey;
extern NSString* deadStoneSymbolColorKey;
extern NSString* deadStoneSymbolPercentageKey;
extern NSString* inconsistentTerritoryMarkupTypeKey;
extern NSString* inconsistentTerritoryDotSymbolColorKey;
extern NSString* inconsistentTerritoryDotSymbolPercentageKey;
extern NSString* inconsistentTerritoryFillColorKey;
extern NSString* inconsistentTerritoryFillColorAlphaKey;
//@}