----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.12.2019 01:31:49
-- Design Name: 
-- Module Name: nBitGen_tb - Behavioral
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

entity nBitGen_tb is
    Port ( trig : in STD_LOGIC;
           odata : out STD_LOGIC_VECTOR (7 downto 0));
end nBitGen_tb;

architecture Behavioral of nBitGen_tb is

component nBitGen is
    generic 
    (
        bitCount : integer :=8
    );
    Port ( TopTrig : in STD_LOGIC;
           randNum : out STD_LOGIC_VECTOR (bitCount-1 downto 0));
end component;

begin
Rgen: nBitGen
    generic map (bitCount=>8)
    port map (TopTrig=>trig,randNum=>odata);
end Behavioral;
