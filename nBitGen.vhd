----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.12.2019 23:10:41
-- Design Name: 
-- Module Name: nBitGen - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity nBitGen is
    generic 
    (
        bitCount : integer :=4
    );
    Port ( TopTrig : in STD_LOGIC;
           randNum : out STD_LOGIC_VECTOR (bitCount-1 downto 0));
end nBitGen;

architecture Behavioral of nBitGen is

component lfsr is
    generic
    ( seedVal : STD_LOGIC_VECTOR(31 downto 0));
    Port ( trig : in STD_LOGIC;
           outBit : out STD_LOGIC);
end component;

type vector32 is array (natural range <>) of std_logic_vector(31 downto 0);

constant seeds : vector32(31 downto 0):=(x"1758f4be",x"e85beb6c",x"6140ef48",x"f47b2704",x"d4910a3a",x"525e856f",x"617a794f",x"85b09e0f",x"eb15afa8",x"7f7c28fc",
x"1c6ecf3e",x"e9248985",x"c6b129bd",x"f9344f16",x"1da1f583",x"ccd023a7",x"ddb218d2",x"f1f7cbce",x"674993ee",x"ec25b3df",
x"1d9186db",x"551b8051",x"24681025",x"bff64862",x"5ec7f468",x"68b6994b",x"c51e9721",x"45808258",x"b8c6a698",x"ee6ff0d3",
x"b4083c3c",x"d074bdb9");

begin
  numgen: 
   for I in 0 to bitCount-1 generate
    bitX : lfsr 
      generic map
      ( seedVal=>seeds(I) )
      port map
        (trig=>TopTrig, outBit=>randNum(I));
   end generate numgen;

end Behavioral;
