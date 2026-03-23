

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity fifo_tb is
end entity fifo_tb;


architecture rtl of fifo_tb is
    constant HIGH           : STD_LOGIC := '1';
    constant LOW            : STD_LOGIC := '0';
    constant FIFO_DATAWIDTH : NATURAL   := 32;
    constant FIFO_DEPTH     : NATURAL   := 16;
    constant FIFO_PTR       : NATURAL   := 4;

    type sim_t is (TEST_FULL, TEST_EMPTY, TEST_RW, FINISH);
    signal sim              : sim_t;

    signal clk              : std_ulogic := '0';
    signal rst_n            : std_ulogic;

    signal wen              : STD_ULOGIC;
    signal ren              : STD_ULOGIC;

    signal wdata            : STD_ULOGIC_VECTOR (FIFO_DATAWIDTH-1 downto 0);



    signal count            : INTEGER range 0 to 32;
begin

    clk <= not clk after 10 ns;
    rst_n <= '1', '0' after 20 ns;

    STIMULUS : process(clk, rst_n)
    begin
        wen <= '0';
        if rst_n = HIGH then
            count <= 0;
        elsif (rising_edge(clk)) then
            case sim is
                when TEST_FULL =>
            end case;

            count <= count + 1;
        end if;
    end process STIMULUS ;

    DUT: entity work.fifo
     generic map(
        FIFO_DATAWIDTH => FIFO_DATAWIDTH,
        FIFO_DEPTH => FIFO_DEPTH,
        FIFO_PTR => FIFO_PTR
    )
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
