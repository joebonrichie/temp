with Menace.Matchboxes.Training;

package body Menace.Machines.Training is

   -------------------
   -- Set_Next_Move --
   -------------------

   procedure Set_Next_Move
     (This    : in out Engine;
      Contest : in     Menace.Contests.Game;
      Move    : in     Move_Locations)
   is
      use Menace.Boards;

      Index : State_Number;
      Found : Boolean := False;

      Current_Game : constant State := Current_State (Contest);
   begin
      --  find matchbox matching current game state
      for K in This.Boxes'Range loop
         if This.Boxes (K).Play_State = Current_Game then
            Index := K;
            Found := True;
            exit;
         end if;
      end loop;
      if not Found then
         raise Program_Error with "Could not find matchbox with state '" &
            Current_Game.Image & "'";
      end if;

      Menace.Matchboxes.Training.Set_Next_Move (This.Boxes (Index), Move);
   end Set_Next_Move;

end Menace.Machines.Training;
