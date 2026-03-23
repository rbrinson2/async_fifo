
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
        clk : in STD_ULOGIC;
        rst : in STD_ULOGIC
        
    );
end entity fifo;


architecture rtl of fifo is
begin
    
    
    
end architecture rtl;
