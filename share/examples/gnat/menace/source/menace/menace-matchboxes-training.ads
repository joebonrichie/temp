--  This package is used to train an engine.

package Menace.Matchboxes.Training is

   procedure Set_Next_Move (This : in out Matchbox;  Move : in Move_Locations);
   --  Makes This matchbox act as if it selected Move randomly.  Specifically,
   --  it sets the selected bead to the bead color corresponding to Move and
   --  sets the Opened_During_Play flag to True.
   --
   --  This routine is used when training an engine so that the trainer can
   --  specify the initial starting position for player X (if the trainer so
   --  chooses).

end Menace.Matchboxes.Training;
