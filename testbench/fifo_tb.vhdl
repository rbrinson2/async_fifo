

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
