with System;  use type System.Address;
with Ada.Strings.Less_Case_Insensitive;  use Ada.Strings;

package body Libraries is

   use Book_Sets, Title_Sets, Author_Sets;

   function Compare_Books (L, R : Book_Constant_Access) return Boolean is
   begin
      return L.all'Address < R.all'Address;
   end;

   function "<" (L, R : Books.Name_Type) return Boolean is
   begin
      if Less_Case_Insensitive (L.Last, R.Last) then
         return True;

      elsif Less_Case_Insensitive (R.Last, L.Last) then
         return False;

      else
         return Less_Case_Insensitive (L.First, R.First);

      end if;
   end "<";

   function Compare_Titles (L, R : Book_Sets.Cursor) return Boolean is
      LB : Book_Type renames Element (L).all;
      RB : Book_Type renames Element (R).all;

      LT : constant String := Title (LB);
      RT : constant String := Title (RB);
   begin
      if Less_Case_Insensitive (LT, RT) then
         return True;

      elsif Less_Case_Insensitive (RT, LT) then
         return False;

      else
         return Author (LB) < Author (RB);

      end if;
   end Compare_Titles;


   function Compare_Authors (L, R : Book_Sets.Cursor) return Boolean is
      LB : Book_Type renames Element (L).all;
      RB : Book_Type renames Element (R).all;

      LN : constant Name_Type := Author (LB);
      RN : constant Name_Type := Author (RB);
   begin
      if LN < RN then
         return True;

      elsif RN < LN then
         return False;

      else
         return Less_Case_Insensitive (Title (LB), Title (RB));

      end if;
   end Compare_Authors;


   procedure Add
     (Library : in out Library_Type;
      Book    : not null access constant Book_Type) is

      Book_Cursor : Book_Sets.Cursor;
      Inserted    : Boolean;
   begin
      Insert
        (Library.Book_Set,
         Book_Constant_Access (Book),
         Book_Cursor,
         Inserted);

      if Inserted then
         Insert (Library.Title_Set, Book_Cursor);
         Insert (Library.Author_Set, Book_Cursor);
      end if;
   end Add;


   procedure Remove
     (Library : in out Library_Type;
      Book    : not null access constant Book_Type) is

      Book_Cursor : Book_Sets.Cursor :=
        Find (Library.Book_Set, Book_Constant_Access (Book));
   begin
      if Has_Element (Book_Cursor) then
         Delete (Library.Title_Set, Book_Cursor);
         Delete (Library.Author_Set, Book_Cursor);
         Delete (Library.Book_Set, Book_Cursor);
      end if;
   end Remove;


   type Author_Key (I, J : Positive; K : Integer) is record
      Author : Name_Type (I, J);
      Title  : String (1 .. K);
   end record;

   function New_Key (Author : Name_Type; Title : String) return Author_Key is
      Key : Author_Key (Author.First_Length, Author.Last_Length, Title'Length);
   begin
      Key.Author := Author;
      Key.Title := Title;
      return Key;
   end New_Key;

   function New_Key (Author : Name_Type; Title : Integer) return Author_Key is
      Key : Author_Key (Author.First_Length, Author.Last_Length, Title);
   begin
      Key.Author := Author;
      return Key;
   end;

   function Key (Book_Cursor : Book_Sets.Cursor) return Author_Key is
      B : Book_Type renames Element (Book_Cursor).all;
   begin
      return New_Key (Author (B), Title (B));
   end;

   function "<" (L, R : Author_Key) return Boolean is
   begin
      if L.Author < R.Author then
         return True;

      elsif R.Author < L.Author then
         return False;

      elsif L.K = 0 then  --infinitely small title
         return R.K /= 0;

      elsif L.K < 0 then  --infinitely large title
         return False;

      elsif R.K = 0 then  --small
         return False;

      elsif R.K < 0 then  --large
         return True;

      else
         return Less_Case_Insensitive (L.Title, R.Title);
      end if;
   end "<";

   package Author_Keys is
      new Author_Sets.Generic_Keys (Author_Key, Key);

   procedure Remove
     (Library : in out Library_Type;
      Title   : in     String;
      Author  : in     Name_Type) is

      Key : constant Author_Key := New_Key (Author, Title);

      Author_Cursor : Author_Sets.Cursor :=
        Author_Keys.Find (Library.Author_Set, Key);
   begin
      if Has_Element (Author_Cursor) then
         declare
            Book_Cursor : Book_Sets.Cursor := Element (Author_Cursor);
         begin
            Delete (Library.Author_Set, Author_Cursor);
            Delete (Library.Title_Set, Book_Cursor);
            Delete (Library.Book_Set, Book_Cursor);
         end;
      end if;
   end Remove;



   procedure Books_By_Title
     (Library : in Library_Type;
      Process : not null access procedure (Book : Book_Type)) is

      S : Title_Sets.Set renames Library.Title_Set;

      procedure Process_Titles (C : Title_Sets.Cursor) is
         Book_Cursor : constant Book_Sets.Cursor := Element (C);
         Book : Book_Type renames Element (Book_Cursor).all;
      begin
         Process (Book);
      end;
   begin
      Iterate (S, Process_Titles'Access);
   end;


   procedure Books_By_Author
     (Library : in Library_Type;
      Process : not null access procedure (Book : in Book_Type)) is

      S : Author_Sets.Set renames Library.Author_Set;

      procedure Process_Authors (C : Author_Sets.Cursor) is
         Book_Cursor : constant Book_Sets.Cursor := Element (C);
         Book : Book_Type renames Element (Book_Cursor).all;
      begin
         Process (Book);
      end;
   begin
      Iterate (S, Process_Authors'Access);
   end;



   procedure Books_By_Author
     (Library : in Library_Type;
      Author  : in Name_Type;
      Process : not null access procedure (Book : in Book_Type)) is

      S : Author_Sets.Set renames Library.Author_Set;

      C1 : Author_Sets.Cursor :=
        Author_Keys.Ceiling (S, New_Key (Author, 0));  --infinitely small title

      C2 : constant Author_Sets.Cursor :=
        Author_Keys.Ceiling (S, New_Key (Author, -1)); --infinitely large title
   begin
      while C1 /= C2 loop
         declare
            Book_Cursor : constant Book_Sets.Cursor := Element (C1);
            Book : Book_Type renames Element (Book_Cursor).all;
         begin
            Process (Book);
         end;
         Next (C1);
      end loop;
   end Books_By_Author;

end Libraries;





