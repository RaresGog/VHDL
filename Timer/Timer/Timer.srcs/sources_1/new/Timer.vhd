library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Timer is
  Port (    clk : in std_logic;                         
            M : in std_logic;                           
            S : in std_logic;                      
            SS : in std_logic;                      
            bec : out std_logic;
            an : out std_logic_vector (3 downto 0);     
            ca : out std_logic_vector (6 downto 0));  
end Timer;

architecture Behavioral  of Timer is

component MOD10CTR is                        
    Port ( clk : in STD_LOGIC;
           BTN : IN STD_LOGIC;
           rst : in std_logic;
           revers : in std_logic;
           enable : in std_logic;
           carry_borrow : out std_logic;
           counterOUT : out STD_LOGIC_VECTOR (3 downto 0));
end component ;

component  MOD6CTR is                      
    Port ( clk : in STD_LOGIC;
           rst : in std_logic;
           revers : in std_logic;
           enable : in std_logic;
           carry_borrow : out std_logic;
           counterOUT : out STD_LOGIC_VECTOR (3 downto 0));
end component ;

component DebouncerSM is                              
    Port ( BTN : in STD_LOGIC;
           CLK : in STD_LOGIC;
           ENABLE : out STD_LOGIC);
end component ;

COMPONENT DebouncerSS is
    Port ( BTN : in STD_LOGIC;
           CLK : in STD_LOGIC;
           ENABLE : out STD_LOGIC);
end component;

component SVN_SEG09 is                      
    Port (   clk : in std_logic;
             Rez : in STD_LOGIC_VECTOR (15 downto 0);
             an : out STD_LOGIC_VECTOR (3 downto 0);
             cat : out STD_LOGIC_VECTOR (6 downto 0));
end component ;

component   clock_divider is
    Port (  clk_intrare : in STD_LOGIC;      
            clk_1hz : out STD_LOGIC);
end component;

signal resetare, invers : std_logic :='0';                             
signal CB_S0, CB_S1, CB_M0, CB_M1: std_logic;                           
signal S0EN, S1EN, M0EN, M1EN: std_logic;                               
signal clk1hz : std_logic;                                            
signal concat_cif : std_logic_vector( 15 downto 0);                 
signal M_DB, S_DB, SS_DB : STD_LOGIC;                               
signal btn_state_S, btn_state_SS, btn_state_M : std_logic := '0';    
SIGNAL EN1,EN2,EN3,EN4,EN5,EN6,EN7 : STD_LOGIC :='0';
signal prev_state_s, prev_State_m : std_logic :='0';
signal inc_s,inc_m : std_logic;

begin

process (btn_state_s, btn_state_ss, btn_state_m, ss_Db, m_db, s_db, clk)
begin

if rising_edge (clk) then

        if s_db = '1' and resetare = '0' then
            prev_State_s <= '1';
            btn_State_s <= not btn_state_s;
           if(EN7 ='0') THEN btn_state_ss <= '0';
           END IF;
            
        elsif m_db = '1' and resetare= '0' then
            prev_State_m <= '1';                      
            btn_state_m <= not btn_state_m;          
            if(EN7 ='0') THEN btn_state_ss <= '0';
            END IF;
            
        elsif ss_db = '1' then
            btn_state_ss <= not btn_state_ss;
            btn_state_s  <= '0';
            btn_state_m  <= '0';
            resetare <= '0';
            if prev_state_m = '1' or prev_state_s = '1' then 
                        invers <= '1';
                        EN7 <='1';
                  end if;
        end if;
        
    if s = '1' and m = '1' then
        resetare <= '1';
        invers   <= '0';
        btn_state_s  <= '0';
        btn_state_m  <= '0';
        btn_state_ss <= '0';
        PREV_STATE_S <= '0';
        PREV_STATE_M <= '0' ;
        bec <='0';
        EN7 <='0';
        EN6 <='0';
        EN5 <='0';
        EN4 <='0';
        EN3 <='0';
        EN2 <='0';
        EN1 <='0';
    end if;
    
    if invers = '1' and concat_cif = "0000000000000000" then   
        bec <= '1';
        btn_state_s  <= '0';
        btn_state_m  <= '0';
        btn_state_ss <= '0';
        invers <= '0';
    END IF;
    
    IF CB_M1 = '1' and CB_M0 = '1' AND CB_S1 = '1' AND CB_S0 = '1' THEN
        resetare <= '1';
        invers   <= '0';
        btn_state_s  <= '0';
        btn_state_m  <= '0';
        btn_state_ss <= '0';
        PREV_STATE_S <= '0';
        PREV_STATE_M <= '0' ;
        bec <='0';
        EN7 <='0';
        EN6 <='0';
        EN5 <='0';
        EN4 <='0';
        EN3 <='0';
        EN2 <='0';
        EN1 <='0';
    end if;
    
    if(invers='1' and concat_cif(3 downto 0)="0000" and CB_S0='0' and concat_cif(15 downto 4) /= "000000000000") THEN
            EN1 <= '1';
   else EN1<='0';
   END IF;
   if(invers='1' and concat_cif(7 downto 4)="0000" and CB_S1='0' and concat_cif(15 downto 8) /="00000000" ) THEN
            EN2 <= '1';
   else EN2<='0';
   END IF;
   if(invers='1' and concat_cif(11 downto 8)="0000" and CB_M0='0' and concat_cif(15 downto 12) /= "0000") THEN
            EN3 <= '1';
   else EN3<='0';
   END IF;
   
   if(invers='1' and concat_cif(3 downto 0)="1001" and CB_S0='1') THEN
            EN4 <= '0';
   else EN4<='1';
   END IF;
   if(invers='1' and concat_cif(7 downto 4)="0101" AND CB_S1='1' ) THEN
            EN5 <= '0';
   else EN5<='1';
   END IF;
   if(invers='1' and concat_cif(11 downto 8)="1001" and CB_M0='1') THEN
            EN6 <= '0';
   else EN6<='1';
   END IF;
end if;
end process;

--enable pentru fiecare counter--
S0EN <= btn_state_ss;
S1EN <= (S0EN and ((CB_S0 and EN4) OR EN1)) or (((CB_S0 and EN4) OR EN1) and (btn_state_s and NOT EN7) );
M0EN <= (S1EN and ((CB_S1 and EN5)  OR EN2));
M1EN <= (M0EN and ((CB_M0 and EN6)  OR EN3)) or (((CB_M0 and EN6)  OR EN3) and (btn_state_m and NOT EN7) );
INC_S <= btn_state_S and not EN7;
INC_M <= btn_state_m and not EN7;


DB1 : DebouncerSS port map (btn => SS, clk => clk, enable => SS_DB );
DB2 : DebouncerSM   port map (btn => S , clk => clk, enable =>  S_DB );
DB3 : DebouncerSM   port map (btn => M , clk => clk, enable =>  M_DB );

C1 : clock_divider port map ( clk_intrare => clk, clk_1hz => clk1hz);
C2 : MOD10CTR  port map ( clk => clk1hz, btn => inc_S,       rst => resetare, revers => invers, enable => S0EN , carry_borrow => CB_S0, counterOUT => concat_cif( 3 downto  0));
C3 : MOD6CTR   port map ( clk => clk1hz,                     rst => resetare, revers => invers, enable => S1EN , carry_borrow => CB_S1, counterOUT => concat_cif( 7 downto  4));
C4 : MOD10CTR  port map ( clk => clk1hz, btn => inc_m      , rst => resetare, revers => invers, enable => M0EN , carry_borrow => CB_M0, counterOUT => concat_cif(11 downto  8));
C5 : MOD10CTR  port map ( clk => clk1hz, btn => '0'        , rst => resetare, revers => invers, enable => M1EN , carry_borrow => CB_M1, counterOUT => concat_cif(15 downto 12));
C6 : SVN_SEG09 port map ( clk => clk, rez => concat_cif, an => an , cat => ca ); 

end Behavioral;
