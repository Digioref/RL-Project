----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.02.2023 16:13:37
-- Design Name: 
-- Module Name: project_reti_logiche - project_reti_logiche_arch
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

entity project_reti_logiche is
    port (
        i_clk : in std_logic;
        i_rst : in std_logic;
        i_start : in std_logic;
        i_w : in std_logic;
        o_z0 : out std_logic_vector(7 downto 0);
        o_z1 : out std_logic_vector(7 downto 0);
        o_z2 : out std_logic_vector(7 downto 0);
        o_z3 : out std_logic_vector(7 downto 0);
        o_done : out std_logic;
        o_mem_addr : out std_logic_vector(15 downto 0);
        i_mem_data : in std_logic_vector(7 downto 0);
        o_mem_we : out std_logic;
        o_mem_en : out std_logic
    );
end project_reti_logiche;

architecture project_reti_logiche_arch of project_reti_logiche is
    type S is (INIT_READ_W0, READ_W1, READ_ADDRESS, ASK_MEM, READ_MEM, SHOW_OUT); 
    signal curr_state : S;
    signal reg1_int : std_logic_vector(1 downto 0);
    signal reg2_addr : std_logic_vector(15 downto 0);
    signal reg3_z0 : std_logic_vector(7 downto 0);
    signal reg4_z1 : std_logic_vector(7 downto 0);
    signal reg5_z2 : std_logic_vector(7 downto 0);
    signal reg6_z3 : std_logic_vector(7 downto 0);
    signal reg1_load_en : std_logic;
    signal reg2_load_en : std_logic;
    signal reg2_reset : std_logic;
    signal save_enable : std_logic;
    signal out_enable : std_logic;
      
begin

    reg1_int_proc : process(i_clk, i_rst)
        begin
            if i_rst = '1' then
                reg1_int <= "00";
            
            elsif i_clk'event and i_clk = '1' and i_start = '1' then
                if reg1_load_en = '1' then
                    reg1_int (1 downto 0) <= reg1_int(0) & i_w;
                end if;
            end if;
        end process;
        
    reg2_addr_proc : process(i_clk, reg2_reset, i_rst)
        begin
            if reg2_reset = '1' or i_rst = '1' then
                reg2_addr <= "0000000000000000";
            
            elsif  i_clk'event and i_clk = '1' and i_start = '1' then
                if reg2_load_en = '1' then
                    reg2_addr(15 downto 0) <= reg2_addr(14 downto 0) & i_w;
                end if;
            end if;
        end process;       
        
    mem_proc : process (i_start)
        begin
            o_mem_addr (15 downto 0) <= reg2_addr(15 downto 0);
        end process;
                 
    load_reg_proc : process (i_clk, i_rst, save_enable)
        begin
            if i_rst = '1' then
                reg3_z0 <= "00000000";
                reg4_z1 <= "00000000";
                reg5_z2 <= "00000000";
                reg6_z3 <= "00000000";
            
            elsif i_clk = '1' and i_clk'event and save_enable = '1' then
                case reg1_int(1 downto 0) is 
                    when "00" =>
                        reg3_z0(7 downto 0) <= i_mem_data(7 downto 0);                   
                    when "01" =>
                        reg4_z1(7 downto 0) <= i_mem_data(7 downto 0);
                    when "10" =>
                        reg5_z2(7 downto 0) <= i_mem_data(7 downto 0);
                    when "11" =>
                        reg6_z3(7 downto 0) <= i_mem_data(7 downto 0);
                    when others =>
                        reg3_z0(7 downto 0) <= "00000000";
                        reg4_z1(7 downto 0) <= "00000000";
                        reg5_z2(7 downto 0) <= "00000000";
                        reg6_z3(7 downto 0) <= "00000000";
                end case;
            end if;
        end process;        
                
    out_proc : process (out_enable)
        begin
            case out_enable is 
                when '0' =>
                    o_z0 <= "00000000";
                    o_z1 <= "00000000";
                    o_z2 <= "00000000";
                    o_z3 <= "00000000";
                when '1' =>
                    o_z0 <= reg3_z0(7 downto 0);
                    o_z1 <= reg4_z1(7 downto 0);
                    o_z2 <= reg5_z2(7 downto 0);
                    o_z3 <= reg6_z3(7 downto 0);
                when others =>
                    o_z0 <= "00000000";
                    o_z1 <= "00000000";
                    o_z2 <= "00000000";
                    o_z3 <= "00000000";
             end case;
         end process;

    fsm : process (i_clk, i_rst)
        begin
            if i_rst = '1' then
                curr_state <= INIT_READ_W0;
            elsif i_clk'event and i_clk = '1' then
                case curr_state is 
                    when INIT_READ_W0 =>
                        if i_start = '1' then
                            curr_state <= READ_W1;
                        end if;
                    when READ_W1 =>
                        curr_state <= READ_ADDRESS;
                    when READ_ADDRESS =>
                        if i_start = '0' then
                            curr_state <= ASK_MEM;
                        end if;
                    when ASK_MEM =>
                        curr_state <= READ_MEM;
                    when READ_MEM =>
                        curr_state <= SHOW_OUT;
                    when SHOW_OUT =>
                        curr_state <= INIT_READ_W0;
                    end case;     
                end if;
            end process;                 
                        
    fsm_lambda : process (curr_state)
        begin           
            reg2_reset <= '0';
            reg1_load_en <= '0';
            reg2_load_en <= '0';
            save_enable <= '0';
            out_enable <= '0';
            o_done <= '0';
            o_mem_we <= '0';
            o_mem_en <= '0';
            
            case curr_state is 
                when INIT_READ_W0 =>
                    reg2_reset <= '1';
                    reg1_load_en <= '1';
                when READ_W1 =>
                    reg1_load_en <= '1';
                when READ_ADDRESS =>
                    reg2_load_en <= '1';
                when ASK_MEM =>
                    o_mem_en <= '1';    
                when READ_MEM =>
                    save_enable <= '1';
                when SHOW_OUT =>  
                    out_enable <= '1';
                    o_done <= '1';
            end case;
        end process;
                    
end project_reti_logiche_arch;
