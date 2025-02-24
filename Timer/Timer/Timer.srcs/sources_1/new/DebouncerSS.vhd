library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity DebouncerSS is
    Port ( BTN : in STD_LOGIC;
           CLK : in STD_LOGIC;
           ENABLE : out STD_LOGIC);
end DebouncerSS;
 
architecture Behavioral of debouncerSS is
    signal COUNT: STD_LOGIC_VECTOR(15 downto 0):=(others =>'0');
    signal Q1, Q2, Q3: STD_LOGIC:='0';
begin
   process(CLK)
        begin
            if (CLK='1' and CLK'EVENT) then
                COUNT<=COUNT+1;
            end if;
    end process;
 
   process(CLK)
        begin
            if (CLK='1' and CLK'EVENT) then
                if COUNT=x"FFFF" then
                    Q1<=BTN;
                end if;
            end if;
    end process;
    
   process(CLK)
        begin
            if (CLK='1' and CLK'EVENT) then
                    Q2<=Q1;
                    Q3<=Q2;
            end if;
    end process;
    
   enable <= Q2 and not Q3;
 
end Behavioral;