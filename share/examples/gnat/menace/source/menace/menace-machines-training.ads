package Menace.Machines.Training is

   procedure Set_Next_Move
     (This    : in out Engine;
      Contest : in     Menace.Contests.Game;
      Move    : in     Move_Locations);
   --  Assigns This.Id to the move location specified by Move within Contest.
   --  Also sets the corresponding matchbox as if that move was selected
   --  normally during play.
   --
   --  This routine is used when training an engine so that the trainer can
   --  specify the initial starting position for player X (if the trainer so
   --  chooses).

end Menace.Machines.Training;
