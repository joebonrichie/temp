with Relation_Maps;  use Relation_Maps;
with Data_Maps;      use Data_Maps;

with Ada.Text_IO;    use Ada.Text_IO;
with Ada.Containers; use Ada.Containers;

procedure Print_Students is

   procedure Print_Student (Name : String) is
      C : constant Data_Maps.Cursor := Find (Dates, Name);
   begin
      Put ("   ");
      Put (Element (C));
      Put (' ');
      Put (Name);
      New_Line;
   end;

   procedure Print_Students (Name : String; Students : Set) is
   begin

      Put ("Advisor """);
      Put (Name);
      Put (""":");
      Put (Count_Type'Image (Length (Students)));
      New_Line;
      Iterate (Students, Print_Student'Access);
      New_Line;

   end Print_Students;

begin

   Iterate (Students, Print_Students'Access);
   New_Line (2);

end Print_Students;
