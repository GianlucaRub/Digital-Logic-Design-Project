-- testbench di tommy + tutti gli altri
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity project_tb is
end project_tb;

architecture projecttb of project_tb is
constant c_CLOCK_PERIOD         : time := 15 ns;
signal   tb_done                : std_logic;
signal   mem_address            : std_logic_vector (15 downto 0) := (others => '0');
signal   tb_rst                 : std_logic := '0';
signal   tb_start               : std_logic := '0';
signal   tb_clk                 : std_logic := '0';
signal   mem_o_data,mem_i_data  : std_logic_vector (7 downto 0);
signal   enable_wire            : std_logic;
signal   mem_we                 : std_logic;

type ram_type is array (65535 downto 0) of std_logic_vector(7 downto 0);

signal i: std_logic_vector(4 downto 0) := "00000";

signal RAM0: ram_type := (0 => std_logic_vector(to_unsigned(  2  , 8)),
			 1 => std_logic_vector(to_unsigned(  2  , 8)),
			 2 => std_logic_vector(to_unsigned(  153, 8)),
			 3 => std_logic_vector(to_unsigned(  128, 8)),
			 4 => std_logic_vector(to_unsigned(  24 , 8)),
			 5 => std_logic_vector(to_unsigned(  86 , 8)),
                         others => (others =>'0'));
             -- delta=129 shift=1

signal RAM1: ram_type := (0 => std_logic_vector(to_unsigned(  4  , 8)),
			 1 => std_logic_vector(to_unsigned(  1  , 8)),
			 2 => std_logic_vector(to_unsigned(  4  , 8)),
			 3 => std_logic_vector(to_unsigned(  255, 8)),
			 4 => std_logic_vector(to_unsigned(  182, 8)),
			 5 => std_logic_vector(to_unsigned(  0  , 8)),
                         others => (others =>'0'));         
			 -- delta=255 shift=0    

signal RAM2: ram_type := (0 => std_logic_vector(to_unsigned(  1  , 8)),
			 1 => std_logic_vector(to_unsigned(  4  , 8)),
			 2 => std_logic_vector(to_unsigned(  255, 8)),
			 3 => std_logic_vector(to_unsigned(  255, 8)),
			 4 => std_logic_vector(to_unsigned(  255, 8)),
			 5 => std_logic_vector(to_unsigned(  255, 8)),
                         others => (others =>'0')); 
              -- delta=0 shift=8                

signal RAM3: ram_type := (0 => std_logic_vector(to_unsigned(  2  , 8)),
			 1 => std_logic_vector(to_unsigned(  2  , 8)),
			 2 => std_logic_vector(to_unsigned(  0  , 8)),
			 3 => std_logic_vector(to_unsigned(  0  , 8)),
			 4 => std_logic_vector(to_unsigned(  0  , 8)),
			 5 => std_logic_vector(to_unsigned(  0  , 8)),
                         others => (others =>'0'));
             -- delta=0 shift=8              

signal RAM4: ram_type := (0 => std_logic_vector(to_unsigned(  128  , 8)),
			 1      => std_logic_vector(to_unsigned(  128, 8)),
			 63     => std_logic_vector(to_unsigned(  25, 8)),
			 348    => std_logic_vector(to_unsigned(  34, 8)),
			 7222   => std_logic_vector(to_unsigned(  27, 8)),
			 15241  => std_logic_vector(to_unsigned(  95, 8)),
                         others => (others =>'0')); 
             -- delta=70 shift=2
             
signal RAM5: ram_type := (0 => std_logic_vector(to_unsigned(  2  , 8)),
			 1 => std_logic_vector(to_unsigned(  2  , 8)),
			 2 => std_logic_vector(to_unsigned(  37 , 8)),
			 3 => std_logic_vector(to_unsigned(  255, 8)),
			 4 => std_logic_vector(to_unsigned(  94 , 8)),
			 5 => std_logic_vector(to_unsigned(  0  , 8)),
                         others => (others =>'0'));
             -- delta=255 shift=0
             
signal RAM6: ram_type := (0 => std_logic_vector(to_unsigned(  0  , 8)),
			 1 => std_logic_vector(to_unsigned(  0  , 8)),
             2 => std_logic_vector(to_unsigned(  1  , 8)),
			 3 => std_logic_vector(to_unsigned(  2  , 8)),
			 4 => std_logic_vector(to_unsigned(  3  , 8)),
			 5 => std_logic_vector(to_unsigned(  4  , 8)),
                         others => (others =>'0')); 
             -- dim = 0 x 0
             
signal RAM7: ram_type := (0 => std_logic_vector(to_unsigned(  128  , 8)),
			 1 => std_logic_vector(to_unsigned(  0  , 8)),
             2 => std_logic_vector(to_unsigned(  1  , 8)),
			 3 => std_logic_vector(to_unsigned(  2  , 8)),
			 4 => std_logic_vector(to_unsigned(  3  , 8)),
			 5 => std_logic_vector(to_unsigned(  4  , 8)),
                         others => (others =>'0'));
             -- dim = N x 0 

signal RAM8: ram_type := (0 => std_logic_vector(to_unsigned(  0  , 8)),
			 1 => std_logic_vector(to_unsigned(  128  , 8)),
             2 => std_logic_vector(to_unsigned(  1  , 8)),
			 3 => std_logic_vector(to_unsigned(  2  , 8)),
			 4 => std_logic_vector(to_unsigned(  3  , 8)),
			 5 => std_logic_vector(to_unsigned(  4  , 8)),
                         others => (others =>'0'));
             -- dim = 0 x N
             
             
             
-----tb nostri    
--2x3 base 
signal RAM9: ram_type := (0 => std_logic_vector(to_unsigned(  2  , 8)), 
                         1 => std_logic_vector(to_unsigned(  3  , 8)), 
                         2 => std_logic_vector(to_unsigned(  32  , 8)),  
                         3 => std_logic_vector(to_unsigned(  64  , 8)), 
                         4 => std_logic_vector(to_unsigned(  63  , 8)), 
                         5 => std_logic_vector(to_unsigned(  64  , 8)), 
                         6 => std_logic_vector(to_unsigned(  13  , 8)), 
                         7 => std_logic_vector(to_unsigned(  22  , 8)), 
                         others => (others =>'0')); 
--0xn
signal RAM10: ram_type := (0 => std_logic_vector(to_unsigned(  0  , 8)), 
                         1 => std_logic_vector(to_unsigned(  12  , 8)), 
                         others => (others =>'0'));       
--esempio 1 del prof
signal RAM11: ram_type := (0 => std_logic_vector(to_unsigned(  4  , 8)), 
                         1 => std_logic_vector(to_unsigned(  3  , 8)), 
                         2 => std_logic_vector(to_unsigned(  76  , 8)),
                         3 => std_logic_vector(to_unsigned(  131  , 8)),  
                         4 => std_logic_vector(to_unsigned(  109  , 8)),  
                         5 => std_logic_vector(to_unsigned(  89  , 8)),  
                         6 => std_logic_vector(to_unsigned(  46  , 8)),  
                         7 => std_logic_vector(to_unsigned(  121  , 8)),  
                         8 => std_logic_vector(to_unsigned(  62  , 8)),  
                         9 => std_logic_vector(to_unsigned(  59  , 8)),  
                         10 => std_logic_vector(to_unsigned(  46  , 8)),  
                         11 => std_logic_vector(to_unsigned(  77  , 8)),  
                         12 => std_logic_vector(to_unsigned(  68  , 8)),  
                         13 => std_logic_vector(to_unsigned(  94  , 8)),    
                         others => (others =>'0'));  
--esempio 2 del prof
signal RAM12: ram_type := (0 => std_logic_vector(to_unsigned(  4  , 8)), 
                         1 => std_logic_vector(to_unsigned(  3  , 8)), 
                         2 => std_logic_vector(to_unsigned(  0  , 8)),
                         3 => std_logic_vector(to_unsigned(  10  , 8)),  
                         4 => std_logic_vector(to_unsigned(  20  , 8)),  
                         5 => std_logic_vector(to_unsigned(  30  , 8)),  
                         6 => std_logic_vector(to_unsigned(  40  , 8)),  
                         7 => std_logic_vector(to_unsigned(  50  , 8)),  
                         8 => std_logic_vector(to_unsigned(  60  , 8)),  
                         9 => std_logic_vector(to_unsigned(  70  , 8)),  
                         10 => std_logic_vector(to_unsigned(  80  , 8)),  
                         11 => std_logic_vector(to_unsigned(  90  , 8)),  
                         12 => std_logic_vector(to_unsigned(  100  , 8)),  
                         13 => std_logic_vector(to_unsigned(  120  , 8)),    
                         others => (others =>'0'));     
--esempio 3 del prof
signal RAM13: ram_type := (0 => std_logic_vector(to_unsigned(  4  , 8)), 
                         1 => std_logic_vector(to_unsigned(  3  , 8)), 
                         2 => std_logic_vector(to_unsigned(  122  , 8)),
                         3 => std_logic_vector(to_unsigned(  123  , 8)),  
                         4 => std_logic_vector(to_unsigned(  124  , 8)),  
                         5 => std_logic_vector(to_unsigned(  125  , 8)),  
                         6 => std_logic_vector(to_unsigned(  126  , 8)),  
                         7 => std_logic_vector(to_unsigned(  127  , 8)),  
                         8 => std_logic_vector(to_unsigned(  128  , 8)),  
                         9 => std_logic_vector(to_unsigned(  129  , 8)),  
                         10 => std_logic_vector(to_unsigned(  130  , 8)),  
                         11 => std_logic_vector(to_unsigned(  131  , 8)),  
                         12 => std_logic_vector(to_unsigned(  132  , 8)),  
                         13 => std_logic_vector(to_unsigned(  133  , 8)),    
                         others => (others =>'0'));    
--esempio 4 del prof
signal RAM14: ram_type := (0 => std_logic_vector(to_unsigned(  4  , 8)), 
                         1 => std_logic_vector(to_unsigned(  3  , 8)), 
                         2 => std_logic_vector(to_unsigned(  0  , 8)),
                         3 => std_logic_vector(to_unsigned(  0  , 8)),  
                         4 => std_logic_vector(to_unsigned(  0  , 8)),  
                         5 => std_logic_vector(to_unsigned(  0  , 8)),  
                         6 => std_logic_vector(to_unsigned(  128  , 8)),  
                         7 => std_logic_vector(to_unsigned(  128  , 8)),  
                         8 => std_logic_vector(to_unsigned(  128  , 8)),  
                         9 => std_logic_vector(to_unsigned(  128  , 8)),  
                         10 => std_logic_vector(to_unsigned(  255  , 8)),  
                         11 => std_logic_vector(to_unsigned(  255  , 8)),  
                         12 => std_logic_vector(to_unsigned(  255 , 8)),  
                         13 => std_logic_vector(to_unsigned(  255  , 8)),    
                         others => (others =>'0')); 
--testiamo valori tutti uguali
signal RAM15: ram_type := (0 => std_logic_vector(to_unsigned(  3  , 8)), 
                         1 => std_logic_vector(to_unsigned(  4  , 8)), 
                         2 => std_logic_vector(to_unsigned(  99  , 8)),
                         3 => std_logic_vector(to_unsigned(  99  , 8)),  
                         4 => std_logic_vector(to_unsigned(  99  , 8)),  
                         5 => std_logic_vector(to_unsigned(  99  , 8)),  
                         6 => std_logic_vector(to_unsigned(  99  , 8)),  
                         7 => std_logic_vector(to_unsigned(  99  , 8)),  
                         8 => std_logic_vector(to_unsigned(  99  , 8)),  
                         9 => std_logic_vector(to_unsigned(  99  , 8)),  
                         10 => std_logic_vector(to_unsigned(  99  , 8)),  
                         11 => std_logic_vector(to_unsigned(  99  , 8)),  
                         12 => std_logic_vector(to_unsigned(  99 , 8)),  
                         13 => std_logic_vector(to_unsigned(  99  , 8)),    
                         others => (others =>'0'));  
--tutti 0
signal RAM16: ram_type := (0 => std_logic_vector(to_unsigned(  3  , 8)), 
                         1 => std_logic_vector(to_unsigned(  3  , 8)), 
                         2 => std_logic_vector(to_unsigned(  0  , 8)),
                         3 => std_logic_vector(to_unsigned(  0  , 8)),  
                         4 => std_logic_vector(to_unsigned(  0  , 8)),  
                         5 => std_logic_vector(to_unsigned(  0  , 8)),  
                         6 => std_logic_vector(to_unsigned(  0  , 8)),  
                         7 => std_logic_vector(to_unsigned(   0 , 8)),  
                         8 => std_logic_vector(to_unsigned(  0  , 8)),  
                         9 => std_logic_vector(to_unsigned(  0  , 8)),  
                         10 => std_logic_vector(to_unsigned(  0  , 8)),  
                            
                         others => (others =>'0'));  
 --tutti 255
 signal RAM17: ram_type := (0 => std_logic_vector(to_unsigned(  3  , 8)), 
                         1 => std_logic_vector(to_unsigned(  3  , 8)), 
                         2 => std_logic_vector(to_unsigned(  255  , 8)),
                         3 => std_logic_vector(to_unsigned(  255, 8)),  
                         4 => std_logic_vector(to_unsigned(  255, 8)),  
                         5 => std_logic_vector(to_unsigned(  255, 8)),  
                         6 => std_logic_vector(to_unsigned(  255  , 8)),  
                         7 => std_logic_vector(to_unsigned(   255 , 8)),  
                         8 => std_logic_vector(to_unsigned(  255  , 8)),  
                         9 => std_logic_vector(to_unsigned(  255  , 8)),  
                         10 => std_logic_vector(to_unsigned(  255  , 8)),  
                            
                         others => (others =>'0'));   
--1x1
signal RAM18: ram_type := (0 => std_logic_vector(to_unsigned(  1  , 8)), 
                         1 => std_logic_vector(to_unsigned(  1  , 8)), 
                         2 => std_logic_vector(to_unsigned(  69  , 8)),
                         others => (others =>'0'));                           
--1x2
signal RAM19: ram_type := (0 => std_logic_vector(to_unsigned(  1  , 8)), 
                         1 => std_logic_vector(to_unsigned(  2  , 8)), 
                         2 => std_logic_vector(to_unsigned(  69  , 8)),
                         3 => std_logic_vector(to_unsigned(  42  , 8)),
                            
                         others => (others =>'0'));    
--3x1
signal RAM20: ram_type := (0 => std_logic_vector(to_unsigned(  3  , 8)), 
                         1 => std_logic_vector(to_unsigned(  1  , 8)), 
                         2 => std_logic_vector(to_unsigned(  69  , 8)),
                         3 => std_logic_vector(to_unsigned(  42  , 8)),
                         4 => std_logic_vector(to_unsigned(  8  , 8)),

                            
                         others => (others =>'0'));  
--1x1 scrittura effettiva
signal RAM21: ram_type := (0 => std_logic_vector(to_unsigned(  1  , 8)), 
                         1 => std_logic_vector(to_unsigned(  1  , 8)), 
                         2 => std_logic_vector(to_unsigned(  69  , 8)),
                        
                            
                         others => (others =>'1'));                              
                                                                                                                                                                                                                                                                                               
component project_reti_logiche is
port (
      i_clk         : in  std_logic;
      i_start       : in  std_logic;
      i_rst         : in  std_logic;
      i_data        : in  std_logic_vector(7 downto 0);
      o_address     : out std_logic_vector(15 downto 0);
      o_done        : out std_logic;
      o_en          : out std_logic;
      o_we          : out std_logic;
      o_data        : out std_logic_vector (7 downto 0)
      );
end component project_reti_logiche;


begin
UUT: project_reti_logiche
port map (
          i_clk      	=> tb_clk,
          i_start       => tb_start,
          i_rst      	=> tb_rst,
          i_data    	=> mem_o_data,
          o_address  	=> mem_address,
          o_done      	=> tb_done,
          o_en   	=> enable_wire,
          o_we 		=> mem_we,
          o_data    	=> mem_i_data
          );

p_CLK_GEN : process is
begin
    wait for c_CLOCK_PERIOD/2;
    tb_clk <= not tb_clk;
end process p_CLK_GEN;


MEM : process(tb_clk)
begin
if tb_clk'event and tb_clk = '1' then
    if enable_wire = '1' then
        if i = "00000" then
            if mem_we = '1' then
                RAM0(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM0(conv_integer(mem_address)) after 1 ns;
            end if;
        elsif i ="00001" then
            if mem_we = '1' then
                RAM1(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM1(conv_integer(mem_address)) after 1 ns;
            end if;
        elsif i = "00010" then 
            if mem_we = '1' then
                RAM2(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM2(conv_integer(mem_address)) after 1 ns;
            end if;
        elsif i = "00011" then 
            if mem_we = '1' then
                RAM3(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM3(conv_integer(mem_address)) after 1 ns;
            end if;
        elsif i = "00100" then 
            if mem_we = '1' then
                RAM4(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM4(conv_integer(mem_address)) after 1 ns;
            end if;
        elsif i = "00101" then 
            if mem_we = '1' then
                RAM5(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM5(conv_integer(mem_address)) after 1 ns;
            end if;
        elsif i = "00110" then 
            if mem_we = '1' then
                RAM6(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM6(conv_integer(mem_address)) after 1 ns;
            end if;
        elsif i = "00111" then 
            if mem_we = '1' then
                RAM7(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM7(conv_integer(mem_address)) after 1 ns;
            end if;
        elsif i = "01000" then 
            if mem_we = '1' then
                RAM8(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM8(conv_integer(mem_address)) after 1 ns;
            end if;
            
            
            ------tb nostri
        elsif i = "01001" then 
            if mem_we = '1' then
                RAM9(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM9(conv_integer(mem_address)) after 1 ns;
            end if;    
         elsif i = "01010" then 
            if mem_we = '1' then
                RAM10(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM10(conv_integer(mem_address)) after 1 ns;
            end if;  
         elsif i = "01011" then 
            if mem_we = '1' then
                RAM11(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM11(conv_integer(mem_address)) after 1 ns;
            end if;  
          elsif i = "01100" then 
            if mem_we = '1' then
                RAM12(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM12(conv_integer(mem_address)) after 1 ns;
            end if; 
           elsif i = "01101" then 
            if mem_we = '1' then
                RAM13(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM13(conv_integer(mem_address)) after 1 ns;
            end if; 
            elsif i = "01110" then 
            if mem_we = '1' then
                RAM14(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM14(conv_integer(mem_address)) after 1 ns;
            end if; 
            elsif i = "01111" then 
            if mem_we = '1' then
                RAM15(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM15(conv_integer(mem_address)) after 1 ns;
            end if; 
            elsif i = "10000" then 
            if mem_we = '1' then
                RAM16(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM16(conv_integer(mem_address)) after 1 ns;
            end if; 
            
            elsif i = "10001" then 
            if mem_we = '1' then
                RAM17(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM17(conv_integer(mem_address)) after 1 ns;
            end if; 
            
            elsif i = "10010" then 
            if mem_we = '1' then
                RAM18(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM18(conv_integer(mem_address)) after 1 ns;
            end if; 
            elsif i = "10011" then 
            if mem_we = '1' then
                RAM19(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM19(conv_integer(mem_address)) after 1 ns;
            end if; 
            elsif i = "10100" then 
            if mem_we = '1' then
                RAM20(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM20(conv_integer(mem_address)) after 1 ns;
            end if;
            elsif i = "10101" then 
            if mem_we = '1' then
                RAM21(conv_integer(mem_address))  <= mem_i_data;
                mem_o_data                      <= mem_i_data after 1 ns;
            else
                mem_o_data <= RAM21(conv_integer(mem_address)) after 1 ns;
            end if;
                  
        end if;
    end if;
end if;
end process;


test : process is
begin 
    wait for 100 ns;
    wait for c_CLOCK_PERIOD;
    tb_rst <= '1';
    wait for c_CLOCK_PERIOD;
    wait for 100 ns;
    tb_rst <= '0';
    wait for c_CLOCK_PERIOD;
    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    i <= "00001";

    
    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    i <= "00010";

    
    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    i <= "00011";
    
    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    i <= "00100";
    
    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    i <= "00101";
    
    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    i <= "00110";
    
    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    i <= "00111";
    
    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    i <= "01000";


    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    
    
    --tb nostri
    i <= "01001";


    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    tb_rst <= '1';
    wait for c_CLOCK_PERIOD;
    wait for 100 ns;
    tb_rst <= '0';    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    
    i <= "01010";


    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    
    i <= "01011";


    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    
    i <= "01100";


    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    tb_rst <= '1';
    wait for c_CLOCK_PERIOD;
    wait for 100 ns;
    tb_rst <= '0';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    
    --reset sopra
    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    
    
    
    i <= "01101";


    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    
    i <= "01110";


    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    
        i <= "01111";


    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    
        i <= "10000";


    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    
        i <= "10001";


    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    tb_rst <= '1';
    wait for c_CLOCK_PERIOD;
    wait for 100 ns;
    tb_rst <= '0';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    
    --segnale di reset sopra
     wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    
        i <= "10010";


    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    
        i <= "10011";


    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    
        i <= "10100";


    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    
        i <= "10101";


    wait for 100 ns;
    tb_start <= '1';
    wait for c_CLOCK_PERIOD;
    wait until tb_done = '1';
    wait for c_CLOCK_PERIOD;
    tb_start <= '0';
    wait until tb_done = '0';
    wait for 100 ns;
    -- delta=129 shift=1
	assert RAM0(6) = std_logic_vector(to_unsigned( 255 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM0(6))))  severity failure; 
	assert RAM0(7) = std_logic_vector(to_unsigned( 208 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  208  found " & integer'image(to_integer(unsigned(RAM0(7))))  severity failure; 
	assert RAM0(8) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM0(8))))  severity failure; 
	assert RAM0(9) = std_logic_vector(to_unsigned( 124 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  124  found " & integer'image(to_integer(unsigned(RAM0(9))))  severity failure;

    -- delta=255 shift=0
	assert RAM1(6) = std_logic_vector(to_unsigned( 4 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  4  found " & integer'image(to_integer(unsigned(RAM1(6))))  severity failure; 
	assert RAM1(7) = std_logic_vector(to_unsigned( 255 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM1(7))))  severity failure; 
	assert RAM1(8) = std_logic_vector(to_unsigned( 182 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  182  found " & integer'image(to_integer(unsigned(RAM1(8))))  severity failure; 
	assert RAM1(9) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM1(9))))  severity failure;
	
	-- delta=0 shift=8
	assert RAM2(6) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM2(6))))  severity failure; 
	assert RAM2(7) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM2(7))))  severity failure; 
	assert RAM2(8) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM2(8))))  severity failure; 
	assert RAM2(9) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM2(9))))  severity failure;

    -- delta=0 shift=8
    assert RAM3(6) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM3(6))))  severity failure; 
	assert RAM3(7) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM3(7))))  severity failure; 
	assert RAM3(8) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM3(8))))  severity failure; 
	assert RAM3(9) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM3(9))))  severity failure;

    -- delta=70 shift=2
    assert RAM4(16447) = std_logic_vector(to_unsigned( 100 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  100  found " & integer'image(to_integer(unsigned(RAM4(16447))))  severity failure; 
	assert RAM4(16732) = std_logic_vector(to_unsigned( 136 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  136  found " & integer'image(to_integer(unsigned(RAM4(16732))))  severity failure; 
	assert RAM4(23606) = std_logic_vector(to_unsigned( 108 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  108  found " & integer'image(to_integer(unsigned(RAM4(23606))))  severity failure; 
	assert RAM4(31625) = std_logic_vector(to_unsigned( 255 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM4(31625))))  severity failure;
	
	-- delta=255 shift=0
    assert RAM5(6) = std_logic_vector(to_unsigned( 37 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  37  found " & integer'image(to_integer(unsigned(RAM5(6))))  severity failure; 
	assert RAM5(7) = std_logic_vector(to_unsigned( 255 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM5(7))))  severity failure; 
	assert RAM5(8) = std_logic_vector(to_unsigned( 94 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  94  found " & integer'image(to_integer(unsigned(RAM5(8))))  severity failure; 
	assert RAM5(9) = std_logic_vector(to_unsigned( 0 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM5(9))))  severity failure;
	
	-- dim = 0 x 0
    assert RAM6(2) = std_logic_vector(to_unsigned( 1 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  1  found " & integer'image(to_integer(unsigned(RAM6(6))))  severity failure; 
	assert RAM6(3) = std_logic_vector(to_unsigned( 2 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  2  found " & integer'image(to_integer(unsigned(RAM6(7))))  severity failure; 
	assert RAM6(4) = std_logic_vector(to_unsigned( 3 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  3  found " & integer'image(to_integer(unsigned(RAM6(8))))  severity failure; 
	assert RAM6(5) = std_logic_vector(to_unsigned( 4 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  4  found " & integer'image(to_integer(unsigned(RAM6(9))))  severity failure;
	
	-- dim = N x 0
    assert RAM7(2) = std_logic_vector(to_unsigned( 1 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  1  found " & integer'image(to_integer(unsigned(RAM7(6))))  severity failure; 
	assert RAM7(3) = std_logic_vector(to_unsigned( 2 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  2  found " & integer'image(to_integer(unsigned(RAM7(7))))  severity failure; 
	assert RAM7(4) = std_logic_vector(to_unsigned( 3 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  3  found " & integer'image(to_integer(unsigned(RAM7(8))))  severity failure; 
	assert RAM7(5) = std_logic_vector(to_unsigned( 4 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  4  found " & integer'image(to_integer(unsigned(RAM7(9))))  severity failure;
	
	-- dim = 0 x N
    assert RAM8(2) = std_logic_vector(to_unsigned( 1 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  1  found " & integer'image(to_integer(unsigned(RAM8(6))))  severity failure; 
	assert RAM8(3) = std_logic_vector(to_unsigned( 2 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  2  found " & integer'image(to_integer(unsigned(RAM8(7))))  severity failure; 
	assert RAM8(4) = std_logic_vector(to_unsigned( 3 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  3  found " & integer'image(to_integer(unsigned(RAM8(8))))  severity failure; 
	assert RAM8(5) = std_logic_vector(to_unsigned( 4 , 8)) report " TEST FALLITO (WORKING ZONE). Expected  4  found " & integer'image(to_integer(unsigned(RAM8(9))))  severity failure;
	
	
	--tb nostri
	
	--2x3 base
    assert RAM9(8) = std_logic_vector(to_unsigned( 152 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  152  found " & integer'image(to_integer(unsigned(RAM9(6))))  severity failure;
    assert RAM9(9) = std_logic_vector(to_unsigned( 255 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM9(7))))  severity failure;
    assert RAM9(10) = std_logic_vector(to_unsigned( 255 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM9(8))))  severity failure;
    assert RAM9(11) = std_logic_vector(to_unsigned( 255 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM9(9))))  severity failure;
    assert RAM9(12) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected   0  found " & integer'image(to_integer(unsigned(RAM9(8))))  severity failure;
    assert RAM9(13) = std_logic_vector(to_unsigned( 72 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  72  found " & integer'image(to_integer(unsigned(RAM9(9))))  severity failure;
	
	
	--0xn
    assert RAM10(2) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM10(6))))  severity failure;
    
    --esemprio 1 del prof
    assert RAM11(14) = std_logic_vector(to_unsigned( 120 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  120  found " & integer'image(to_integer(unsigned(RAM11(14))))  severity failure;
    assert RAM11(15) = std_logic_vector(to_unsigned( 255 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM11(15))))  severity failure;
    assert RAM11(16) = std_logic_vector(to_unsigned( 252 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  252  found " & integer'image(to_integer(unsigned(RAM11(16))))  severity failure;
    assert RAM11(17) = std_logic_vector(to_unsigned( 172 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  172  found " & integer'image(to_integer(unsigned(RAM11(17))))  severity failure;
    assert RAM11(18) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM11(18))))  severity failure;
    assert RAM11(19) = std_logic_vector(to_unsigned( 255 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM11(19))))  severity failure;
    assert RAM11(20) = std_logic_vector(to_unsigned( 64 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  64  found " & integer'image(to_integer(unsigned(RAM11(20))))  severity failure;
    assert RAM11(21) = std_logic_vector(to_unsigned( 52 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  52  found " & integer'image(to_integer(unsigned(RAM11(21))))  severity failure;
    assert RAM11(22) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM11(22))))  severity failure;
    assert RAM11(23) = std_logic_vector(to_unsigned( 124 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  124  found " & integer'image(to_integer(unsigned(RAM11(23))))  severity failure;
    assert RAM11(24) = std_logic_vector(to_unsigned( 88 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  88  found " & integer'image(to_integer(unsigned(RAM11(24))))  severity failure;
    assert RAM11(25) = std_logic_vector(to_unsigned( 192 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  192  found " & integer'image(to_integer(unsigned(RAM11(25))))  severity failure;
   
    --esempio 2 del prof
    assert RAM12(14) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  120  found " & integer'image(to_integer(unsigned(RAM12(14))))  severity failure;
    assert RAM12(15) = std_logic_vector(to_unsigned( 40 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM12(15))))  severity failure;
    assert RAM12(16) = std_logic_vector(to_unsigned( 80 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  252  found " & integer'image(to_integer(unsigned(RAM12(16))))  severity failure;
    assert RAM12(17) = std_logic_vector(to_unsigned( 120 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  172  found " & integer'image(to_integer(unsigned(RAM12(17))))  severity failure;
    assert RAM12(18) = std_logic_vector(to_unsigned( 160 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM12(18))))  severity failure;
    assert RAM12(19) = std_logic_vector(to_unsigned( 200 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM12(19))))  severity failure;
    assert RAM12(20) = std_logic_vector(to_unsigned( 240 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  64  found " & integer'image(to_integer(unsigned(RAM12(20))))  severity failure;
    assert RAM12(21) = std_logic_vector(to_unsigned( 255 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  52  found " & integer'image(to_integer(unsigned(RAM12(21))))  severity failure;
    assert RAM12(22) = std_logic_vector(to_unsigned( 255 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM12(22))))  severity failure;
    assert RAM12(23) = std_logic_vector(to_unsigned( 255 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  124  found " & integer'image(to_integer(unsigned(RAM12(23))))  severity failure;
    assert RAM12(24) = std_logic_vector(to_unsigned( 255 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  88  found " & integer'image(to_integer(unsigned(RAM12(24))))  severity failure;
    assert RAM12(25) = std_logic_vector(to_unsigned( 255 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  192  found " & integer'image(to_integer(unsigned(RAM12(25))))  severity failure;
   
    --esempio 3 del prof
    assert RAM13(14) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM13(14))))  severity failure;
    assert RAM13(15) = std_logic_vector(to_unsigned( 32 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM13(15))))  severity failure;
    assert RAM13(16) = std_logic_vector(to_unsigned( 64 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  252  found " & integer'image(to_integer(unsigned(RAM13(16))))  severity failure;
    assert RAM13(17) = std_logic_vector(to_unsigned( 96 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  172  found " & integer'image(to_integer(unsigned(RAM13(17))))  severity failure;
    assert RAM13(18) = std_logic_vector(to_unsigned( 128 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM13(18))))  severity failure;
    assert RAM13(19) = std_logic_vector(to_unsigned( 160 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM13(19))))  severity failure;
    assert RAM13(20) = std_logic_vector(to_unsigned( 192 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  64  found " & integer'image(to_integer(unsigned(RAM13(20))))  severity failure;
    assert RAM13(21) = std_logic_vector(to_unsigned( 224 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  52  found " & integer'image(to_integer(unsigned(RAM13(21))))  severity failure;
    assert RAM13(22) = std_logic_vector(to_unsigned( 255, 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM13(22))))  severity failure;
    assert RAM13(23) = std_logic_vector(to_unsigned( 255 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  124  found " & integer'image(to_integer(unsigned(RAM13(23))))  severity failure;
    assert RAM13(24) = std_logic_vector(to_unsigned( 255 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  88  found " & integer'image(to_integer(unsigned(RAM13(24))))  severity failure;
    assert RAM13(25) = std_logic_vector(to_unsigned( 255 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  192  found " & integer'image(to_integer(unsigned(RAM13(25))))  severity failure;
   
    --esempio 4 del prof
    assert RAM14(14) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM14(14))))  severity failure;
    assert RAM14(15) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM14(15))))  severity failure;
    assert RAM14(16) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM14(16))))  severity failure;
    assert RAM14(17) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM14(17))))  severity failure;
    assert RAM14(18) = std_logic_vector(to_unsigned( 128 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  128  found " & integer'image(to_integer(unsigned(RAM14(18))))  severity failure;
    assert RAM14(19) = std_logic_vector(to_unsigned( 128 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  128  found " & integer'image(to_integer(unsigned(RAM14(19))))  severity failure;
    assert RAM14(20) = std_logic_vector(to_unsigned( 128 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  128  found " & integer'image(to_integer(unsigned(RAM14(20))))  severity failure;
    assert RAM14(21) = std_logic_vector(to_unsigned( 128 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  128  found " & integer'image(to_integer(unsigned(RAM14(21))))  severity failure;
    assert RAM14(22) = std_logic_vector(to_unsigned( 255 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM14(22))))  severity failure;
    assert RAM14(23) = std_logic_vector(to_unsigned( 255 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM14(23))))  severity failure;
    assert RAM14(24) = std_logic_vector(to_unsigned( 255 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM14(24))))  severity failure;
    assert RAM14(25) = std_logic_vector(to_unsigned( 255 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM14(25))))  severity failure;
   
    --valori tutti uguali
    assert RAM15(14) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM15(14))))  severity failure;
    assert RAM15(15) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM15(15))))  severity failure;
    assert RAM15(16) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM15(16))))  severity failure;
    assert RAM15(17) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM15(17))))  severity failure;
    assert RAM15(18) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  128  found " & integer'image(to_integer(unsigned(RAM15(18))))  severity failure;
    assert RAM15(19) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  128  found " & integer'image(to_integer(unsigned(RAM15(19))))  severity failure;
    assert RAM15(20) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  128  found " & integer'image(to_integer(unsigned(RAM15(20))))  severity failure;
    assert RAM15(21) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  128  found " & integer'image(to_integer(unsigned(RAM15(21))))  severity failure;
    assert RAM15(22) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM15(22))))  severity failure;
    assert RAM15(23) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM15(23))))  severity failure;
    assert RAM15(24) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM15(24))))  severity failure;
    assert RAM15(25) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM15(25))))  severity failure;

    --tutti 0
    assert RAM16(11) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM16(14))))  severity failure;
    assert RAM16(12) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM16(15))))  severity failure;
    assert RAM16(13) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM16(16))))  severity failure;
    assert RAM16(14) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM16(17))))  severity failure;
    assert RAM16(15) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  128  found " & integer'image(to_integer(unsigned(RAM16(18))))  severity failure;
    assert RAM16(16) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  128  found " & integer'image(to_integer(unsigned(RAM16(19))))  severity failure;
    assert RAM16(17) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  128  found " & integer'image(to_integer(unsigned(RAM16(20))))  severity failure;
    assert RAM16(18) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  128  found " & integer'image(to_integer(unsigned(RAM16(21))))  severity failure;
    assert RAM16(19) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM16(22))))  severity failure;
    
    --tutti 255
    assert RAM17(11) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM17(14))))  severity failure;
    assert RAM17(12) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM17(15))))  severity failure;
    assert RAM17(13) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM17(16))))  severity failure;
    assert RAM17(14) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM17(17))))  severity failure;
    assert RAM17(15) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  128  found " & integer'image(to_integer(unsigned(RAM17(18))))  severity failure;
    assert RAM17(16) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  128  found " & integer'image(to_integer(unsigned(RAM17(19))))  severity failure;
    assert RAM17(17) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  128  found " & integer'image(to_integer(unsigned(RAM17(20))))  severity failure;
    assert RAM17(18) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  128  found " & integer'image(to_integer(unsigned(RAM17(21))))  severity failure;
    assert RAM17(19) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  255  found " & integer'image(to_integer(unsigned(RAM17(22))))  severity failure;
    
    --1x1
  
    assert RAM18(3) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM18(3))))  severity failure;

    --1x2
    assert RAM19(4) = std_logic_vector(to_unsigned( 255 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM19(3))))  severity failure;
    assert RAM19(5) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM19(3))))  severity failure;

    --3x1
    assert RAM20(5) = std_logic_vector(to_unsigned( 255 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM20(3))))  severity failure;
    assert RAM20(6) = std_logic_vector(to_unsigned( 255 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM20(3))))  severity failure;
    assert RAM20(7) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM20(3))))  severity failure;

    --1x1 scrittura effettiva
    assert RAM21(3) = std_logic_vector(to_unsigned( 0 , 8)) report "TEST FALLITO (WORKING ZONE). Expected  0  found " & integer'image(to_integer(unsigned(RAM21(3))))  severity failure;
    
    assert false report "Simulation Ended! TEST PASSATO" severity failure;

end process test;

end projecttb; 


