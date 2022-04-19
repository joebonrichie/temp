--  Prints the relevant information for a single matchbox: the state number, the
--  corresponding state image (as a sequence of X, O, and '-' characters), and
--  the information for the weighted random color generator.

with GNAT.IO;  use GNAT.IO;
with Weighted_Random.Display;
with Menace.Boards;

procedure Menace.Matchboxes.Display (This : in Matchbox) is

   procedure Display_Generator is new Random_Colors.Display;

   use Menace.Boards;
begin
  Put_Line ("State number:" & This.State_Num'Img);
  Put_Line ("State Image: " & Menace.Boards.Image (State_For (This.State_Num)));
  Display_Generator (This.Bead_Selector);
  New_Line;
end Menace.Matchboxes.Display;

