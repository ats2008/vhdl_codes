----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 20.12.2019 09:58:31
-- Design Name: 
-- Module Name: monoshot - Behavioral
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

-----

 --  Needs to implement using signals .. removing the 32 bit integers
-----
entity monoshot is
     generic 
    ( 
        clkF : integer := 125000   ;  --clock freq in kHz
        pulseWidth : integer := 10 ;   --pulse width in ns 
        PulseCount: integer := 1 ;  --pulse width in ns  
        offset: integer := 0      --pulse offset from trigger in ns 
    );
    Port ( clk : in STD_LOGIC;
           trig : in STD_LOGIC;
           pulseOut : out STD_LOGIC:='0');
end monoshot;

architecture Behavioral of monoshot is
    
    constant np    : integer := pulseWidth*clkF/(1E6);
    constant PulseTCount    : integer := 2*PulseCount;
    constant offsetTCount    : integer := offset*clkF/(1E6);
    signal pulseticks          : integer :=0;
    signal pcounts         : integer :=0;
    signal offsetCnt         : integer :=0;
   
    signal pulse         : STD_LOGIC :='0';
    signal busy         : STD_LOGIC :='0';
begin
pulseOut<=pulse;  
 
 process(clk,trig)
        begin
            if rising_edge(clk) then
                if busy='1' then
                   pulseticks  <= (pulseticks+1);
                   if offsetCnt<offsetTCount then
                        offsetCnt<=offsetCnt+1;
                        pulseticks<=0;
                   elsif offsetCnt=offsetTCount then
                        pulse<='1';
                        offsetCnt<=offsetCnt+1;
                   elsif pulseticks>np then
                       if (pcounts < PulseTCount)  then
                            pcounts<=pcounts+1;
                            pulseticks<=0;
                            pulse<=not pulse;
                        else 
                            pulseticks<=np+1;
                            pcounts<=PulseTCount+1;
                            pulse<='0';
                            busy<='0';
                        end if; 
                   end if;
               end if;
            end if;
           if rising_edge(trig) then
                busy<='1'; 
                pulse<='0';
                pulseticks<=0;
                pcounts<=1;
                offsetCnt<=0;
           end if;
 end process;


--process(trig)
--    begin
--        if rising_edge(trig) then
--            start<='1';        
--        elsif falling_edge(trig) then
--            start<='0';
--        end if;
--end process;
end Behavioral;
