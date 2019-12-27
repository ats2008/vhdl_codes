----------------------------------------------------------------------------------
-- Company: TIFR
-- Engineer: 
-- 
-- Create Date: 25.12.2019 03:27:00
-- Design Name: 
-- Module Name: dataHandling - Behavioral
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



--- Generalize the timing schemes
--- modify the monoshot to get rid of integer calcs

entity dataHandling is
  Port ( 
    CLK : IN STD_LOGIC :='0';
    RST : IN STD_LOGIC :='0';
    
    data : IN STD_LOGIC_VECTOR(15 downto 0 ) :=x"0000";
    data_vld : IN STD_LOGIC :='0';
    
    uart_data : out STD_LOGIC_VECTOR(7 downto 0 ) :=x"00";
    uart_data_send: out STD_LOGIC :='0'
  );
end dataHandling;

architecture Behavioral of dataHandling is

constant TperByte          : integer :=100000  ;
constant DataLengthByte    : integer :=2  ;


COMPONENT fifo_generator_0
  PORT 
  (
    clk     :   IN STD_LOGIC;
    srst    :   IN STD_LOGIC;
    din     :   IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    wr_en   :   IN STD_LOGIC;
    rd_en   :   IN STD_LOGIC;
    dout    :   OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    full    :   OUT STD_LOGIC;
    empty   :   OUT STD_LOGIC;
    wr_rst_busy : OUT STD_LOGIC;
    rd_rst_busy : OUT STD_LOGIC
  );
END COMPONENT;

component mux is
    Port ( key : in STD_LOGIC_VECTOR(0 downto 0):="0";
           i0 : in STD_LOGIC;
           i1 : in STD_LOGIC;
           out0 : out STD_LOGIC);
end component;

component monoshot is
     generic 
    ( 
        clkF : integer := 125000   ;  --clock freq in kHz
        pulseWidth : integer := 10  ; --pulse width in ns 
        PulseCount: integer := 1 ;  --pulse width in ns  
        offset: integer := 0      --pulse offset from trigger in ns 
    );
    Port ( clk : in STD_LOGIC;
           trig : in STD_LOGIC;
           pulseOut : out STD_LOGIC:='0');
end component;


component pulseGen is
    generic 
    ( 
        clkF : integer := 125000   ;  --clock freq in kHz
        pulseWidth : integer := 10 ;  --pulse width in ns 
        pulseFreq  : integer := 12500    --pulse frequency in kHz 
        
    );
    Port ( clk : in STD_LOGIC;
           en  : in STD_LOGIC:='1';
           pulseOut : out STD_LOGIC:='0');
end component;


component counter is
    generic ( width : integer:=1);
    Port ( trig : in STD_LOGIC;
           count : out STD_LOGIC_VECTOR (width-1 downto 0);
           rst : in STD_LOGIC:='0'
          );
end component;


signal  s_clk	:	std_logic	:='0';

signal  fifo_clk	:	std_logic	:='0';
signal  fifo_srst	:	std_logic	:='0';
signal  fifo_din	:	std_logic_vector(15 downto 0)	:=x"0000";
signal  fifo_wr_en	:	std_logic	:='0';
signal  fifo_rd_en	:	std_logic	:='0';
signal  fifo_dout	:	std_logic_vector(15 downto 0)	:=x"0000";
signal  fifo_full	:	std_logic	:='0';
signal  fifo_empty	:	std_logic	:='0';
signal  fifo_wr_rst_busy	:	std_logic	:='0';
signal  fifo_rd_rst_busy    :	std_logic	:='0';

signal  fifo_ReadTrig      :	std_logic	:='0';
signal  readPulse          :	std_logic	:='0';
signal  readEn          :	std_logic	:='0';

signal  counterTrig        :	std_logic	:='0';
signal  MuxState           :	std_logic_vector(0 downto 0)   :="0";

signal  data_line          :    std_logic_vector(7 downto 0)   :=x"00";
signal  data_send         :    std_logic :='0';


begin
s_clk<=CLK;

--- write the data to fifo

fifo_clk<=s_clk;
fifo_srst<=RST;
fifo_din<=data;
fifo_wr_en<=data_vld and not fifo_full;

data_Bank : fifo_generator_0
  PORT MAP (
    clk => fifo_clk,
    srst => fifo_srst,
    din => fifo_din,
    wr_en => fifo_wr_en,
    rd_en => fifo_rd_en,
    dout => fifo_dout,
    full => fifo_full,
    empty => fifo_empty,
    wr_rst_busy => fifo_wr_rst_busy,
    rd_rst_busy => fifo_rd_rst_busy
  );    
  
-- read data from FIFO

fifo_rd_en<=readEn;
read_pulse_gen :pulseGen
 generic map ( 
        clkF => 125000  ,       --clock freq in kHz
        pulseWidth  => 48,     --pulse width in ns 
        pulseFreq   =>  5 )     --pulse frequency in kHz 
 Port map ( clk =>s_CLK,
           pulseOut=>readPulse,
           en=>'1' );
           
readEn<= readPulse and not fifo_empty; 

gen_mux: for I in 0 to 7 generate
      muxx : mux port map
        (key=>MuxState,
        
        i0=>fifo_dout(I+8),
        i1=>fifo_dout(I),
        
        out0=>data_line(I));
   end generate gen_mux;

MuxState_counter :  counter 
    generic map ( width =>1)
    Port map( trig  => counterTrig,
           count =>MuxState,
           rst =>readEn
          );

counter_MSHOT :  monoshot
     generic  map( 
        clkF =>125000   ,  
        pulseWidth => TperByte/2 ,  
        PulseCount=>2,
        offset=>TperByte/2)
    Port map ( clk => s_CLK,
               trig=> readEn,
               pulseOut => counterTrig);

dsend_MSHOT :  monoshot
     generic  map( 
        clkF =>125000   ,  
        pulseWidth => TperByte/2 ,  
        PulseCount=>2,
        offset=>TperByte/10)
     port map( clk => s_CLK,
               trig=> readEn,
               pulseOut => data_send);

uart_data<=data_line;
uart_data_send<=data_send and not fifo_empty;

end Behavioral;
