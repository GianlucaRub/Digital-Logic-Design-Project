----------------------------------------------------------------------------------
-- Company: Politecnico di Milano
-- Engineers: Flavio Rizzoglio, Gianluca Ruberto
-- 
-- Create Date: 26.02.2021 4:20:69
-- Module Name: project_reti_logiche - Behavioral
-- Project Name: project_reti_logiche
-- Target Devices: FPGA xc7a200tfbg484-1
-- Tool Versions: 2020.2
-- Description: Prova Finale di Reti Logiche
-- 
-- Dependencies: none
-- 
-- Revision:
-- Revision 2.3 - Ultimate
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all; 

entity project_reti_logiche is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_start : in std_logic;
        i_data : in std_logic_vector(7 downto 0);
        o_address : out std_logic_vector(15 downto 0);
        o_done : out std_logic;
        o_en : out std_logic;
        o_we : out std_logic;
        o_data : out std_logic_vector (7 downto 0)
    );
    
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is

--segnali generali datapath

signal r1_load : std_logic;
signal r2_load : std_logic;
signal r3_load : std_logic;
signal r4_load : std_logic;
signal r4_sel : std_logic;
signal o_end : std_logic;
signal r5_load : std_logic;
signal o_max_res : std_logic;
signal rmax_load : std_logic;
signal o_min_res : std_logic;
signal rmin_load : std_logic;
signal rdelta_load : std_logic;
signal rshiftlvl_load : std_logic;
signal roldval_load : std_logic;
signal rtemp_pix_load : std_logic;
signal o_overflow : std_logic;
signal o_data_sel : std_logic;

--segnali interni (valore del registro)

signal o_reg1 : std_logic_vector(7 downto 0);
signal o_reg2 : std_logic_vector(7 downto 0);
signal o_reg3 : std_logic_vector(15 downto 0);
signal o_reg4 : std_logic_vector(15 downto 0);
signal o_reg5 : std_logic_vector(7 downto 0);
signal o_reg_max : std_logic_vector(7 downto 0);
signal o_reg_min : std_logic_vector(7 downto 0);
signal o_reg_delta : std_logic_vector(7 downto 0);
signal o_reg_shift_lvl : std_logic_vector(8 downto 0);
signal o_reg_old_val : std_logic_vector(7 downto 0);
signal o_reg_temp_pixel : std_logic_vector(16 downto 0);

signal mux_reg4 : std_logic_vector(15 downto 0);
signal decoder : std_logic_vector(8 downto 0);
signal mux_out : std_logic_vector(7 downto 0);

--stati

type S is (START,LOAD_COL,LOAD_ROW,MULT,LOAD_COUNTER,LOAD_FIRST_PIXEL,READ_PIXEL_1,READ_CONTROL,NEW_MAX,NEW_MIN,SET_DELTA_VALUE_and_COUNTER,LOAD_COL0,READ_PIXEL_2,WRITE_CONTROL,WRITE_255,WRITE_EQUALIZED_PIXEL,SET_NEW_WRITE_ADDRESS,FINISH);
signal cur_state, next_state : S;

begin
    --processo che aggiorna lo stato
    state_reg: process(i_clk, i_rst)
        begin
        if i_rst='1' then
            cur_state <= START;
        elsif rising_edge(i_clk) then
            cur_state <= next_state;
        end if;
    end process;
    
    --processo che determina lo stato successivo
    state_selector: process(cur_state, i_start, o_end, o_max_res, o_min_res, o_overflow, o_reg3)
        begin
            next_state <= cur_state;
            case cur_state is
                when START =>
                    if i_start = '1' then
                        next_state <= LOAD_COL;
                    end if;
                when LOAD_COL =>
                    next_state <= LOAD_ROW;
                when LOAD_ROW =>
                    next_state <= MULT;
                when MULT =>           
                    next_state <= LOAD_COUNTER;   
                when LOAD_COUNTER => 
                    if o_reg3 = "0000000000000000" then
                        next_state <= FINISH;
                    else          
                        next_state <= LOAD_FIRST_PIXEL;
                    end if;
                when LOAD_FIRST_PIXEL =>
                    if o_reg3 = "0000000000000001" then
                        next_state <= SET_DELTA_VALUE_and_COUNTER;
                    else           
                        next_state <= READ_PIXEL_1;
                    end if;
                when READ_PIXEL_1 =>           
                    next_state <= READ_CONTROL;
                when READ_CONTROL =>           
                    if o_max_res = '1' then 
                        next_state <= NEW_MAX;
                    elsif o_min_res = '1' then 
                        next_state <= NEW_MIN;
                    elsif o_end = '0' and o_max_res = '0' and o_min_res = '0' then
                        next_state <= READ_PIXEL_1;
                    else
                        next_state <= SET_DELTA_VALUE_and_COUNTER;
                    end if;                 
                when NEW_MAX =>
                    if o_end = '1' then
                        next_state <= SET_DELTA_VALUE_and_COUNTER;
                    else
                        next_state <= READ_PIXEL_1;
                    end if;
                
                when NEW_MIN =>
                    if o_end = '1' then
                        next_state <= SET_DELTA_VALUE_and_COUNTER;
                    else
                        next_state <= READ_PIXEL_1;
                    end if;   
                when SET_DELTA_VALUE_and_COUNTER =>
                    next_state <= LOAD_COL0;
                when LOAD_COL0 =>
                    next_state <= READ_PIXEL_2;
                when READ_PIXEL_2 =>
                    next_state <= WRITE_CONTROL;
                when WRITE_CONTROL =>
                    if o_overflow = '1' then
                        next_state <= WRITE_255;
                    else
                        next_state <= WRITE_EQUALIZED_PIXEL;
                    end if;
                when WRITE_255 =>
                    if o_end = '1' then
                        next_state <= FINISH;
                    else
                        next_state <= SET_NEW_WRITE_ADDRESS; 
                    end if;
                when WRITE_EQUALIZED_PIXEL =>
                    if o_end = '1' then
                        next_state <= FINISH;
                    else
                        next_state <= SET_NEW_WRITE_ADDRESS;
                    end if;
                when SET_NEW_WRITE_ADDRESS =>
                    next_state <= READ_PIXEL_2;
                when FINISH =>           
                    if i_start = '0' then
                        next_state <= START;
                    else
                        next_state <= cur_state;
                    end if;
            end case;
    end process;
    
    --processo attuatore degli stati
    state_agent: process(cur_state, o_reg3, o_reg4)     
    --segnali utili                                
    variable temp_address : UNSIGNED(15 downto 0) := (others => '0');
    begin                                   
        o_address <= (others => '0');    
        o_done <= '0';                      
        o_en <= '0';                        
        o_we <= '0';                                                     
        r1_load <= '0';                     
        r2_load <= '0';                     
        r3_load <= '0';                     
        r4_load <= '0';                     
        r4_sel <= '0';                      
        r5_load <= '0';                     
        rmax_load <= '0';                   
        rmin_load <= '0';                   
        rdelta_load <= '0';                 
        rshiftlvl_load <= '0';              
        roldval_load <= '0';                
        rtemp_pix_load <= '0';                         
        o_data_sel <= '1';

   case cur_state is             
        when START =>
            o_address <= (others => '0'); 
            o_en <= '1';
        when LOAD_COL =>
            o_address <= (0 => '1', others => '0');
            o_en <= '1';
            r1_load <= '1';
        when LOAD_ROW =>
            o_address <= (0 => '1', others => '0');
            r2_load <= '1';
        when MULT =>
            o_en <= '1';
            o_address <= (1 => '1', others => '0');
            r3_load <= '1';
        when LOAD_COUNTER =>
            o_address <= (1 => '1', others => '0');
            r4_load <= '1';
            r5_load <= '1';
        when LOAD_FIRST_PIXEL =>
            o_address <= (0 => '1', 1 => '1', others => '0'); 
            o_en <= '1'; 
            rmax_load <= '1';
            rmin_load <= '1';
        when READ_PIXEL_1 =>
            temp_address := unsigned(o_reg3) - unsigned(o_reg4) + 4;
            o_address <= std_logic_vector(temp_address); 
            r4_load <= '1';
            r4_sel <= '1';
            r5_load <= '1';
        when READ_CONTROL =>
            temp_address := unsigned(o_reg3) - unsigned(o_reg4) + 3;
            o_address <= std_logic_vector(temp_address);
            o_en <= '1';
            r4_sel <= '1';
        when NEW_MAX =>
            temp_address := unsigned(o_reg3) - unsigned(o_reg4) + 3;
            o_address <= std_logic_vector(temp_address);  
            o_en <= '1';
            r4_sel <= '1';
            rmax_load <= '1';
        when NEW_MIN =>
            temp_address := unsigned(o_reg3) - unsigned(o_reg4) + 3;
            o_address <= std_logic_vector(temp_address);
            o_en <= '1';
            r4_sel <= '1';
            rmin_load <= '1';
        when SET_DELTA_VALUE_and_COUNTER =>
            o_address <= (1 => '1', others => '0');
            o_en <= '1';
            r4_load <= '1';
            rdelta_load <= '1';
        when LOAD_COL0 =>            
            o_address <= (0 => '1', 1 => '1', others => '0');
            o_en <= '1';
            rshiftlvl_load <= '1';
            roldval_load <= '1';
        when READ_PIXEL_2 =>
            temp_address := unsigned(o_reg3) - unsigned(o_reg4) + 3;           
            o_address <= std_logic_vector(temp_address); 
            r4_sel <= '1';
            roldval_load <= '1';
            rtemp_pix_load <= '1';
        when WRITE_CONTROL =>
            temp_address := unsigned(o_reg3) - unsigned(o_reg4) + 3;     
            o_address <= std_logic_vector(temp_address); 
            r4_sel <= '1';
        when WRITE_255 =>
            temp_address := (unsigned(o_reg3) - unsigned(o_reg4) + 3) + (unsigned(o_reg3) - 1);
            o_address <= std_logic_vector(temp_address);
            r4_sel <= '1';
            o_data_sel <= '0';
            o_en <= '1';
            o_we <= '1';
        when WRITE_EQUALIZED_PIXEL =>
            temp_address := (unsigned(o_reg3) - unsigned(o_reg4) + 3) + (unsigned(o_reg3) - 1);
            o_address <= std_logic_vector(temp_address);
            r4_sel <= '1';                                      
            o_en <= '1';                                        
            o_we <= '1';
       when SET_NEW_WRITE_ADDRESS => 
            temp_address := (unsigned(o_reg3) - unsigned(o_reg4) + 3) + 1;
            o_address <= std_logic_vector(temp_address);
            o_en <= '1';
            r4_sel <= '1';
            r4_load <= '1';
        when FINISH =>
            o_address <= (others => '0');
            o_done <= '1';                        
     end case;     
     end process;
    
    mux_4 : process(i_clk, i_rst, r4_sel, o_reg3, o_reg4)
    variable sub : unsigned(15 downto 0) := (others => '0');
    begin
        if r4_sel = '0' then
            mux_reg4 <= o_reg3;
            o_end <= '0';
        else
            sub := unsigned(o_reg4) - 1;
            if sub = 0 then 
                o_end <= '1';
            else 
                o_end <= '0';
            end if;
            mux_reg4 <= std_logic_vector(sub);
        end if;
    end process;
    
    
    dec : process(o_reg_delta) --decoder
    begin
          if o_reg_delta = "00000000" then
              decoder <= "100000000"; --2^8
          elsif o_reg_delta = "00000001" or o_reg_delta = "00000010" then
              decoder <= "010000000"; --2^7
          elsif unsigned(o_reg_delta) > 2 and unsigned(o_reg_delta) < 7 then
              decoder <= "001000000"; --2^6
          elsif unsigned(o_reg_delta) > 6 and unsigned(o_reg_delta) < 15 then
              decoder <= "000100000"; --2^5
          elsif unsigned(o_reg_delta) > 14 and unsigned(o_reg_delta) < 31 then
              decoder <= "000010000"; --2^4
          elsif unsigned(o_reg_delta) > 30 and unsigned(o_reg_delta) < 63 then
              decoder <= "000001000"; --2^3
          elsif unsigned(o_reg_delta) > 62 and unsigned(o_reg_delta) < 127 then
              decoder <= "000000100"; --2^2
          elsif unsigned(o_reg_delta) > 126 and unsigned(o_reg_delta) < 255 then
              decoder <= "000000010"; --2^1
          else
              decoder <= "000000001"; --2^0
          end if;
    end process;
    
    mux_out_process : process(i_clk, i_rst, o_data_sel, o_reg_temp_pixel) 
    begin
        if o_data_sel = '1' then
            o_data <= o_reg_temp_pixel(7 downto 0);  
        else
            o_data <= (others => '1');
        end if;
    end process;

    --registri del datapath
    reg_1 : process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            o_reg1 <= (others => '0');
        elsif rising_edge(i_clk) then 
            if (r1_load = '1') then
                o_reg1 <= i_data;
            end if;
        end if;
    end process;
    
    reg_2 : process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            o_reg2 <= (others => '0');
        elsif rising_edge(i_clk) then 
            if (r2_load = '1') then
                o_reg2 <= i_data;
            end if;
        end if;
    end process;
    
    reg_3 : process(i_clk, i_rst)
    variable mult : unsigned(15 downto 0);
        
    begin
        if i_rst = '1' then
            o_reg3 <= (others => '0');
        elsif rising_edge(i_clk) then 
            if (r3_load = '1') then  
                mult := unsigned(o_reg1) * unsigned(o_reg2);
                o_reg3 <= std_logic_vector(mult);
            end if;
        end if;
    end process;
    
    reg_4 : process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            o_reg4 <= (others => '0');
        elsif rising_edge(i_clk) then 
            if (r4_load = '1') then
                o_reg4 <= mux_reg4;
            end if;
        end if;
    end process;
    
    reg_5 : process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            o_reg5 <= (others => '0');
        elsif rising_edge(i_clk) then 
            if (r5_load = '1') then
                o_reg5 <= i_data;
            end if;
        end if;
    end process;
    
    reg5_refresh : process(o_reg5, o_reg_max, o_reg_min) 
    begin
        if o_reg5 > o_reg_max then
            o_max_res <= '1';
        else
            o_max_res <= '0';
        end if;
        if o_reg5 < o_reg_min then
            o_min_res <= '1';
        else
            o_min_res <= '0';
        end if;
    end process;
    
    reg_max : process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            o_reg_max <= (others => '0');
        elsif rising_edge(i_clk) then 
            if (rmax_load = '1') then
                o_reg_max <= o_reg5;
            end if;
        end if;
    end process;
    
    reg_min : process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            o_reg_min <= (others => '0');
        elsif rising_edge(i_clk) then 
            if (rmin_load = '1') then
                o_reg_min <= o_reg5;
            end if;
        end if;
    end process;
    
    reg_delta : process(i_clk, i_rst)
    variable sub : unsigned(7 downto 0) := (others => '0');
    begin
        if i_rst = '1' then
            o_reg_delta <= (others => '0');
        elsif rising_edge(i_clk) then 
            if (rdelta_load = '1') then
                sub := unsigned(o_reg_max) - unsigned(o_reg_min);
                o_reg_delta <= std_logic_vector(sub);
            end if;
        end if;
    end process;
    
    reg_shiftlvl : process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            o_reg_shift_lvl <= (others => '0');
        elsif rising_edge(i_clk) then 
            if (rshiftlvl_load = '1') then
                o_reg_shift_lvl <= decoder;
            end if;
        end if;
    end process;
    
    reg_old_val : process(i_clk, i_rst)
    begin
        if i_rst = '1' then
            o_reg_old_val <= (others => '0');
        elsif rising_edge(i_clk) then 
            if (roldval_load = '1') then
                o_reg_old_val <= i_data;
            end if;
        end if;
    end process;
    
    reg_temp_pix : process(i_clk, i_rst)
    variable sub : unsigned(7 downto 0) := (others => '0');
    variable mult : unsigned(16 downto 0) := (others => '0');
    begin
        if i_rst = '1' then
            o_reg_temp_pixel <= (others => '0');
        elsif rising_edge(i_clk) then 
            if (rtemp_pix_load = '1') then
                sub := unsigned(o_reg_old_val) - unsigned(o_reg_min);
                mult := sub * unsigned(o_reg_shift_lvl);
                o_reg_temp_pixel <= std_logic_vector(mult);
            end if;
        end if;
    end process;
    
    reg_temp_pix_refresh : process(o_reg_temp_pixel)
    begin
        if unsigned(o_reg_temp_pixel) > 255 then
            o_overflow <= '1';
        else
            o_overflow <= '0';
        end if;
    end process;

end Behavioral;
