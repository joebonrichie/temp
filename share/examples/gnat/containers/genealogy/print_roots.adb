with Data_Maps;      use Data_Maps;
with Relation_Maps;  use Relation_Maps;
with Ada.Text_IO;    use Ada.Text_IO;

procedure Print_Roots is

   procedure Output_Tree (Name  : in String;
                          Level : in Natural) is
   begin

      for I in 1 .. Level loop
         Put ("   ");
      end loop;

      Put (Name);
      Put (" (");
      Put (Element (Places, Name));
      Put (" ");
      Put (Element (Dates, Name));
      Put_Line (")");

      declare
         procedure Process_Student (Name : String) is
         begin
            Output_Tree (Name, Level => Level + 1);
         end;
      begin
         Iterate (Students, Name, Process_Student'Access);
      end;

   end Output_Tree;

   procedure Process_Roots (Name : in String) is
   begin
      Output_Tree (Name, Level => 0);
   end;

   Roots : Set renames Element (Students, "---");

begin

   Iterate (Roots, Process_Roots'Access);

end Print_Roots;
