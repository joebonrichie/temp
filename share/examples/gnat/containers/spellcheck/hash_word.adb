--I copied this hash function from the C++ spellcheck shootout example:
--http://shootout.alioth.debian.org/benchmark.php?test=spellcheck&lang=gpp&id=0&sort=fullcpu
--This algorithm seems to do better than my implementation of ada.strings.hash.

function Hash_Word (S : String) return Hash_Type is
   H : Hash_Type := 0;
begin
   for I in S'Range loop
      H := 5 * H + Character'Pos (S (I));
   end loop;
   return H;
end Hash_Word;
