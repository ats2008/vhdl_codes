----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.12.2019 18:58:59
-- Design Name: 
-- Module Name: pulsegen_tb - Behavioral
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

entity pulsegen_tb is
    Port ( pout : out STD_LOGIC);
end pulsegen_tb;

architecture Behavioral of pulsegen_tb is

component pulseGen is
    generic 
    ( 
        clkF : integer := 125000   ;  --clock freq in kHz
        pulseWidth : integer := 16 ;  --pulse width in ns 
        pulseFreq  : integer := 12500    --pulse frequency in kHz 
        
    );
    Port ( clk : in STD_LOGIC;
           en  : in STD_LOGIC:='1';
           pulseOut : out STD_LOGIC:='0');
end component;

--TB CLOCK
signal tbCLK : std_logic  := '0';
constant hlf_P: time:=4 ns;



signal pulseSig   : std_logic:='0';
signal resetEnable   : std_logic:='1';
signal PulseCount   : integer:=0;

begin

tbCLK <= not tbCLK after hlf_P;
pout<=pulseSig;
apgen :pulseGen
 generic map 
    ( 
        clkF => 125000  ,       --clock freq in kHz
        pulseWidth  => 124,      --pulse width in ns 
        pulseFreq   =>  1000   --pulse frequency in kHz 
        
    )
    Port map ( clk =>tbCLK,
           pulseOut=>pulseSig,
           en=>resetEnable
           );
 INIT_process : process (pulseSig)

begin
    if falling_edge(pulseSig) then
        if PulseCount<2 then
            PulseCount<=PulseCount+1;
        else
            resetEnable<='0';
            
        end if;
    end if;
        
end process;

end Behavioral;
