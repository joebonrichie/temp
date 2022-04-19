with Books;  use Books;

with Ada.Containers.Ordered_Sets;
pragma Elaborate_All (Ada.Containers.Ordered_Sets);

with Ada.Containers.Ordered_Maps;
pragma Elaborate_All (Ada.Containers.Ordered_Maps);

package Libraries is
   pragma Elaborate_Body;

   type Library_Type is limited private;

   procedure Add
     (Library : in out Library_Type;
      Book    : not null access constant Book_Type);

   procedure Remove
     (Library : in out Library_Type;
      Book    : not null access constant Book_Type);

   procedure Remove
     (Library : in out Library_Type;
      Title   : in     String;
      Author  : in     Name_Type);

   procedure Books_By_Title
     (Library : in Library_Type;
      Process : not null access procedure (Book : in Book_Type));

   procedure Books_By_Author
     (Library : in Library_Type;
      Process : not null access procedure (Book : in Book_Type));

   procedure Books_By_Author
     (Library : in Library_Type;
      Author  : in Name_Type;
      Process : not null access procedure (Book : in Book_Type));

private

   type Book_Constant_Access is access constant Book_Type;
   for Book_Constant_Access'Storage_Size use 0;

   function Compare_Books (L, R : Book_Constant_Access) return Boolean;

   package Book_Sets is
      new Ada.Containers.Ordered_Sets
     (Book_Constant_Access,
      "<" => Compare_Books);

   use type Book_Sets.Cursor;

   function Compare_Titles (L, R : Book_Sets.Cursor) return Boolean;

   package Title_Sets is
      new Ada.Containers.Ordered_Sets
     (Book_Sets.Cursor,
      "<" => Compare_Titles);

   function Compare_Authors (L, R : Book_Sets.Cursor) return Boolean;

   package Author_Sets is
      new Ada.Containers.Ordered_Sets
     (Book_Sets.Cursor,
      "<" => Compare_Authors);

   type Library_Type is limited record
      Book_Set  : Book_Sets.Set;
      Title_Set : Title_Sets.Set;
      Author_Set : Author_Sets.Set;
   end record;

end Libraries;
