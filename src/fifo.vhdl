
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

use IEEE.MATH_REAL.all;


entity fifo is
    generic (
        FIFO_DATAWIDTH  : NATURAL := 32;
        FIFO_DEPTH      : NATURAL := 16;
        FIFO_PTR        : NATURAL := 4
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
        room_avail  : STD_ULOGIC_VECTOR (FIFO_PTR-1 downto 0);
        ---------- Read
        rdata       : STD_ULOGIC_VECTOR (FIFO_DATAWIDTH-1 downto 0);
        data_avail  : STD_ULOGIC_VECTOR (FIFO_PTR-1 downto 0);

        ---------- Flags
        full        : STD_ULOGIC;
        empty       : STD_ULOGIC
    );
end entity fifo;


architecture rtl of fifo is
begin
    
    
    
end architecture rtl;
