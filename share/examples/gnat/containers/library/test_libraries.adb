with Books;  use Books;
with Libraries;  use Libraries;
with Ada.Text_IO;  use Ada.Text_IO;

procedure Test_Libraries is

   L : Library_Type;

   procedure Print (Book : Book_Type) is
      Name : constant Name_Type := Author (Book);
   begin
      Put ("Title: "); Put_Line (Title (Book));
      Put ("Author: "); Put (Name.Last); Put (", "); Put_Line (Name.First);
      New_Line;
   end;

   Book : Book_Access;

begin

   declare
      N : constant Name_Type := New_Name ("Mark", "Twain");
   begin
      Add (L, New_Book ("Innocents Abroad", N));
      Add (L, New_Book ("Adventures of Huckleberry Finn", N));
      Add (L, New_Book ("Adventures of Tom Sawyer", N));
   end;

   declare
      N : constant Name_Type := New_Name ("P.D.", "James");
   begin
      Add (L, New_Book ("Death In Holy Orders", N));
   end;

   declare
      N : constant Name_Type := New_Name ("Hugo", "Victor");
   begin
      Add (L, New_Book ("Les miserables", N));
      Add (L, New_Book ("Quatre-vingt treize", N));
      Add (L, New_Book ("La legende des siecles", N));
   end;

   Book := New_Book ("The Fencing Master", New_Name ("Arturo", "Perez-Reverte"));
   Add (L, Book);

   New_Line;
   Put_Line ("Books listed by title:");
   New_Line;
   Books_By_Title (L, Print'Access);
   New_Line;

   Put_Line ("Books by Mark Twain:");
   New_Line;
   Books_By_Author (L, New_Name ("Mark", "Twain"), Print'Access);
   New_Line;

   Put_Line ("Books by P.D. James:");
   New_Line;
   Books_By_Author (L, New_Name ("P.D.", "James"), Print'Access);
   New_Line;

   Put_Line ("Books by Matthew Heaney:");
   New_Line;
   Books_By_Author (L, New_Name ("Matthew", "Heaney"), Print'Access);
   New_Line;

   Put_Line ("Books by Arturo Perez-Reverte:");
   New_Line;
   Books_By_Author (L, New_Name ("Arturo", "Perez-Reverte"), Print'Access);
   New_Line;

   Put_Line ("Books listed by author:");
   New_Line;
   Books_By_Author (L, Print'Access);
   New_Line;

   Put_Line ("Deleting P.D. James' book...");
   Remove (L, "Death in Holy Orders", New_Name ("P.D.", "James"));
   New_Line;

   Put_Line ("Books listed by title:");
   New_Line;
   Books_By_Title (L, Print'Access);
   New_Line;

   Put_Line ("Deleting the book by Arturo Perez-Reverte...");
   Remove (L, Book);
   New_Line;

   Put_Line ("Books listed by title:");
   New_Line;
   Books_By_Title (L, Print'Access);
   New_Line;

end Test_Libraries;
