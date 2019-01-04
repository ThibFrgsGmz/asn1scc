
package body adaasn1rtl with Spark_Mode is

   MASKS  : constant OctetBuffer_0_7 := OctetBuffer_0_7'(0 => 16#80#, 1=> 16#40#, 2=>16#20#, 3=>16#10#, 4=>16#08#, 5=>16#04#, 6=>16#02#, 7=>16#01#);
   MASKSB : constant OctetBuffer_0_7 := OctetBuffer_0_7'(0 => 16#00#, 1=> 16#01#, 2=>16#03#, 3=>16#07#, 4=>16#1F#, 5=>16#3F#, 6=>16#7F#, 7=>16#FF#);
   
   MantissaFactor : constant Asn1Real :=  Asn1Real (Interfaces.Unsigned_64 (2)**Asn1Real'Machine_Mantissa);
   
   function To_UInt (IntVal : Asn1Int) return Asn1UInt is
      ret : Asn1UInt;
   begin
      if IntVal < 0 then
         ret := Asn1UInt (-(IntVal + 1));
         ret := not ret;
      else
         ret := Asn1UInt (IntVal);
      end if;
      return ret;
   end To_UInt;
   
   function To_Int (IntVal : Asn1UInt) return Asn1Int is
      ret : Asn1Int;
      c   : Asn1UInt;
   begin
      if IntVal > Asn1UInt (Asn1Int'Last) then
         c   := not IntVal;
         ret := -Asn1Int (c) - 1;
      else
         ret := Asn1Int (IntVal);
      end if;
      return ret;
   end To_Int;
   
   
   function Sub (A : in Asn1Int; B : in Asn1Int) return Asn1UInt
   is
      ret : Asn1UInt;
      au  : Asn1UInt;
      bu  : Asn1UInt;
   begin

      au := To_UInt (A);
      bu := To_UInt (B);

      if au >= bu then
         ret := au - bu;
      else
         ret := bu - au;
         ret := not ret;
         ret := ret + 1;
      end if;

      return ret;
   end Sub;
   
   function GetBytes (V : Asn1UInt) return Asn1Byte
   is
      Ret : Asn1Byte;
   begin
      if V < 16#100# then
         Ret := 1;
      elsif V < 16#10000# then
         Ret := 2;
      elsif V < 16#1000000# then
         Ret := 3;
      elsif V < 16#100000000# then
         Ret := 4;
      elsif V < 16#10000000000# then
         Ret := 5;
      elsif V < 16#1000000000000# then
         Ret := 6;
      elsif V < 16#100000000000000# then
         Ret := 7;
      else
         Ret := 8;
      end if;
      return Ret;
   end GetBytes;
   
   function GetLengthInBytesOfSIntAux (V : Asn1UInt) return Asn1Byte
   is
      Ret : Asn1Byte;
   begin
      if V < 16#80# then
         Ret := 1;
      elsif V < 16#8000# then
         Ret := 2;
      elsif V < 16#800000# then
         Ret := 3;
      elsif V < 16#80000000# then
         Ret := 4;
      elsif V < 16#8000000000# then
         Ret := 5;
      elsif V < 16#800000000000# then
         Ret := 6;
      elsif V < 16#80000000000000# then
         Ret := 7;
      else
         Ret := 8;
      end if;

      return Ret;
   end GetLengthInBytesOfSIntAux;

   function GetLengthInBytesOfSInt (V : Asn1Int) return Asn1Byte
   is
      Ret : Asn1Byte;
   begin
      if V >= 0 then
         Ret := GetLengthInBytesOfSIntAux (Asn1UInt (V));
      else
         Ret := GetLengthInBytesOfSIntAux (Asn1UInt (-(V + 1)));
      end if;
      return Ret;
   end GetLengthInBytesOfSInt;
   
   
--     function Get_number_of_digits (Int_value : Asn1UInt) return Integer
--     is
--        totalNibbles : Integer:=1;
--     begin
--        
--        while  Int_value >= Powers_of_10(totalNibbles) loop
--           pragma Loop_Invariant (totalNibbles>=1 and totalNibbles <= 19);
--           totalNibbles:= totalNibbles + 1;
--        end loop;
--        return totalNibbles;
--       end Get_number_of_digits;
      
   
   function Get_number_of_digits (Int_value : Asn1UInt) return Integer
   is (
      if Int_value < Powers_of_10(1) then 1
      elsif Int_value >= Powers_of_10(1) and Int_value < Powers_of_10(2)    then 2 
      elsif Int_value >= Powers_of_10(2) and Int_value < Powers_of_10(3)    then 3 
      elsif Int_value >= Powers_of_10(3) and Int_value < Powers_of_10(4)    then 4 
      elsif Int_value >= Powers_of_10(4) and Int_value < Powers_of_10(5)    then 5 
      elsif Int_value >= Powers_of_10(5) and Int_value < Powers_of_10(6)    then 6 
      elsif Int_value >= Powers_of_10(6) and Int_value < Powers_of_10(7)    then 7 
      elsif Int_value >= Powers_of_10(7) and Int_value < Powers_of_10(8)    then 8 
      elsif Int_value >= Powers_of_10(8) and Int_value < Powers_of_10(9)    then 9 
      elsif Int_value >= Powers_of_10(9) and Int_value < Powers_of_10(10)   then 10 
      elsif Int_value >= Powers_of_10(10) and Int_value < Powers_of_10(11)  then 11 
      elsif Int_value >= Powers_of_10(11) and Int_value < Powers_of_10(12)  then 12 
      elsif Int_value >= Powers_of_10(12) and Int_value < Powers_of_10(13)  then 13 
      elsif Int_value >= Powers_of_10(13) and Int_value < Powers_of_10(14)  then 14 
      elsif Int_value >= Powers_of_10(14) and Int_value < Powers_of_10(15)  then 15 
      elsif Int_value >= Powers_of_10(15) and Int_value < Powers_of_10(16)  then 16 
      elsif Int_value >= Powers_of_10(16) and Int_value < Powers_of_10(17)  then 17 
      elsif Int_value >= Powers_of_10(17) and Int_value < Powers_of_10(18)  then 18 
       else 19 );
   
   
   function GetZeroBasedCharIndex (CharToSearch   :    Character;  AllowedCharSet : in String) return Integer
   is
      ret : Integer;
   begin
      ret := 0;
      for I in Integer range AllowedCharSet'Range loop
         ret := I - AllowedCharSet'First;
         pragma Loop_Invariant  ( 
            AllowedCharSet'Last >= AllowedCharSet'First and
            AllowedCharSet'Last <= Integer'Last - 1 and
            ret = I - AllowedCharSet'First);
         exit when CharToSearch = AllowedCharSet (I);
      end loop;
      return ret;
   end GetZeroBasedCharIndex;

   function CharacterPos (C : Character) return Integer is
      ret : Integer;
   begin
      ret := Character'Pos (C);
      if not (ret >= 0 and ret <= 127) then
         ret := 0;
      end if;
      return ret;
    end CharacterPos;
   
   

   function GetExponent (V : Asn1Real) return Asn1Int is
      pragma SPARK_Mode (Off);
   --due to the fact that Examiner has not yet implement the Exponent attribute
   begin
      return Asn1Int (Asn1Real'Exponent (V) - Asn1Real'Machine_Mantissa);
   end GetExponent;

   function GetMantissa (V : Asn1Real) return Asn1UInt is
      pragma SPARK_Mode (Off);
   --due to the fact that Examiner has not yet implement the Fraction attribute
   begin
      return Asn1UInt (Asn1Real'Fraction (V) * MantissaFactor);
   end GetMantissa;
   
   
   
   function Zero return Asn1Real is
   begin
      return 0.0;
   end Zero;

   function PLUS_INFINITY return Asn1Real is
      pragma SPARK_Mode (Off);
   begin
      return 1.0 / Zero;
   end PLUS_INFINITY;

   function MINUS_INFINITY return Asn1Real is
      pragma SPARK_Mode (Off);
   begin
      return -1.0 / Zero;
   end MINUS_INFINITY;
   
   function RequiresReverse (dummy : Boolean) return Boolean is
      pragma SPARK_Mode (Off);
      dword : Integer := 16#00000001#;
      arr   : aliased OctetArray4;
      for arr'Address use dword'Address;
   begin
      return arr (arr'First) = 1;
   end RequiresReverse;   
   
   
   
    procedure ObjectIdentifier_Init(val:out Asn1ObjectIdentifier)
    is
    begin
        val.Length :=0;
        val.values := ObjectIdentifier_array'(others => 0);
    end ObjectIdentifier_Init;


    function ObjectIdentifier_isValid(val : in Asn1ObjectIdentifier) return boolean
    is
    begin
        return val.Length >=2 and then val.values(1)<=2 and then val.values(2)<=39;
    end ObjectIdentifier_isValid;

    function RelativeOID_isValid(val : in Asn1ObjectIdentifier) return boolean
    is
    begin
        return val.Length > 0;
    end RelativeOID_isValid;

    function ObjectIdentifier_equal(val1 : in Asn1ObjectIdentifier; val2 : in Asn1ObjectIdentifier) return boolean
    is
        ret : boolean;
        i : integer;
    begin
        ret := val1.Length = val2.length;
        i := 1;
        while ret and i <= val1.Length loop
            pragma Loop_Invariant(i>=1 and i <= val1.Length and val1.Length = val2.length);
            ret := val1.values(i) = val2.values(i);
            i := i + 1;
        end loop;

        return ret;
    end ObjectIdentifier_equal;
   
   
   
   function BitStream_init (Bitstream_Size_In_Bytes : Positive) return Bitstream
   is
      (Bitstream'(Size_In_Bytes    => Bitstream_Size_In_Bytes,
                 Current_Bit_Pos  => 0,
                 Buffer           => (others => 0)));
   
   
   
   procedure BitStream_AppendBit(bs : in out BitStream; Bit_Value : in BIT) 
   is
      Current_Byte : constant Integer   := bs.Buffer'First + bs.Current_Bit_Pos / 8;
      Current_Bit  : constant BIT_RANGE := bs.Current_Bit_Pos mod 8;
   begin 

         bs.buffer(Current_Byte) := 
           (if Bit_Value = 1 then
               bs.buffer(Current_Byte) or MASKS(Current_Bit)
            else 
               bs.buffer(Current_Byte) and (not MASKS(Current_Bit)));
      
      bs.Current_Bit_Pos := bs.Current_Bit_Pos + 1;   

      end;
   
   procedure BitStream_ReadBit(bs : in out BitStream; Bit_Value : out BIT; result :    out Boolean)
   is
      Current_Byte : constant Integer   := bs.Buffer'First + bs.Current_Bit_Pos / 8;
      Current_Bit  : constant BIT_RANGE := bs.Current_Bit_Pos mod 8;
   begin
      result := bs.Current_Bit_Pos < Natural'Last and bs.Current_Bit_Pos < bs.Size_In_Bytes * 8;

      if (bs.buffer(Current_Byte) and MASKS(Current_Bit)) > 0 then
         Bit_Value := 1;
      else
         Bit_Value := 0;
      end if;
      
      bs.Current_Bit_Pos := bs.Current_Bit_Pos + 1;   
   end;
   
   
   procedure BitStream_AppendByte(bs : in out BitStream; Byte_Value : in Asn1Byte; Negate : in Boolean)
   is
      Current_Byte : constant Integer   := bs.Buffer'First + bs.Current_Bit_Pos / 8;
      Current_Bit  : constant BIT_RANGE := bs.Current_Bit_Pos mod 8;
      byteVal : Asn1Byte;
      ncb :BIT_RANGE;
   begin
      if Negate then
         byteVal := not Byte_Value;
      else
         byteVal := Byte_Value;
      end if;
      
      if Current_Bit > 0 then
         ncb := 8 - Current_Bit;
         bs.buffer(Current_Byte) := bs.buffer(Current_Byte) or Shift_right(ByteVal, Current_Bit);
         bs.buffer(Current_Byte+1) := Shift_left(ByteVal, ncb);
      else
         bs.buffer(Current_Byte) := ByteVal;
      end if;
       bs.Current_Bit_Pos := bs.Current_Bit_Pos + 8;
   end;
   
   
   procedure BitStream_DecodeByte(bs : in out BitStream; Byte_Value : out Asn1Byte; success   :    out Boolean) 
   is
      Current_Byte : constant Integer   := bs.Buffer'First + bs.Current_Bit_Pos / 8;
      Current_Bit  : constant BIT_RANGE := bs.Current_Bit_Pos mod 8;
      ncb :BIT_RANGE;
   begin
      success := bs.Current_Bit_Pos < Natural'Last - 8 and then  
                bs.Size_In_Bytes < Positive'Last/8 and  then
        bs.Current_Bit_Pos < bs.Size_In_Bytes * 8 - 8;
      
      if Current_Bit > 0 then
         ncb := 8 - Current_Bit;
         Byte_Value := Shift_left(bs.buffer(Current_Byte), Current_Bit);
         Byte_Value := Byte_Value or Shift_right(bs.buffer(Current_Byte + 1), ncb);
      else
         Byte_Value := bs.buffer(Current_Byte);
      end if;

      bs.Current_Bit_Pos := bs.Current_Bit_Pos + 8;
      
   end;
   
   procedure BitStream_ReadNibble(bs : in out BitStream; Byte_Value : out Asn1Byte; success   :    out Boolean)
   is
      Current_Byte : constant Integer   := bs.Buffer'First + bs.Current_Bit_Pos / 8;
      Current_Bit  : constant BIT_RANGE := bs.Current_Bit_Pos mod 8;
      totalBitsForNextByte : BIT_RANGE;
   begin
      success := bs.Current_Bit_Pos < Natural'Last - 4 and then  
                bs.Size_In_Bytes < Positive'Last/8 and  then
        bs.Current_Bit_Pos < bs.Size_In_Bytes * 8 - 4;

      if Current_Bit < 4 then
         Byte_Value := Shift_right(bs.buffer(Current_Byte), 4 - Current_Bit) and 16#0F#;
      else
         totalBitsForNextByte := Current_Bit - 4;
         Byte_Value := Shift_left(bs.buffer(Current_Byte), totalBitsForNextByte);
         --bs.currentBytePos := bs.currentBytePos + 1;
         Byte_Value := Byte_Value or (Shift_right(bs.buffer(Current_Byte + 1), 8 - totalBitsForNextByte));
         Byte_Value := Byte_Value and 16#0F#;
      end if;
      bs.Current_Bit_Pos := bs.Current_Bit_Pos + 4;
   end;
   
   
   procedure BitStream_AppendPartialByte(bs : in out BitStream; Byte_Value : in Asn1Byte; nBits : in BIT_RANGE; negate : in Boolean)
   is
      Current_Byte :  Integer   := bs.Buffer'First + bs.Current_Bit_Pos / 8;
      cb  : constant BIT_RANGE := bs.Current_Bit_Pos mod 8;
      totalBits : BIT_RANGE;
      totalBitsForNextByte : BIT_RANGE;
      byteValue : Asn1Byte;
   begin
         byteValue := (if negate then (masksb(nBits) and  not Byte_Value) else Byte_Value);
         
         if cb < 8 - nbits then
            totalBits := cb + nBits;
            bs.buffer(Current_Byte) := bs.buffer(Current_Byte) or Shift_left(byteValue, 8 -totalBits);
         else
            totalBitsForNextByte := cb+nbits - 8;
            bs.buffer(Current_Byte) := bs.buffer(Current_Byte) or Shift_right(byteValue, totalBitsForNextByte);
            Current_Byte := Current_Byte + 1;
            bs.buffer(Current_Byte) := bs.buffer(Current_Byte) or Shift_left(byteValue, 8 - totalBitsForNextByte);
           
      end if;
      bs.Current_Bit_Pos := bs.Current_Bit_Pos + nBits;
      
   end;
   
   procedure BitStream_ReadPartialByte(bs : in out BitStream; Byte_Value : out Asn1Byte; nBits : in BIT_RANGE)   
   is
      Current_Byte :  Integer   := bs.Buffer'First + bs.Current_Bit_Pos / 8;
      cb  : constant BIT_RANGE := bs.Current_Bit_Pos mod 8;
      totalBits : BIT_RANGE;
      totalBitsForNextByte : BIT_RANGE;
   begin
         if cb < 8 - nbits then
            totalBits := cb + nBits;
            Byte_Value := Shift_Right(bs.buffer(Current_Byte), 8 -totalBits) and MASKSB(nBits);
         else
            totalBitsForNextByte := cb+nbits - 8;
            Byte_Value := Shift_left(bs.buffer(Current_Byte), totalBitsForNextByte);
            Current_Byte := Current_Byte + 1;
            Byte_Value := Byte_Value or Shift_right(bs.buffer(Current_Byte), 8 - totalBitsForNextByte);
            Byte_Value := Byte_Value and MASKSB(nBits);
      end if;
      bs.Current_Bit_Pos := bs.Current_Bit_Pos + nBits;
   end;
   
   
   procedure BitStream_Encode_Non_Negative_Integer(bs : in out BitStream; intValue   : in Asn1UInt; nBits : in Integer) 
   is
      byteValue : Asn1Byte;
      tmp : Asn1UInt;
      total_bytes : constant Integer := nBits/8;
      cc : constant BIT_RANGE := nBits mod 8;
      bits_to_shift :Integer;
   begin
      for i in 1 .. total_bytes loop
         bits_to_shift := (total_bytes- i)*8 + cc;
         tmp := 16#FF# and Shift_right(intValue, bits_to_shift);
         byteValue := Asn1Byte (tmp);

         pragma Loop_Invariant (bs.Current_Bit_Pos = bs.Current_Bit_Pos'Loop_Entry + (i-1)*8);
         
         BitStream_AppendByte(bs, byteValue, false);
      end loop;

      if cc > 0 then
         byteValue := MASKSB(cc) and Asn1Byte(16#FF# and intValue);
         BitStream_AppendPartialByte(bs, byteValue, cc, False);
      end if;

   end;
   
   procedure BitStream_Decode_Non_Negative_Integer (bs : in out BitStream; IntValue : out Asn1UInt; nBits : in Integer;  result : out Boolean)
   is
      byteValue : Asn1Byte;
      total_bytes : constant Integer := nBits/8;
      cc : constant BIT_RANGE := nBits mod 8;
   begin
      result :=
                nBits >= 0 and then 
                nBits < Asn1UInt'Size and then 
                bs.Current_Bit_Pos < Natural'Last - nBits and then  
                bs.Size_In_Bytes < Positive'Last/8 and  then
                bs.Current_Bit_Pos < bs.Size_In_Bytes * 8 - nBits;      
      IntValue := 0;
      
      for i in 1 .. total_bytes loop
         pragma Loop_Invariant (bs.Current_Bit_Pos = bs.Current_Bit_Pos'Loop_Entry + (i-1)*8);

         BitStream_DecodeByte(bs, byteValue, Result);
         IntValue := (IntValue * 256) or Asn1UInt(byteValue);
      end loop;
      
      if cc > 0 then
         BitStream_ReadPartialByte(bs, byteValue, cc);
         
         IntValue := Shift_left(IntValue,cc) or Asn1UInt(byteValue);
      end if;
      
   end BitStream_Decode_Non_Negative_Integer;
   
   

   procedure Enc_UInt (bs : in out BitStream;  intValue : in     Asn1UInt;  total_bytes : in Integer)
   is
      byteValue : Asn1Byte;
      tmp : Asn1UInt;
      bits_to_shift :Integer;
   begin

      for i in 1 .. total_bytes loop
         bits_to_shift := (total_bytes- i)*8;
         tmp := 16#FF# and Shift_right(intValue, bits_to_shift);
         byteValue := Asn1Byte (tmp);

         pragma Loop_Invariant (bs.Current_Bit_Pos = bs.Current_Bit_Pos'Loop_Entry + (i-1)*8);
         
         BitStream_AppendByte(bs, byteValue, false);
      end loop;

      
   end Enc_UInt;
   
   procedure Dec_UInt (bs : in out BitStream; total_bytes : Integer; Ret: out Asn1UInt; Result :    out Boolean)
   is
      ByteVal : Asn1Byte;
   begin
      Ret    := 0;
      Result := total_bytes >= 0 and then 
                total_bytes <= Asn1UInt'Size/8 and then 
                bs.Current_Bit_Pos < Natural'Last - total_bytes*8 and then  
                bs.Size_In_Bytes < Positive'Last/8 and  then
                bs.Current_Bit_Pos < bs.Size_In_Bytes * 8 - total_bytes*8;
      
      for i in 1 .. total_bytes loop
         pragma Loop_Invariant (bs.Current_Bit_Pos = bs.Current_Bit_Pos'Loop_Entry + (i-1)*8);

         BitStream_DecodeByte(bs, ByteVal, Result);
         Ret := Ret * 256; --shift left one byte
         Ret := Ret + Asn1UInt(ByteVal);

      end loop;
      
      pragma Assume( Ret < 256**total_bytes);

   end Dec_UInt;
   

   
   procedure Dec_Int (bs : in out BitStream; total_bytes : Integer; int_value: out Asn1Int; Result :    out Boolean)
   is
      Current_Byte : constant Integer   := bs.Buffer'First + bs.Current_Bit_Pos / 8;
      Current_Bit  : constant BIT_RANGE := bs.Current_Bit_Pos mod 8;
      ByteVal : Asn1Byte;
      Ret:  Asn1UInt;
   begin
      Result := total_bytes >= 0 and then 
                total_bytes <= Asn1UInt'Size/8 and then 
                bs.Current_Bit_Pos < Natural'Last - total_bytes*8 and then  
                bs.Size_In_Bytes < Positive'Last/8 and  then
                bs.Current_Bit_Pos < bs.Size_In_Bytes * 8 - total_bytes*8;
      
      if (bs.buffer(Current_Byte) and MASKS(Current_Bit)) > 0 then
         Ret := 0;
      else
         Ret := Asn1UInt'Last;
      end if;
      
      for i in 1 .. total_bytes loop
         pragma Loop_Invariant (bs.Current_Bit_Pos = bs.Current_Bit_Pos'Loop_Entry + (i-1)*8);

         BitStream_DecodeByte(bs, ByteVal, Result);
         Ret := (Ret * 256) or Asn1UInt(ByteVal);

      end loop;
      int_value := To_Int(Ret);
   end Dec_Int;
   
   
   

   
   
   
   
   
end adaasn1rtl;
