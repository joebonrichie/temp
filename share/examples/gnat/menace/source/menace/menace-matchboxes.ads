with Ada.Streams;
with Weighted_Random;
with Menace.Boards;

package Menace.Matchboxes is

   type Matchbox is tagged limited private;

   --  This is the fundamental mechanism in Michie's physical machine. He
   --  arranged individual matchboxes to represent the game states that the
   --  machine (player X) could encounter and used these matchboxes to decide
   --  the next move the machine would make, based on the learning experience
   --  from previous games (if any). Each matchbox corresponded to a single game
   --  state, that is, a single unique set of previous plays by X and O.
   --
   --  Each matchbox contained beads of nine different colors, one color for
   --  each of the nine possible move locations of a game. The number of beads
   --  of any given color depended on the reinforcement of previous games (and,
   --  initially, the move number for player X within a given game). Michie
   --  would find the matchbox corresponding to the current game state and
   --  randomly select one of the beads, with the color of the selected bead
   --  indicating the move to make on the board for the machine (player X).
   --  However, since the number of beads in a given matchbox depended on
   --  reinforcement from prior games, some colors of bead had a greater or
   --  lesser chance of being selected. That is how the machine learned to play
   --  a better game as multiple games were played.

   procedure Create
     (This   : in out Matchbox;
      Layout : in     Menace.Boards.State_Number);
   --  Creates a new matchbox with play state corresponding to the value of
   --  Layout. The beads of nine different colors are set to their initial
   --  counts.

   procedure Get_Next_Move (This : in out Matchbox;  Move : out Move_Locations);
   --  Randomly select one of the beads in the box and set Move to the number
   --  corresponding to the color of the selected bead.

   function Play_State (This : Matchbox) return Menace.Boards.State;
   --  Returns the state of the game that this matchbox represents.

   function Opened (This : Matchbox) return Boolean;
   --  Returns whether this matchbox was opened during the game. For each
   --  matchbox opened during a given game, Michie added or removed beads to
   --  reinforce the selected move.

   procedure Close (This : in out Matchbox);
   --  Closes the matchbox in preparation for the next game.

   procedure Reinforce_Win (This : in out Matchbox);
   --  Adds beads to give additional weight to the selected move. The chosen
   --  move is determined by the color of bead randomly selected, so this
   --  routine adds beads of that color.

   procedure Reinforce_Loss (This : in out Matchbox);
   --  Removes beads to give less weight to the selected move.

   procedure Reinforce_Draw (This : in out Matchbox);
   --  Adds a minimal number of beads to give additional weight to the selected
   --  move. A game ending in a draw is much better than a loss, particularly
   --  because draws are the expected outcome between accomplished players.

   procedure Read
      (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
       This   : out Matchbox);
   --  Reads the value of a matchbox from a stream (file). Matchboxes are only
   --  created (via procedure Create, above), when they cannot be read from an
   --  existing file representing an existing machine.

   procedure Write
      (Stream : not null access Ada.Streams.Root_Stream_Type'Class;
       This   : in Matchbox);
   --  Write the value of the matchbox to a stream file. Machines, which are
   --  largely just collections of matchboxes, are saved to a file so that
   --  learning is permanent.

   for Matchbox'Read  use Read;
   for Matchbox'Write use Write;

private

   type Bead_Colors is
      (Red, Orange, Yellow, Green, Blue, Indigo, Violet, White, Black);

      --       Red   |  Orange |  Yellow
      --    ---------+---------+---------
      --      Green  |   Blue  |  Indigo
      --    ---------+---------+---------
      --      Violet |  White  |  Black

   package Random_Colors is new Weighted_Random (Value => Bead_Colors);
   --  Michie built a little cardboard slot into each matchbox, such that when
   --  the box was shaken a single randomly selected bead would come out. We use
   --  a generic package that provides a non-uniformly-distributed random value,
   --  in this instance a value of type Color, based on weights controlled by
   --  the reinforcement routines.

   type Matchbox is tagged limited
      record
         State_Num      : Menace.Boards.State_Number;
         Opened_In_Play : Boolean;
         Selected_Bead  : Bead_Colors;
         Bead_Selector  : Random_Colors.Generator;
      end record;

   function Initial_Weights (Layout : Menace.Boards.State_Number)
      return Random_Colors.Relative_Weights;
   --  Assign initial weights for available moves based on the layout and the
   --  move count for X, using the weighting specified by Beads_Per_Move.

   function First_Available (Layout : Menace.Boards.State_Number)
      return Random_Colors.Relative_Weights;
   --  This function is used when the computer has had too negative a learning
   --  experience and thus has no non-zero weights available for the given
   --  state. Therefore we arbitrarily set one of the available moves to a
   --  non-zero weight (of 1) so that a move can be selected. The first open
   --  move location found, starting at Move_Locations'First, is the one given
   --  the non-zero weight.

   Beads_Per_Move : constant array (0 .. 4) of Natural := (4, 3, 2, 1, 1);
   --  Any given matchbox represents a single state within a game, consisting of
   --  the set of prior plays made by player X and player O, including the
   --  initial case when no moves have yet been made. Therefore, one matchbox
   --  corresponds to the state initially encountered by the machine (player X),
   --  with all moves available. Other matchboxes correspond to the states
   --  encountered on the second move by X, after both X and O made one prior
   --  move, with those two prior moves no longer available. and so forth, for
   --  all possible states encountered by X when making its next move. It
   --  follows that different matchboxes initially start with different numbers
   --  of beads. Specifically, the number of beads initially loaded into a
   --  matchbox, before the first game was played by that machine, varies
   --  according to the number of moves already taken and to the number for the
   --  player X move about to be made (the first move by X, second move by X,
   --  etc.).
   --
   --  Michie loaded the single matchbox corresponding to the initial blank
   --  state with four beads of each of the open colors, so since all nine
   --  positions were available, 36 total beads were loaded into that one
   --  matchbox. For the second move by X, the corresponding matchboxes were
   --  given 3 beads of each color not already taken. On this second X move, two
   --  prior moves have been made so only 7 moves are possible, so seven colors
   --  are available, and thus 21 beads were loaded into each of those
   --  matchboxes. Two beads of each possible color were loaded into the
   --  matchboxes for the third move, and so on for the subsequent player X
   --  moves.
   --
   --  This array holds the initial numbers of beads per color to be loaded into
   --  the matchboxes, according to the above description, based on the move
   --  number for player X. The move number is the index into the array so we
   --  use a zero-based index because of the initial game case in which X has
   --  made zero moves so far.

   procedure Adjust_Selected_Bead_Weight
      (This : in out Matchbox;  Adjustment : in Integer);
   --  After the game completes, the weight for the color of the selected bead
   --  is adjusted by adding positive or negative reinforcement values. This
   --  procedure adds the Adjustment value to the weight of the bead selected
   --  during play.

   --  These are the weight adjustment values used by Michie for reinforcing
   --  bead selection.
   Win_Reinforcement  : constant := +3;
   Draw_Reinforcement : constant := +1;
   Loss_Reinforcement : constant := -1;

end Menace.Matchboxes;
