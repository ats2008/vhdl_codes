----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.12.2019 10:08:23
-- Design Name: 
-- Module Name: monoshot_tb - Behavioral
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

entity monoshot_tb is
  Port (  mSHOT1 : out std_logic  := '0';
           mSHOT2 : out std_logic  := '0');
end monoshot_tb;

architecture Behavioral of monoshot_tb is

component monoshot is
     generic 
    ( 
        clkF : integer := 125000   ;  --clock freq in kHz
        pulseWidth : integer := 40 ;  --pulse width in ns 
        PulseCount: integer := 1  ; --pulse width in ns
        offset: integer := 0 
    );
    Port ( clk : in STD_LOGIC;
           trig : in STD_LOGIC;
           pulseOut : out STD_LOGIC:='0');
end component;

--TB CLOCK
signal tbCLK : std_logic  := '0';
constant hlf_P: time:=4 ns;



signal trigT   : std_logic:='0';
signal pulseSig   : std_logic:='0';
--signal trig   : std_logic:='1';

begin

tbCLK <= not tbCLK after hlf_P;

 DUT : monoshot
     generic  map
    ( 
        clkF =>125000   ,  --clock freq in kHz
        pulseWidth => 40 ,  --pulse width in ns
        PulseCount=>1 ,
        offset=>40
    )
    Port map ( clk => tbCLK,
               trig=> trigT,
           pulseOut => mSHOT1);
           
DUT2 : monoshot
     generic  map
    ( 
        clkF =>125000   ,  --clock freq in kHz
        pulseWidth => 20 ,  --pulse width in ns
        PulseCount=>2 ,
        offset=>20
    )
    Port map ( clk => tbCLK,
               trig=> trigT,
           pulseOut => mSHOT2);
           
                      
dut_test : process
begin
    trigT<='0';
    wait for 500ns;
    trigT<='1';
    wait for 10ns;
    trigT<='0';
    wait for 500ns;
end process;
end Behavioral;
