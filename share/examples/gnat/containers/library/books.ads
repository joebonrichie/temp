package Books is
   pragma Elaborate_Body;

   type Book_Type (<>) is limited private;
   type Book_Access is access all Book_Type;

   function Title (Book : Book_Type) return String;

   type Name_Type (First_Length, Last_Length : Positive) is
      record
         First : String (1 .. First_Length);
         Last  : String (1 .. Last_Length);
      end record;

   function New_Name (First, Last : String) return Name_Type;

   function Author (Book : Book_Type) return Name_Type;

   function New_Book
     (Title  : String;
      Author : Name_Type) return Book_Access;

   procedure Free_Book (Book : in out Book_Access);

private

   type Book_Type (I, J, K : Positive) is
     limited record
        Title  : String (1 .. I);
        Author : Name_Type (J, K);
     end record;

end Books;




