with Data_Maps;      use Data_Maps;
with Relation_Maps;  use Relation_Maps;
with Ada.Text_IO;    use Ada.Text_IO;

procedure Find_Roots is

   procedure Handle_No_Advisor (Advisor : in String);

   procedure Process_Advisors
     (Student  : in String;
      Advisors : in Set) is

      C : Set_Cursor := First (Advisors);

   begin

      while Has_Element (C) loop

         declare
            Advisor : constant String := Element (C);
         begin

            if Advisor = "---" then

               --Put ("student=");
               --Put (Student);
               --Put (" advisor=""---""");
               --New_Line (2);

               return;

            end if;

            if Contains (Advisors, Advisor) then

               --Put ("student=");
               --Put (Student);
               --Put (" advisor=");
               --Put (Advisor);
               --Put (" is already member of advisors");
               --New_Line (2);

               return;

            end if;
         end;

         Next (C);

      end loop;

      --Put ("student=");
      --Put (Student);
      --Put (" first_advisor=");

      declare
         First_Advisor : constant String := First_Element (Advisors);
      begin
         Put_Line (First_Advisor);
         Handle_No_Advisor (First_Advisor);
      end;

   end Process_Advisors;

   Roots : Set renames Element (Students, Key => "---");
   --
   --This is the set of all students whose advisor is unknown.
   --We now have to find these students' advisors, and among
   --those advisors find those that don't have a database
   --record of their own.  Those advisors are then added to
   --the set of students with unknown advisors.
   --
   --Note also that the declaration above assumes that the Roots
   --set (the map entry with key = "---") already exists in the
   --map.  If you want to automatically create that set if it
   --doesn't exist, then in the declaration above use the Insert
   --function instead.  (Or you could use the item-less
   --procedure form of Insert, that creates the map entry with
   --an empty set.


   procedure Handle_No_Advisor (Advisor : in String) is

      C : constant Data_Maps.Cursor := Find (Dates, Advisor);

   begin

      if Has_Element (C) then

         --Put ("advisor.date=");
         --Put (Element (C));
         --Put_Line ("; no search required");
         --New_Line;

         pragma Assert (Contains (Roots, Advisor));

         return;

      end if;

      --Put_Line ("no date for advisor; searching database");

      --NOTE:  (This comment might be old. --MJH)
      --It's kind of pointless to search, since we know
      --that without a date then the advisor won't be
      --found.  It would be faster to assign the advisor
      --the date "!", and then append this advisor to the
      --the vector in roots["!"].
      --
      --But I'll leave this here for now, since this is
      --basically what the original example does.
      --END NOTE.

      if Contains (Roots, Advisor) then

         --Put ("found first advisor=");
         --Put (Advisor);
         --Put (" in roots set; date=");
         --Put (Element (Dates, Advisor));
         --New_Line (2);

         return;

      end if;

      --Put ("inserting first_advisor=");
      --Put (Advisor);
      --Put_Line (" in roots set");
      --New_Line;

      Insert (Advisors, Roots, New_Name => Advisor);

   end Handle_No_Advisor;

begin

   Iterate (Advisors, Process_Advisors'Access);

end Find_Roots;
