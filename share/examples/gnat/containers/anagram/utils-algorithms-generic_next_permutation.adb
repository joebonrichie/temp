------------------------------------------------------------------------------
--                                                                          --
--                                                                          --
--                                                                          --
--              Copyright (C) 2001-2004 Matthew J Heaney                    --
--                                                                          --
-- The Utils Container Library ("Utils") is free software; you can      --
-- redistribute it and/or modify it under terms of the GNU General Public   --
-- License as published by the Free Software Foundation; either version 2,  --
-- or (at your option) any later version.  Utils is distributed in the    --
-- hope that it will be useful, but WITHOUT ANY WARRANTY; without even the  --
-- implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. --
-- See the GNU General Public License for more details.  You should have    --
-- received a copy of the GNU General Public License distributed with       --
-- Utils;  see file COPYING.TXT.  If not, write to the Free Software      --
-- Foundation,  59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.    --
--                                                                          --
-- As a special exception, if other files instantiate generics from this    --
-- unit, or you link this unit with other files to produce an executable,   --
-- this unit does not by itself cause the resulting executable to be        --
-- covered by the GNU General Public License.  This exception does not      --
-- however invalidate any other reasons why the executable file might be    --
-- covered by the GNU Public License.                                       --
--                                                                          --
-- Utils is maintained by Matthew J Heaney.                               --
--                                                                          --
-- http://home.earthlink.net/~matthewjheaney/index.html                     --
-- mailto:matthewjheaney@earthlink.net                                      --
--                                                                          --
------------------------------------------------------------------------------

function Utils.Algorithms.Generic_Next_Permutation
  (First, Back : Iterator_Type) return Boolean is

   I, II, J : Iterator_Type;

begin

   if First = Back then
      return False;
   end if;

   I := Succ (First);

   if I = Back then
      return False;
   end if;

   I := Pred (Back);

   loop

      II := I;

      I := Pred (I);

      if Is_Less (I, II) then

         J := Back;

         loop

            J := Pred (J);

            exit when Is_Less (I, J);

         end loop;

         Swap (I, J);

         Reverse_Sequence (II, Back);

         return True;

      end if;

      if I = First then

         Reverse_Sequence (First, Back);

         return False;

      end if;

   end loop;

end Utils.Algorithms.Generic_Next_Permutation;



