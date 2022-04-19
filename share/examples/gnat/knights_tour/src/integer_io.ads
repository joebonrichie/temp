--  Various packages need an instantiation of Ada.Text_IO.Integer_IO
--  for type Integer, so doing one at the library level reduces code
--  size when compared to each client creating a local instantiation.

with Ada.Text_IO;

package Integer_IO is new Ada.Text_IO.Integer_IO (Integer);
