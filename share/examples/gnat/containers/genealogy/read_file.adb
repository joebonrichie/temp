with Ada.Command_Line;  use Ada.Command_Line;
with Ada.Text_IO;       use Ada.Text_IO;
with Ada.Containers;    use Ada.Containers;
with Ada.Strings.Equal_Case_Insensitive;  use Ada.Strings;

with Parser;

with Data_Maps;      use Data_Maps;
with Relation_Maps;  use Relation_Maps;

procedure Read_File (Name : in String) is

   C : Data_Maps.Cursor;
   B : Boolean;

begin

   Parser.Initialize (Name);

   while Parser.Get_Record loop

      declare

         Student : constant String := Parser.Student;
         Advisor : constant String := Parser.Advisor;

      begin

         --if Advisor = "---" then
            --Put (Student); Put (':');
            --Put (Advisor); Put (':');
            --Put (Parser.Place); Put (':');
            --Put (Parser.Date); Put (':');
            --New_Line;
         --end if;

         --Replace (Places, Student, Parser.Place);
         --see note below

         Insert (Places, Student, Parser.Place, C, B);

         if not B and then not Equivalent_Elements (C, Parser.Place) then

            New_Line (2);
            Put_Line ("duplicate student; place mismatch");
            Put ("student=");
            Put (Student);
            Put (" places.element=");
            Put (Element (C));
            Put (" place=");
            Put (Parser.Place);
            New_Line (2);

            --Replace_Element (C, By => Parser.Place);
            --see note below

         end if;

         --Replace (Dates, Student, Parser.Date);
         --see note below

         Insert (Dates, Student, Parser.Date, C, B);

         if not B and then not Equivalent_Elements (C, Parser.Date) then

            New_Line (2);
            Put_Line ("duplicate student; date mismatch");
            Put ("student=");
            Put (Student);
            Put (" dates.element=");
            Put (Element (C));
            Put (" date=");
            Put (Parser.Date);
            Put (" advisor=");
            Put (Advisor);
            New_Line (2);

            --Replace_Element (C, By => Parser.Date);
            --NOTE:
            --This changes the key value of a student,
            --because students are ordered by date in the
            --Date_Ordered_Set.  Allowing the student's date
            --to be changed makes it hard to reason whether
            --this program is correct, or fully general wrt
            --input.  However, I do it here because that's
            --what the ex in Chap 18 does.
            --
            --What would probably be safer is to use a
            --map instead of a set, and let the key be the
            --date.  The map key is immutable so there would
            --be no problem.
            --
            --(Using a map might be better anyway, since
            --using a set of vectors as a multiset is
            --kind of awkward.)
            --END NOTE.
            --
            --NOTE: (update)
            --I decided to use a sorted vector, instead of
            --a set-of-vectors, or a map.  This is must
            --simpler than the alternatives.
            --ENDNOTE.

         end if;

         --Put_Line ("inserting student=" & Student);
         --see note below

         --Insert (Element (Students, Advisor), Student);
         --NOTE: This is how it's done in Musser's example.
         --The selector function (the index operator in C++)
         --automatically inserts the element if the key
         --doesn't already exist.  I don't like these
         --semantics, since I think insertions should be
         --explicit.
         --
         --Here is my preferred solution:
         --
         Insert (Students, Key => Advisor, New_Name => Student);


         --Put_Line ("inserting advisor=" & Advisor & " for student=" & Student);

         --Insert (Element (Advisors, Student), Advisor);
         --NOTE:
         --This is bizarre, since the advisor is being
         --inserted into a set whose elements are ordered
         --according to date of degree completion.  But this
         --is an advisor, who doesn't necessarily have such
         --a date.  (He wouldn't, unless he was listed as a
         --student earlier in his career prior to becoming
         --an advisor.
         --ENDNOTE.
         --
         Insert (Advisors, Key => Student, New_Name => Advisor);
         --NOTE: see note above.

         --New_Line;

      end;

   end loop;

end Read_File;


