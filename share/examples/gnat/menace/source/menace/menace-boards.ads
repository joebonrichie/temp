with Menace.Contests;  use Menace.Contests;
with Ada.Containers.Vectors;

package Menace.Boards is
   pragma Elaborate_Body;

   type State is tagged private;
   --  A given State value represents the state of a game at the instant that
   --  player X is ready to choose the next move. Thus it consists of the set of
   --  prior moves made by player X and player O, including the initial case
   --  when no moves have yet been made.

   function Current_State (G : Game)  return State;
   --  Returns the state representing the moves already made, as well as those
   --  available, in the current game.

   type State_Number is range 1 .. 2423;
   --  This is the number of states that player X can encounter in a game,
   --  except for duplicates and games already won. Michie actually used
   --  approximately 300 matchboxes, with one state per matchbox, by eliminating
   --  all duplicates and, especially, by eliminating those states that are
   --  reflections and rotations of other states. The work necessary to do so
   --  would be justified because he was working with actual, physical
   --  matchboxes, so locating the matchbox corresponding to the state of a game
   --  would be significantly easier with fewer total matchboxes to search. In
   --  our case, using a computer to represent the machine, we need not spend
   --  the time to reduce the number of matchboxes because we can search this
   --  relatively small number of short strings quickly and easily. If we did
   --  reduce the total number we would have to take the transformations into
   --  account when making each move, so it seems of little value to do so.
   --
   --  We can reference any given state by one of these numbers, which is
   --  particularly useful when creating matchboxes from scratch.

   function State_For (Id : State_Number) return State;
   --  Returns the state corresponding to Id.

   function "=" (Left, Right : State) return Boolean;
   --  Individual objects of type Matchbox hold individual State values. In
   --  particular, any given matchbox holds one, and only one, State value. The
   --  matchbox holding a given state can be located by comparing the state of
   --  the matchbox to the state of the game, as returned by Current_State
   --  above, using the equality operator defined here.

   function Moves_Made (This : State;  By : Player_Id) return Natural;
   --  Returns the number of moves already made by the specified player in the
   --  given state.

   function Player_At (This : State; Move : Move_Locations) return Player_Id;
   --  Returns the id of the player that already made a move at the specified
   --  move location, including the case in which no player has yet made a move
   --  there.

   subtype State_Image is String (Move_Locations'Range);
   --  A string representing the state of play, consisting of the image values
   --  defined in package Menace for the players. For each move location as an
   --  index value, the corresponding player image character of either 'X' or
   --  'O' will be present if that player has made a move there. If no player
   --  has made a move at a given location, the character image of No_Player
   --  will be present (ie a single dash).

   function Image (This : State) return State_Image;
   --  Returns a string representing the state of play.  This is not the
   --  string used to display the game to the human player during play, but is
   --  instead a useful utility function for error messages.

private

   type State is tagged
      record
         Representation : State_Image;
      end record;

   package Board_States is new Ada.Containers.Vectors
     (Index_Type   => State_Number,
      Element_Type => State_Image);

   Player_X_States : Board_States.Vector;
   --  This is the singleton object holding all the states that player X can
   --  encounter when playing. There are exactly State_Number'Last values held,
   --  as described above. This logically an array, indexed by State_Number,
   --  and indeed could be represented by a physical array.
   --
   --  The contents are loaded from a precomputed file, if that file exists,
   --  otherwise the contents are computed and the file recreated.

   procedure Conditionally_Insert
      (New_Board : in Game; Into : in out Board_States.Vector);
   --  Inserts the image of the new board into the states vector if there is
   --  not already an identical image present.

   procedure Generate
     (States   : in out Board_States.Vector;
      Contest  : in     Game;
      Previous : in     Player_Id);
   --  Recursively compute the initial states that player X can encounter
   --  so that we can assign them to individual matchboxes.

   procedure Load_Precomputed_States;
   --  Loads the states file if it exists, otherwise calls Generate_States
   --  to compute them, loads the vector, and saves the file.

   Precomputed_States_Name : constant String := "precomputed_states.txt";
   --  The name of the file containing the board layout states
   --  so that we don't have to compute them each time the program
   --  executes.  The file is generated if it doesn't exist.  The states
   --  are then loaded into the vector.

end Menace.Boards;
