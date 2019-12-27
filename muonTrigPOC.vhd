----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.12.2019 22:44:39
-- Design Name: 
-- Module Name: muonTrigPOC - Behavioral
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

entity muonTrigPOC is
  Port ( 
            
            CLK     :   in  std_logic :='0';
            RST     :   in  std_logic :='0';
            D1      :   in  std_logic :='0';
            D2      :   in  std_logic :='0';
            D3      :   in  std_logic :='0';
            D4_sig  :   in  std_logic ;

            ADC_data:   in  std_logic_vector(15 downto 0) :=x"0000";
            ADC_dataReady   :   in  std_logic :='0';
            
            ADC_sig :  out  std_logic ;
            ADC_en  :   out std_logic :='0';
            TX      :   out std_logic :='0';
            RX      :   in std_logic :='0'
        );
end muonTrigPOC;

architecture Behavioral of muonTrigPOC is

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

component dataHandling is
  Port ( 
    CLK : IN STD_LOGIC :='0';
    RST : IN STD_LOGIC :='0';
    
    data : IN STD_LOGIC_VECTOR(15 downto 0 ) :=x"0000";
    data_vld : IN STD_LOGIC :='0';
    
    uart_data : out STD_LOGIC_VECTOR(7 downto 0 ) :=x"00";
    uart_data_send: out STD_LOGIC :='0'
  );
end component;

component UART is
    Generic (
        CLK_FREQ    : integer := 125e6;   -- set system clock frequency in Hz
        BAUD_RATE   : integer := 115200; -- baud rate value
        PARITY_BIT  : string  := "none"  -- legal values: "none", "even", "odd", "mark", "space"
    );
    Port (
        CLK         : in  std_logic; -- system clock
        RST         : in  std_logic; -- high active synchronous reset
        -- UART INTERFACE
        UART_TXD    : out std_logic;
        UART_RXD    : in  std_logic;
        -- USER DATA INPUT INTERFACE
        DATA_IN     : in  std_logic_vector(7 downto 0);
        DATA_SEND   : in  std_logic; -- when DATA_SEND = 1, data on DATA_IN will be transmit, DATA_SEND can set to 1 only when BUSY = 0
        BUSY        : out std_logic; -- when BUSY = 1 transiever is busy, you must not set DATA_SEND to 1
        -- USER DATA OUTPUT INTERFACE
        DATA_OUT    : out std_logic_vector(7 downto 0);
        DATA_VLD    : out std_logic; -- when DATA_VLD = 1, data on DATA_OUT are valid
        FRAME_ERROR : out std_logic  -- when FRAME_ERROR = 1, stop bit was invalid, current and next data may be invalid
    );
end component;

signal s_CLK : std_logic    :='0';
signal s_RST : std_logic    :='0';
signal s_trigADC : std_logic    :='0';
signal s_ADC_en: std_logic    :='0';
signal ADC_data_line:   std_logic_vector(15 downto 0) :=x"0000";
signal ADC_dataVld:   std_logic :='0';
signal uart_data_line:   std_logic_vector(7 downto 0) :=x"00";
signal uart_dataVld:   std_logic :='0';

signal s_UART_TXD    :  std_logic;
signal s_UART_RXD    :  std_logic;
signal s_DATA_IN     :  std_logic_vector(7 downto 0);
signal s_DATA_SEND   :  std_logic;
signal s_BUSY        :  std_logic;
signal s_DATA_OUT    :  std_logic_vector(7 downto 0);
signal s_DATA_VLD    :  std_logic;
signal s_FRAME_ERROR :  std_logic;

begin
ADC_sig<=D4_sig;
s_CLK<=CLK;
s_RST<=RST;
ADC_data_line<=ADC_data;
ADC_dataVld<=ADC_dataReady;
ADC_en<=s_ADC_en;
TX<=s_UART_TXD;
s_UART_RXD<=RX;

s_trigADC <= D1 and D2 and D3;

adc_trig : monoshot
    generic map (clkF=>125000,pulseWidth=>50,offset=>0)
    port map    (clk=>s_CLK,trig=>s_trigADC,pulseOut=>s_ADC_en);

dataMngMent :   dataHandling
    port map ( 
    CLK =>s_clk,
    RST => s_RST,
    data => ADC_data_line,
    data_vld =>ADC_dataVld,
    
    uart_data =>uart_data_line,
    uart_data_send=>uart_dataVld
  );
  
s_DATA_IN<=uart_data_line;
s_DATA_SEND<=uart_dataVld and not s_BUSY;

uartTrans :UART
	port map
	(
		CLK			=> s_CLK,
		RST			=> s_RST,
		UART_TXD	=> s_UART_TXD,
		UART_RXD	=> s_UART_RXD,
		DATA_IN		=> s_DATA_IN,
		DATA_SEND	=> s_DATA_SEND,
		BUSY		=> s_BUSY,
		DATA_VLD	=> s_DATA_VLD,
		FRAME_ERROR	=> s_FRAME_ERROR
	);

  
end Behavioral;
