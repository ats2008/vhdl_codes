----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.12.2019 17:02:37
-- Design Name: 
-- Module Name: mux - Behavioral
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

entity mux is
    Port ( key : in STD_LOGIC_VECTOR(0 downto 0):="0";
           i0 : in STD_LOGIC;
           i1 : in STD_LOGIC;
           out0 : out STD_LOGIC);
end mux;



architecture Behavioral of mux is

begin
    
  with key select
     out0 <= i0 when "0" ,
             i1 when "1" ,
             '0' when others; 
                
end Behavioral;
