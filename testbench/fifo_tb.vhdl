

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.MATH_REAL.all;


entity fifo_tb is
end entity fifo_tb;


architecture rtl of fifo_tb is
    constant HIGH           : STD_LOGIC := '1';
    constant LOW            : STD_LOGIC := '0';
    constant FIFO_DATAWIDTH : NATURAL   := 16;
    constant FIFO_DEPTH     : NATURAL   := 32;

    type sim_t is (TEST_FULL, TEST_EMPTY, TEST_RW, FINISH);
    signal sim              : sim_t;

    signal clk              : std_ulogic := '0';
    signal rst_n            : std_ulogic := '0';

    signal wen              : STD_ULOGIC := '0';
    signal ren              : STD_ULOGIC := '0';

    signal wdata            : STD_ULOGIC_VECTOR (FIFO_DATAWIDTH-1 downto 0) := (others => '0');
    signal rdata            : STD_ULOGIC_VECTOR (FIFO_DATAWIDTH-1 downto 0) := (others => '0');

    signal room_avail       : INTEGER range 0 to FIFO_DEPTH := 0;
    signal data_avail       : INTEGER range 0 to FIFO_DEPTH := 0;

    signal full             : STD_ULOGIC := '0';
    signal empty            : STD_ULOGIC := '0';

    signal count            : INTEGER := 0;
    signal finished         : STD_ULOGIC := '0';
begin

    clk <= not clk after 10 ns;
    rst_n <= '0', '1' after 40 ns;

    STIMULUS : process(clk) is
        variable start : INTEGER := -1;
        variable stop  : INTEGER := -1;
    begin
        wen <= '0';
        ren <= '0';

        case sim is
            when TEST_FULL =>
                wen <= '1';
                wdata <= STD_ULOGIC_VECTOR(to_unsigned(count, wdata'length));
                if full then sim <= TEST_EMPTY; end if;

            when TEST_EMPTY =>
                ren <= '1';
                if empty then sim <= TEST_RW; end if;

            when TEST_RW =>
                if start = -1 then 
                    start := count;
                    stop := count + 20;
                end if;

                wen <= '1';
                ren <= '1';
                wdata <= STD_ULOGIC_VECTOR(to_unsigned(count, wdata'length));
                start := start + 1;

                if start = stop then sim <= FINISH; end if;

            when FINISH => std.env.stop;
        end case;
    end process STIMULUS ;

    COUNTER : process(clk)
    begin
        if rising_edge(clk) then
            count <= count + 1;
            -- if count >= 100 then std.env.stop; end if;
        end if;
    end process COUNTER;

    DUT: entity work.fifo
     generic map(
        FIFO_DATAWIDTH => FIFO_DATAWIDTH,
        FIFO_DEPTH => FIFO_DEPTH
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
