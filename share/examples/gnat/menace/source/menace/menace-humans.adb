with Ada.Text_IO; use Ada.Text_IO;

package body Menace.Humans is

   -------------------
   -- Get_Next_Move --
   -------------------

   procedure Get_Next_Move
     (This    : in out Player;
      Contest : in     Menace.Contests.Game;
      Move    :    out Move_Locations)
   is
      Response : String(1..2) := "  ";
         --  we use a string here because that's required for 'Value
   begin
      Getting_Move : loop
         Getting_Response : loop
            Put ("Player " & As_Player_Image (This.Id) & ", what is your move? ");
            Get_Immediate (Response (1));
            Put (Response (1));
            New_Line;  -- since user does not hit Enter key

            exit Getting_Response when Response (1) in '1' .. '9';

            Put_Line ("Enter a single digit, 1 through 9.");
            New_Line;
         end loop Getting_Response;

         Move := Move_Locations'Value (Response);

         exit Getting_Move when Contest.Player_At (Move) = No_Player;

         New_Line;
         Put_Line ("That move is already taken by player " &
                   As_Player_Image (Contest.Player_At (Move)));
         New_Line;
      end loop Getting_Move;
   end Get_Next_Move;

end Menace.Humans;
