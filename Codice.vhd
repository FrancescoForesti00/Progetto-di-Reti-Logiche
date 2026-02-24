library IEEE;
use IEEE.STD_LOGIC_1164.ALL;




--FSM
entity project_reti_logiche is
    Port (
        i_clk       : in std_logic;
        i_rst       : in std_logic;
        i_start     : in std_logic;
        i_add       : in std_logic_vector(15 downto 0);
        i_k         : in std_logic_vector(9 downto 0);

        o_done      : out std_logic;

        o_mem_addr  : out std_logic_vector(15 downto 0);
        i_mem_data  : in std_logic_vector(7 downto 0);
        o_mem_data  : out std_logic_vector(7 downto 0);
        o_mem_we    : out std_logic;
        o_mem_en    : out std_logic
    );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
component datapath is 
    Port ( 
            i_clk       : in std_logic;
            i_rst       : in std_logic;
            i_add       : in std_logic_vector(15 downto 0);
            i_k         : in std_logic_vector(9 downto 0);
            reset     : in std_logic;
     
            o_mem_addr  : out std_logic_vector(15 downto 0);
            i_mem_data  : in std_logic_vector(7 downto 0);
            o_mem_data  : out std_logic_vector(7 downto 0);

            o_end : out std_logic;
            

            en_k : in std_logic;
            
            en_r_old : in std_logic;
            en_r1 : in std_logic;
            
            en_r2 : in std_logic;
            
            en_r3 : in std_logic;
                
            
            sel_mux_4 : in std_logic       
           );
end component;
           signal en_r_old :  std_logic;
           signal en_k :  std_logic;
           signal en_r1 :  std_logic;
           signal en_r2 :  std_logic;
           signal en_r3 :  std_logic;
           signal reset :  std_logic;
           signal sel_mux_4 :  std_logic;          
           signal o_end : std_logic; 
           
           type S is (S0, S1, S2, S3, S4, S5, S6, S7, S8);
           signal cur_state, next_state : S;
begin
DATAPATH0: datapath port map(
        i_clk => i_clk,
        i_rst => i_rst, 
        i_add => i_add,
        i_k => i_k,
        i_mem_data => i_mem_data,
        reset => reset,   
        o_end => o_end,
        o_mem_addr => o_mem_addr, 
        o_mem_data => o_mem_data,          
        
        en_r_old => en_r_old,   
                                     
        en_k => en_k,
        en_r1 => en_r1,
        en_r2 => en_r2,
        en_r3 => en_r3,      
        sel_mux_4 => sel_mux_4  
    );


process(i_clk, i_rst)
        begin
            if(i_rst='1') then
                cur_state <= S0;
            elsif i_clk'event and i_clk = '1' then
                cur_state <= next_state;
            end if;
        end process;
    
        process(cur_state, i_start, o_end)
        begin 
            next_state <= cur_state;
            case cur_state is 
                when S0 =>
                    if i_start = '1' then
                        next_state <= S1;
                    end if;
                when S1 =>
                    next_state <= S2;
                when S2 => 
                    if o_end = '1' then
                        next_state <= S8;
                    else
                        next_state <= S3;
                    end if;
                when S3 =>
                    next_state <= S4;                    
                when S4 =>
                    next_state <= S5;
                when S5 =>
                    next_state <= S6;
                when S6 =>
                    next_state <= S7;
                when S7 =>
                     next_state <= S2;
                when S8 =>
                    if i_start = '0' then
                        next_state <= S0;
                    end if;
             end case;
        end process;
             
        process(cur_state)
            begin
                    o_done <= '0';                     
                    o_mem_we <= '0';             
                    o_mem_en <= '0';                                   
                    en_k <= '0';
                    en_r1 <= '0';
                    en_r2 <= '0';
                    en_r3 <= '0';
                    en_r_old <= '0';
                    sel_mux_4 <= '0';    
                    reset <= '0';        
                    
                case cur_state is 
                    when S0 =>   
                    when S1 => 
                        reset <= '1';
                    when S2 =>
                        o_mem_en <= '1';              
                    when S3 =>                                               
                        en_r2 <= '1';
                        en_r_old <= '1';
                    when S4 =>                       
                        sel_mux_4 <= '1';
                        o_mem_we <= '1';             
                        o_mem_en <= '1';                         
                    when S5 =>
                        en_r1 <= '1';
                        en_r3 <= '1';
                    when S6 =>
                        o_mem_we <= '1';             
                        o_mem_en <= '1';                        
                    when S7 =>              
                        en_r1 <= '1';
                        en_k <= '1';                       
                    when S8 => 
                        o_done <= '1';                                          
                end case;
        end process;
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity datapath is
    Port(
        i_clk       : in std_logic;
        i_rst       : in std_logic;
        i_add       : in std_logic_vector(15 downto 0);
        i_k         : in std_logic_vector(9 downto 0);
        reset     : in std_logic;
    
        o_mem_addr  : out std_logic_vector(15 downto 0);
        i_mem_data  : in std_logic_vector(7 downto 0);
        o_mem_data  : out std_logic_vector(7 downto 0);

        o_end : out std_logic;
        
        
        en_r_old : in std_logic;
        
        sel_mux_4 : in std_logic;
        
        
        en_k : in std_logic;
      
        
        en_r1 : in std_logic;

        
        en_r2 : in std_logic;
        
        en_r3 : in std_logic
    );
    
end entity;
        
        
        
architecture Behavioral of datapath is
    signal counter_k : std_logic_vector(9 downto 0);
    signal equal : std_logic_vector(9 downto 0);
    signal sel_mux_2 : std_logic;
    signal sel_mux_3 : std_logic;
    signal register_1 : std_logic_vector(15 downto 0);
    signal register_2 : std_logic_vector(7 downto 0);
    signal register_3 : std_logic_vector(7 downto 0);
    signal register_old : std_logic_vector(7 downto 0);
 
    signal out_mux_2 : std_logic_vector(7 downto 0);
    signal out_mux_3 : std_logic_vector(7 downto 0);
    signal out_sub_3 : std_logic_vector(7 downto 0);
    
begin
--utilizzare un segnale interno per cambiare lo stato in base al datapath
equal <= i_k - counter_k;
o_end <= '1' when equal = "0000000000" else '0';
--en_k
process(i_clk, i_rst, reset)
    begin
    if i_rst = '1' then
        counter_k <= (others => '0');
    elsif reset = '1' then
        counter_k <= (others => '0');
    elsif i_clk'event and i_clk = '1' then
        if en_k = '1' then 
            counter_k <= counter_k + "0000000001";   
        end if;
    end if;    
end process;  

--o_mem_addr
o_mem_addr <= register_1 + i_add;

--register 1
process(i_clk, i_rst, reset)   
begin
    if i_rst = '1' then
        register_1 <= (others => '0');
    elsif reset = '1' then
        register_1 <= (others => '0');
    elsif i_clk'event and i_clk = '1' then
        if en_r1 = '1' then
            register_1 <= register_1 + "0000000000000001";
        end if;
    end if;
end process;

--register 2
process(i_clk, i_rst, reset)   
begin
    if i_rst = '1' then
        register_2 <= (others => '0');
    elsif reset = '1' then
            register_2 <= (others => '0');        
    elsif i_clk'event and i_clk = '1' then
        if en_r2 = '1' then
            register_2 <= out_mux_2;
        end if;
    end if;
end process;

--register 3
process(i_clk, i_rst, reset)   
begin
    if i_rst = '1' then
        register_3 <= (others => '0');
    elsif reset = '1' then
            register_3 <= (others => '0');        
    elsif i_clk'event and i_clk = '1' then
        if en_r3 = '1' then
            register_3 <= out_mux_3;
        end if;
    end if;
end process;

--register old
process(i_clk, i_rst, reset)   
begin
    if i_rst = '1' then
        register_old <= (others => '0');
    elsif reset = '1' then
        register_old <= (others => '0');        
    elsif i_clk'event and i_clk = '1' then
        if en_r_old = '1' then
            register_old <= i_mem_data;
        end if;
    end if;
end process;
--sub 3
out_sub_3 <= register_3 when (register_3 = "00000000") else (register_3 - "00000001");

--mux 2
sel_mux_2 <= '1' when (i_mem_data = "00000000") else '0';

with sel_mux_2 select
    out_mux_2 <= i_mem_data when '0',
                 register_2 when '1',
                 (others => 'X') when others;
                 
--mux 3
sel_mux_3 <= '1' when (register_old = "00000000") else '0';

with sel_mux_3 select
    out_mux_3 <= "00011111" when '0',
                 out_sub_3 when '1',
                 (others => 'X') when others; 
                 
--mux 4
with sel_mux_4 select
    o_mem_data <= register_2 when '1',
                  register_3 when '0',
                  (others => 'X') when others;                                
end Behavioral;

