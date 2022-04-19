with Relation_Maps;  use Relation_Maps;

with Ada.Text_IO;     use Ada.Text_IO;
with Ada.Containers;  use Ada.Containers;

procedure Print_Advisors is

   procedure Print_Advisor (Advisor : String) is
   begin
      Put (" """);
      Put (Advisor);
      Put ('"');
   end;

   procedure Print_Student (Student : String; Advisors : Set) is
      N : constant Count_Type := Length (Advisors);
   begin
      if N <= 1 then  --too much output otherwise
         return;
      end if;

      Put ("Student """);
      Put (Student);
      Put (""" has");
      Put (Count_Type'Image (N));
      Put (" advisors:");

      Iterate (Advisors, Print_Advisor'Access);
      New_Line;
   end;

begin

   Iterate (Advisors, Print_Student'Access);
   New_Line (2);

end Print_Advisors;

