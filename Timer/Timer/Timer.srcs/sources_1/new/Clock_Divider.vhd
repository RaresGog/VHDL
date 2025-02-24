library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Clock_divider is
    Port ( clk_intrare : in STD_LOGIC;
           clk_1hz : out STD_LOGIC);
end Clock_divider;

architecture Behavioral of clock_divider is
signal count_up : integer :=0;
signal  b : std_logic :='0';
begin
process(b,clk_intrare)
begin
if(rising_edge(clk_intrare)) then
    count_up <= count_up + 1;
        if(count_up = 49999999) then
            b <= not b;
            count_up <= 0;
        end if;
end if;

clk_1hz <= b;

end process;
end Behavioral;
