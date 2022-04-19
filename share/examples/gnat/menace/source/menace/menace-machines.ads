with Menace.Contestants;
with Menace.Contests;
with Menace.Matchboxes;
with Menace.Boards;
with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;

package Menace.Machines is

   type Engine is new Menace.Contestants.Player with private;
   --  This is the type representing the learning "engine" of the "Matchbox
   --  Educable Naughts and Crosses Engine" by Donald Michie. An engine is
   --  player X in any game, and consists of a set of matchboxes, one matchbox
   --  per game state that player X can encounter. On each move by X, the engine
   --  finds the matchbox corresponding to the current state of the game and
   --  randomly selects a colored bead from the box. The color of the bead
   --  corresponds to the positions on the game board (1 though 9 positions,
   --  hence 9 colors) and thus indicates the move to be made. When a game ends
   --  the engine analyzes the results and "rewards" or "punishes" the moves
   --  made by respectively adding or subtracting beads of the color selected in
   --  each matchbox opened during that game. In this sense the engine is
   --  "educable". In addition, when a game ends the analyzed matchboxes are
   --  saved to a file so that the engine will retain the feedback from prior
   --  games.

   overriding
   procedure Initialize
     (This : in out Engine;
      Id   : in     Player_Id;
      Name : in     Unbounded_String := Null_Unbounded_String);
   --  Sets the engine name and Id (engines are always set to be Player_X).
   --  Loads the engine indicated by Name from a file of the same name, if such
   --  a file can be found. If no file by that name exists, a new engine is
   --  created with new matchboxes (and no file is created).

   overriding
   procedure Get_Next_Move
     (This    : in out Engine;
      Contest : in     Menace.Contests.Game;
      Move    :    out Move_Locations);
   --  Gets the next move by randomly selecting a colored bead from the matchbox
   --  corresponding to the current state of the game.

   overriding
   procedure Save (This : in Engine);
   --  Saves the engine to the file indicated by the Name given during
   --  initialization.

   overriding
   procedure Analyze (This : in out Engine;  Contest : in Menace.Contests.Game);
   --  If the engine won the game, adds beads of the colors selected from the
   --  opened matchboxes; for a draw, adds fewer beads; for a loss, a bead of
   --  that color is removed.

private

   type Game_Matchboxes is
      array (Menace.Boards.State_Number) of Menace.Matchboxes.Matchbox;
   --  A matchbox for every state that X can encounter, except for some that
   --  can be ignored (such as games already won).

   type Engine is new Menace.Contestants.Player with
      record
         Boxes : Game_Matchboxes;
      end record;

end Menace.Machines;
