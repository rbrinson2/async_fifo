
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use IEEE.MATH_REAL.all;


entity fifo is
    generic (
        FIFO_DATAWIDTH  : NATURAL := 16;
        FIFO_DEPTH      : NATURAL := 32
    );
    port (
        ------------------------------------------------------------ Inputs
        clk         : in STD_ULOGIC;
        rst_n       : in STD_ULOGIC;
        
        ---------- Write
        wdata       : STD_ULOGIC_VECTOR (FIFO_DATAWIDTH-1 downto 0);
        wen         : STD_ULOGIC;

        ---------- Read
        ren         : STD_ULOGIC;

        ------------------------------------------------------------ Outputs

        ---------- Write
        room_avail  : out INTEGER range 0 to FIFO_DEPTH;
        ---------- Read
        rdata       : out STD_ULOGIC_VECTOR (FIFO_DATAWIDTH-1 downto 0);
        data_avail  : out INTEGER range 0 to FIFO_DEPTH;

        ---------- Flags
        full        : out STD_ULOGIC;
        empty       : out STD_ULOGIC
    );
end entity fifo;


architecture rtl of fifo is
    constant HIGH       : STD_ULOGIC := '1';
    constant LOW        : STD_ULOGIC := '0';
    constant FIFO_PTR   : INTEGER := INTEGER(CEIL(LOG2(REAL(FIFO_DEPTH))));

    type mem_t is array (0 to FIFO_DEPTH-1) of STD_ULOGIC_VECTOR (FIFO_DATAWIDTH-1 downto 0);
    signal mem : mem_t;
    
    signal 
        wptr, 
        rptr, 
        dblnextptr, 
        nextptr  
    : UNSIGNED(FIFO_PTR-1 downto 0);

    signal efstate : STD_ULOGIC_VECTOR (3 downto 0);
begin
    -------------------- Memory Read and Write
    RW_PROC : process (clk) is
    begin
        if (rising_edge(clk)) then 
            if (wen) then mem(to_integer(wptr)) <= wdata; end if;
            rdata <= mem(to_integer(rptr));
        end if;
    end process;

    -------------------- Pointer Logic
    ---------- Write Pointer
    WPTR_LOG: process(clk)
    begin
        if rising_edge(clk) then
            if (not rst_n) then
                wptr <= (others => '0');
            elsif (wen) then
                if (not full or ren) then wptr <= wptr +1; end if;
            end if;
        end if;
    end process WPTR_LOG;
    ---------- Read Pointer
    RPTR_LOG: process(clk)
    begin
        if rising_edge(clk) then
            if (not rst_n) then
                rptr <= (others => '0'); 
            elsif (ren) then
                if (not empty) then rptr <= rptr + 1; end if;
            end if;
        end if;
    end process RPTR_LOG;


    ---------------- Calculate Full/Empty
    efstate <= (wen, ren, not full, not empty);
    dblnextptr <= wptr + 2;
    nextptr <= rptr + 1;
    EF_CALC: process (clk) is
    begin
        if (rising_edge(clk)) then
            if (not rst_n) then 
                empty <= '0';
                full <= '0';
            else 
                case? (efstate) is
                    when "01-1" => -- Successful Read
                        full <= LOW;
                        empty <= HIGH when (nextptr = wptr) else
                                 LOW;
                    when "1011" => -- Successful Write
                        full <= HIGH when (dblnextptr = rptr) else
                                LOW;
                        empty <= LOW;
                    when "11-0" => -- Successful write, failed read
                        full <= LOW;
                        empty <= LOW;
                    when "11-1" => -- Succesfull read and write
                        full <= full;
                        empty <= LOW;
                    when others =>
                end case?;
            end if;
        end if;
    end process;

end architecture rtl;
