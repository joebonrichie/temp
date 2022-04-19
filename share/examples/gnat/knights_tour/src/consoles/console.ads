--  This package defines the abstract console for displayng the board and
--  visitation order.

package Console is

   type Device is abstract tagged null record;

   type Any_Device is access all Device'Class;

   type Location is
      record
         Row, Column : Natural;
      end record;

   procedure Clear (This : in out Device)
      is abstract;

   procedure Move_Cursor (This : in out Device; To : in Location)
      is abstract;

end Console;
