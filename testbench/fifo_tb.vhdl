

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity fifo_tb is
end entity fifo_tb;


architecture rtl of fifo_tb is
    constant HIGH : STD_LOGIC := '1';
    constant LOW : STD_LOGIC := '0';

    type sim_t is (TEST_FULL, TEST_EMPTY, TEST_RW, TEST_RO, TEST_WO);
    signal sim : sim_t;

    signal clk : std_logic := '0';
    signal rst : std_logic;

    signal count : INTEGER range 0 to 32;
begin

    clk <= not clk after 10 ns;
    rst <= '1', '0' after 20 ns;

    STIMULUS : process(clk, rst)
    begin
        if rst = HIGH then
            count <= 0;
        elsif (rising_edge(clk)) then
            case sim is
                when TEST_FULL =>
                    if (count >= 10) then std.env.stop; 
                    end if;
                when others =>
            end case;

            count <= count + 1;
        end if;
    end process STIMULUS ;

    DUT: entity work.fifo
     port map(
        clk => clk,
        rst_n => rst_n,
        wdata => wdata,
        wen => wen,
        ren => ren,
        room_avail => room_avail,
        rdata => rdata,
        data_avail => data_avail,
        full => full,
        empty => empty
    );

end architecture rtl;
