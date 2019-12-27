----------------------------------------------------------------------------------
--
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.12.2019 15:39:28
-- Design Name: 
-- Module Name: pulseGen - Behavioral
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

entity pulseGen is
    generic 
    ( 
        clkF : integer := 125000   ;  --clock freq in kHz
        pulseWidth : integer := 10 ;  --pulse width in ns 
        pulseFreq  : integer := 12500    --pulse frequency in kHz 
        
    );
    Port ( clk : in STD_LOGIC;
           en  : in STD_LOGIC:='1';
           pulseOut : out STD_LOGIC:='0');
end pulseGen;

architecture Behavioral of pulseGen is

    constant np    : integer := pulseWidth*clkF/(1E6);
    constant nw    : integer := clkF/pulseFreq;

    signal pulseticks          : integer :=0;
    signal windowticks         : integer :=0;

    signal pulse         : STD_LOGIC :='0';

begin

pulseOut<=pulse;  
 
 process(clk,en)
        begin
            if rising_edge(clk) then
               if en='1' then
                    windowticks <= (windowticks+1);
                    pulseticks  <= (pulseticks+1);
                        if windowticks = nw-1 then
                            pulse<='1';
                            windowticks <=0 ;
                            pulseticks  <=0 ;
                        elsif pulseticks=np-1 then
                            pulse<='0';
                        end if;    
               end if;
             end if;
 end process;
  
 end Behavioral;
