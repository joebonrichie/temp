with Ada.Unchecked_Deallocation;

package body Books is

   function New_Name (First, Last : String) return Name_Type is
   begin
      return Name_Type'(First'Length, Last'Length, First, Last);
   end;

   function Title (Book : Book_Type) return String is
   begin
      return Book.Title;
   end;

   function Author (Book : Book_Type) return Name_Type is
   begin
      return Book.Author;
   end;

   function New_Book
     (Title  : String;
      Author : Name_Type) return Book_Access is

      Book : constant Book_Access :=
        new Book_Type (Title'Length, Author.First_Length, Author.Last_Length);
   begin
      Book.Title := Title;
      Book.Author := Author;
      return Book;
   end;

   procedure Deallocate is
      new Ada.Unchecked_Deallocation (Book_Type, Book_Access);

   procedure Free_Book (Book : in out Book_Access) is
   begin
      Deallocate (Book);
   end;

end Books;




