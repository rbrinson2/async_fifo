

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity fifo_tb is
end entity fifo_tb;


architecture rtl of fifo_tb is
    signal clk : std_logic := '0';
    signal rst : std_logic;
begin

    clk <= not clk after 10 ns;
    rst <= '1', '0' after 20 ns;

    process (clk) is
        variable count : integer := 0;
    begin
        if (rising_edge(clk)) then
            count := count + 1;
        end if;
        if (count >= 10) then
            std.env.stop;
        end if;
    end process;


    dut: entity work.fifo
     generic map(
        FIFO_DATAWIDTH => 32,
        FIFO_DEPTH => 16,
        FIFO_PTR => 4
    )
     port map(
        clk => clk,
        rst => rst
    );


end architecture rtl;
