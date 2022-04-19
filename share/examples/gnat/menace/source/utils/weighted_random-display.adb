with GNAT.IO;  use GNAT.IO;

procedure Weighted_Random.Display (This : in Generator) is
begin
   Put ("Weights: ");
   for K in This.State.Weights'Range loop
      Put (This.State.Weights (K)'Img);
      if K /= This.State.Weights'last then
         Put (",");
      end if;
   end loop;
   New_Line;
   Put_Line ("Total weight: " & This.State.Total_Weight'Img);
end Weighted_Random.Display;