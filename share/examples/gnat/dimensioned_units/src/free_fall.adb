------------------------------------
--
--  Copyright (C) 2012-2015, AdaCore
--
------------------------------------

--  This is the main procedure for a utility program that displays the
--  distance travelled by an object on Earth in 10 seconds of free fall.

pragma Ada_2012;

with System.Dim.MKS;    use System.Dim.Mks;
with System.Dim.Mks_IO; use System.Dim.Mks_IO;
with Ada.Text_IO;       use Ada.Text_IO;

procedure Free_Fall is

   subtype Acceleration is Mks_Type
     with Dimension => ("m/sec^2", 1, 0, -2, others => 0);

   G : constant Acceleration := 9.81 * M / (S ** 2);

   T : Time := 10.0 * S;

   Distance : Length;

   Buffer : String (1 .. 20);

begin
   Put ("Gravitational constant: ");
   Put (G, Aft => 2, Exp => 0);
   New_Line;

   Put ("twice that : "); Put (2.0 * G, Aft => 2, Exp => 0);
   Put_Line ("");

   Distance := 0.5 * G * T ** 2;
   Put ("Distance travelled in 10 seconds of free fall: ");
   Put (Distance, Aft => 2, Exp => 0);
   New_Line;

   Put (Buffer, G, 2, 0);
   Put_Line ("using put to string :  " & Buffer);
   put_line ("test function Image");
   Put_Line (Image (G, 2, 0, " gs"));
   Put_Line ("a distance: " & Image (Distance, 3, 1));

end Free_Fall;
