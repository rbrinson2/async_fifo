
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
        room_avail  : INTEGER range 0 to FIFO_DEPTH;
        ---------- Read
        rdata       : STD_ULOGIC_VECTOR (FIFO_DATAWIDTH-1 downto 0);
        data_avail  : INTEGER range 0 to FIFO_DEPTH;

        ---------- Flags
        full        : STD_ULOGIC;
        empty       : STD_ULOGIC
    );
end entity fifo;


architecture rtl of fifo is
begin
    
    
    
end architecture rtl;
