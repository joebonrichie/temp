package Menace.Contests is

   type Game is tagged private;
   --  The abstract data type representing the game itself, consisting of the
   --  moves made by the players and those moves still available.

   type Any_Game is access all Game'Class;

   procedure Mark
     (This   : in out Game;
      Player : in     Player_Id;
      Move   : in     Move_Locations);
   --  Place this Player at move location Move on the game, unless that location
   --  is already taken, in which case Illegal_Move is raised.

   Illegal_Move : exception;

   function Winner (This : Game) return Player_Id;
   --  Returns the winner of this game. Returns the value No_Player if there is
   --  no winner (yet).

   function Completed (This : Game;  Next_Player : Player_Id) return Boolean;
   --  Returns whether the game is completed, meaning there is either a winner
   --  or the game will be a draw if it is Next_Player's turn to play.

   procedure Display (This : in Game; Show_Numbers : in Boolean := False);
   --  Shows the current game "graphically", suitable for interactive play with
   --  a human. Moves taken by Player_X appears as an 'X', those by Player_O
   --  appears as 'O', and those not taken by either player appear as blanks
   --  unless Show_Number is True, in which case those not taken show their
   --  position number:
   --
   --     1 | 2 | 3
   --    ---+---+---
   --     4 | 5 | 6
   --    ---+---+---
   --     7 | 8 | 9

   procedure Reset (This : in out Game);
   --  Puts This back into the initial state in which no moves have been made.

   function Player_At (This : Game;  Move : Move_Locations) return Player_Id;
   --  Returns the Id of the player located at Move within the game.

   function Moves_Remaining (This : Game) return Natural;
   --  Returns the total number of moves not yet taken within the game.

   function Could_Win
     (This        : Game;
      Next_Player : Player_Id;
      Move        : Move_Locations)
      return Boolean;
   --  Returns whether Next_Player could win This game by making a move located
   --  at position Move.

private

   type Representation is array (Move_Locations) of Player_Id;

   type Game is tagged
      record
         Board : Representation := (others => No_Player);
      end record;

end Menace.Contests;
