library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity SVN_SEG09 is
    Port (  clk : in STD_LOGIC;
            Rez : in STD_LOGIC_VECTOR (15 downto 0);
            an : out STD_LOGIC_VECTOR (3 downto 0);
            cat : out STD_LOGIC_VECTOR (6 downto 0));
end SVN_SEG09;

architecture Behavioral of SVN_SEG09 is
signal counter: std_logic_vector (15 downto 0);
signal n: std_logic_vector (3 downto 0);

begin
process(CLK)
begin 
	if clk'event and clk='1' then 
		counter <= counter + 1;
	end if;
end process;

process(n)
begin 
	case (n) is 
		when "0001" => cat <= "1111001"; --1
		when "0010" => cat <= "0100100"; --2
		when "0011" => cat <= "0110000"; --3
		when "0100" => cat <= "0011001"; --4
		when "0101" => cat <= "0010010"; --5
		when "0110" => cat <= "0000010"; --6
		when "0111" => cat <= "1111000"; --7
		when "1000" => cat <= "0000000"; --8
		when "1001" => cat <= "0010000"; --9
		when others => cat <= "1000000"; --0		
	end case;
	
end process;

process(counter(15 downto 14))
	begin 
		case counter(15 downto 14) is 
		 when "00" => an <= "1110";
         when "01" => an <= "1101";
         when "10" => an <= "1011";
         when others => an <= "0111";
      end case;
end process;

process(counter(15 downto 14),Rez)
	begin 
		case counter (15 downto 14) is 
			when "00"=> n <= Rez(3 downto 0);
			when "01"=> n <= Rez(7 downto 4);
			when "10"=> n <= Rez(11 downto 8);
			when others => n <= Rez(15 downto 12);
		end case;
end process;



end Behavioral;
