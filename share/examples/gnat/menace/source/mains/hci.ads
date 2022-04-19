--  This package is used by the main procedure Menace.Play for interactively
--  playing a game with a human being.

with Menace.Machines;
with Menace.Contests;
with Ada.Strings.Unbounded;  use Ada.Strings.Unbounded;
use Menace;

package HCI is  -- human-computer interaction

   procedure Get_Engine_Name
      (Name : out Unbounded_String;
       Quit : out Boolean);
   --  Gets the name of the file containing the engine to be played by the human
   --  opponent.  If the human decides they do not want to give the name the
   --  value of Quit will be True, otherwise it will be false.

   procedure Announce_Result
     (Contest  : in Contests.Game;
      Opponent : in Machines.Engine);
   --  Displays whether the engine or the human ("you") won the game or whether
   --  it ended in a draw.

   function Affirmative (Question : String) return Boolean;
   --  Returns whether the user answered the Question in the affirmative.

   procedure Explain_Play
      (Contest : in Contests.Game;
       Player  : in Machines.Engine);
   --  Show how to make moves and note that Player is X and goes first.

end HCI;