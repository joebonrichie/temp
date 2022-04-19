package body Menace.Matchboxes.Training is

   -------------------
   -- Set_Next_Move --
   -------------------

   procedure Set_Next_Move (This : in out Matchbox; Move : in Move_Locations) is
   begin
      This.Selected_Bead := Bead_Colors'Val (Move - 1);
      This.Opened_In_Play := True;
   end Set_Next_Move;

end Menace.Matchboxes.Training;
