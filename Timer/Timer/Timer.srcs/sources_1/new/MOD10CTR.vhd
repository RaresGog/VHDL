library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity MOD10CTR is
    Port ( clk : in   STD_LOGIC;
           btn : in   std_logic;
           rst: in    std_logic;
           revers: in std_logic;
           enable: in std_logic;
           carry_borrow : out std_logic;
           counterOUT : out STD_LOGIC_VECTOR (3 downto 0));
end MOD10CTR;

architecture Behavioral of MOD10CTR is
    signal number : unsigned(3 downto 0);
begin
process(clk)
begin
    if rising_edge(clk) then
        if rst = '1' then
            number <= (others => '0');
            carry_borrow <= '0';
            
        elsif enable = '1' then
            if revers = '1' then
                
                 if number = "0001" then
                    number <= number - 1;
                    carry_borrow <='1'; 
                elsif number = "0000" then
                   number <= "1001";
                   carry_borrow <= '0';
            else
                number <= number - 1;
                carry_borrow <= '0';
            end if;
            
           elsif revers = '0' then
                if number = "1000" then
                    number <= number + 1;
                    carry_borrow <='1';            
                    elsif number = "1001" then
                    number <= (others => '0');
                    carry_borrow <= '0';
                else
                    number <= number + 1;
                    carry_borrow <= '0';
                end if;
            
           end if;
        elsif btn = '1' then
        if number = "1000" then
                    number <= number + 1;
                    carry_borrow <='1';        
                    elsif number = "1001" then
                    number <= (others => '0');
                    carry_borrow <= '0';
                else
                    number <= number + 1;
                    carry_borrow <= '0';
                end if;
           end if;
        end if;
end process;

counterOUT <= std_logic_vector(number);

end Behavioral;
