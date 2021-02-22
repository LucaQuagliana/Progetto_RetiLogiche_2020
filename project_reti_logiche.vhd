----------------------------------------------------------------------------------
-- Progetto di reti logiche 2019/2020
-- Professore: Giuanluca Palermo 
-- Studente: Luca Quagliana (Matricola: 866468)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is
    Port ( i_clk : in STD_LOGIC;                            --clock di sistema generato dal testbench
           i_start : in STD_LOGIC;                          --segnale di start che inizia la computazione
           i_rst : in STD_LOGIC;                            --segnale di reset che porta la macchina allo stato iniziale
           i_data : in STD_LOGIC_VECTOR (7 downto 0);       --dati letti dalla memoria
           o_address : out STD_LOGIC_VECTOR (15 downto 0);  --indirizzo da indicare alla memoria in ingresso e in uscita
           o_done : out STD_LOGIC;                          --segnale di termine della computazione
           o_en : out STD_LOGIC;                            --segnale di enable della memoria
           o_we : out STD_LOGIC;                            --segnale di enable della scrittura in memoria (se o_en=0 è ininfluente)
           o_data : out STD_LOGIC_VECTOR (7 downto 0)       --dati da scrivere in memoria
           );
end project_reti_logiche;

architecture Behavioral of project_reti_logiche is
    type state_type is (RST,
                        REQUEST0, WAIT0, READ0,
                        REQUEST1, WAIT1, READ1,
                        REQUEST2, WAIT2, READ2,
                        REQUEST3, WAIT3, READ3,
                        REQUEST4, WAIT4, READ4,
                        REQUEST5, WAIT5, READ5,
                        REQUEST6, WAIT6, READ6,
                        REQUEST7, WAIT7, READ7,
                        REQUESTADDR, WAITADDR, READADDR,
                        VERIFY,CHOOSEOUT,
                        REQUESTOUT1, WAITOUT1, WRITEOUT1,
                        REQUESTOUT2, WAITOUT2, WRITEOUT2,
                        DONE, START_WAIT, NEXT_EXEC
                        );
    signal state: state_type;
                        
begin
    process(i_clk, i_rst)
        variable WZ0: std_logic_vector (7 downto 0);
        variable WZ1: std_logic_vector (7 downto 0);
        variable WZ2: std_logic_vector (7 downto 0);
        variable WZ3: std_logic_vector (7 downto 0);
        variable WZ4: std_logic_vector (7 downto 0);
        variable WZ5: std_logic_vector (7 downto 0);
        variable WZ6: std_logic_vector (7 downto 0);
        variable WZ7: std_logic_vector (7 downto 0);
        variable ADDR: std_logic_vector (7 downto 0);
        variable WZBIT: std_logic;
        variable WZNUM: std_logic_vector (2 downto 0);
        variable WZOFFSET: std_logic_vector (3 downto 0);
        
        begin
            --gestione reset asincrono, porto lo stato in RST
            if(i_rst = '1') then
                state <= RST;
            end if;
            --sincronizzazione sul rising edge di i_clk
            if(rising_edge(i_clk)) then
                case state is
                    when RST =>
                        if(i_start = '1') then
                            o_en <= '0';
                            o_we <= '0';
                            state <= REQUEST0;
                        else
                            state <= RST;
                        end if;
                    --acquisizione valori working zone 
                    when REQUEST0 =>
                        o_en <= '1';
                        o_we <= '0';
                        o_address <= "0000000000000000";
                        state <= WAIT0;
                    when WAIT0 =>
                        state <= READ0;
                    when READ0 =>
                        WZ0 := i_data;
                        o_en <= '0';
                        state <= REQUEST1;
                    
                    when REQUEST1 =>
                        o_en <= '1';
                        o_we <= '0';
                        o_address <= "0000000000000001";
                        state <= WAIT1;
                    when WAIT1 =>
                        state <= READ1;
                    when READ1 =>
                        WZ1 := i_data;
                        o_en <= '0';
                        state <= REQUEST2;
                    
                    when REQUEST2 =>
                        o_en <= '1';
                        o_we <= '0';
                        o_address <= "0000000000000010";
                        state <= WAIT2;
                    when WAIT2 =>
                        state <= READ2;
                    when READ2 =>
                        WZ2 := i_data;
                        o_en <= '0';
                        state <= REQUEST3;
                    
                    when REQUEST3 =>
                        o_en <= '1';
                        o_we <= '0';
                        o_address <= "0000000000000011";
                        state <= WAIT3;
                    when WAIT3 =>
                        state <= READ3;
                    when READ3 =>
                        WZ3 := i_data;
                        o_en <= '0';
                        state <= REQUEST4;
                    
                    when REQUEST4 =>
                        o_en <= '1';
                        o_we <= '0';
                        o_address <= "0000000000000100";
                        state <= WAIT4;
                    when WAIT4 =>
                        state <= READ4;
                    when READ4 =>
                        WZ4 := i_data;
                        o_en <= '0';
                        state <= REQUEST5;
                    
                    when REQUEST5 =>
                        o_en <= '1';
                        o_we <= '0';
                        o_address <= "0000000000000101";
                        state <= WAIT5;
                    when WAIT5 =>
                        state <= READ5;
                    when READ5 =>
                        WZ5 := i_data;
                        o_en <= '0';
                        state <= REQUEST6;
                    
                    when REQUEST6 =>
                        o_en <= '1';
                        o_we <= '0';
                        o_address <= "0000000000000110";
                        state <= WAIT6;
                    when WAIT6 =>
                        state <= READ6;
                    when READ6 =>
                        WZ6 := i_data;
                        o_en <= '0';
                        state <= REQUEST7;
                    
                    when REQUEST7 =>
                        o_en <= '1';
                        o_we <= '0';
                        o_address <= "0000000000000111";
                        state <= WAIT7;
                    when WAIT7 =>
                        state <= READ7;
                    when READ7 =>
                        WZ7 := i_data;
                        o_en <= '0';
                        state <= REQUESTADDR;
                    --acquisizione valore da codificare
                    when REQUESTADDR =>
                        o_en <= '1';
                        o_we <= '0';
                        o_address <= "0000000000001000";
                        state <= WAITADDR;
                    when WAITADDR =>
                        state <= READADDR;
                    when READADDR =>
                        ADDR := i_data;
                        o_en <= '0';
                        state <= VERIFY;
                    --algoritmo risolutivo
                    when VERIFY =>
                        --inizializzazione WZBIT
                        WZBIT := '0';
                        --verifica appartenenza alla working zone 0
                        if (ADDR = WZ0) then
                            WZBIT := '1';
                            WZNUM := "000";
                            WZOFFSET := "0001";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ0) + "00000001")) then
                            WZBIT := '1';
                            WZNUM := "000";
                            WZOFFSET := "0010";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ0) + "00000010")) then
                            WZBIT := '1';
                            WZNUM := "000";
                            WZOFFSET := "0100";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ0) + "00000011")) then
                            WZBIT := '1';
                            WZNUM := "000";
                            WZOFFSET := "1000";
                        --verifica appartenenza alla working zone 1
                        elsif (ADDR = WZ1) then
                            WZBIT := '1';
                            WZNUM := "001";
                            WZOFFSET := "0001";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ1) + "00000001")) then
                            WZBIT := '1';
                            WZNUM := "001";
                            WZOFFSET := "0010";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ1) + "00000010")) then
                            WZBIT := '1';
                            WZNUM := "001";
                            WZOFFSET := "0100";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ1) + "00000011")) then
                            WZBIT := '1';
                            WZNUM := "001";
                            WZOFFSET := "1000";
                        --verifica appartenenza alla working zone 2
                        elsif (ADDR = WZ2) then
                            WZBIT := '1';
                            WZNUM := "010";
                            WZOFFSET := "0001";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ2) + "00000001")) then
                            WZBIT := '1';
                            WZNUM := "010";
                            WZOFFSET := "0010";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ2) + "00000010")) then
                            WZBIT := '1';
                            WZNUM := "010";
                            WZOFFSET := "0100";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ2) + "00000011")) then
                            WZBIT := '1';
                            WZNUM := "010";
                            WZOFFSET := "1000";
                        --verifica appartenenza alla working zone 3
                        elsif (ADDR = WZ3) then
                            WZBIT := '1';
                            WZNUM := "011";
                            WZOFFSET := "0001";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ3) + "00000001")) then
                            WZBIT := '1';
                            WZNUM := "011";
                            WZOFFSET := "0010";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ3) + "00000010")) then
                            WZBIT := '1';
                            WZNUM := "011";
                            WZOFFSET := "0100";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ3) + "00000011")) then
                            WZBIT := '1';
                            WZNUM := "011";
                            WZOFFSET := "1000";
                        --verifica appartenenza alla working zone 4
                        elsif (ADDR = WZ4) then
                            WZBIT := '1';
                            WZNUM := "100";
                            WZOFFSET := "0001";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ4) + "00000001")) then
                            WZBIT := '1';
                            WZNUM := "100";
                            WZOFFSET := "0010";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ4) + "00000010")) then
                            WZBIT := '1';
                            WZNUM := "100";
                            WZOFFSET := "0100";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ4) + "00000011")) then
                            WZBIT := '1';
                            WZNUM := "100";
                            WZOFFSET := "1000";
                        --verifica appartenenza alla working zone 5
                        elsif (ADDR = WZ5) then
                            WZBIT := '1';
                            WZNUM := "101";
                            WZOFFSET := "0001";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ5) + "00000001")) then
                            WZBIT := '1';
                            WZNUM := "101";
                            WZOFFSET := "0010";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ5) + "00000010")) then
                            WZBIT := '1';
                            WZNUM := "101";
                            WZOFFSET := "0100";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ5) + "00000011")) then
                            WZBIT := '1';
                            WZNUM := "101";
                            WZOFFSET := "1000";
                        --verifica appartenenza alla working zone 6
                        elsif (ADDR = WZ6) then
                            WZBIT := '1';
                            WZNUM := "110";
                            WZOFFSET := "0001";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ6) + "00000001")) then
                            WZBIT := '1';
                            WZNUM := "110";
                            WZOFFSET := "0010";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ6) + "00000010")) then
                            WZBIT := '1';
                            WZNUM := "110";
                            WZOFFSET := "0100";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ6) + "00000011")) then
                            WZBIT := '1';
                            WZNUM := "110";
                            WZOFFSET := "1000";
                        --verifica appartenenza alla working zone 7
                        elsif (ADDR = WZ7) then
                            WZBIT := '1';
                            WZNUM := "111";
                            WZOFFSET := "0001";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ7) + "00000001")) then
                            WZBIT := '1';
                            WZNUM := "111";
                            WZOFFSET := "0010";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ7) + "00000010")) then
                            WZBIT := '1';
                            WZNUM := "111";
                            WZOFFSET := "0100";
                        elsif (ADDR = std_logic_vector(UNSIGNED (WZ7) + "00000011")) then
                            WZBIT := '1';
                            WZNUM := "111";
                            WZOFFSET := "1000";
                        end if;
                        state <= CHOOSEOUT;
                    --scelta dello stato di out
                    when CHOOSEOUT =>
                        if(WZBIT = '0') then
                            state <= REQUESTOUT1;
                        elsif(WZBIT = '1') then
                            state <= REQUESTOUT2;
                        end if;
                    --scrittura in caso di non appartenenza a working zone
                    when REQUESTOUT1 =>
                        o_en <= '1';
                        o_we <= '1';
                        O_address <= "0000000000001001";
                        o_data <= ADDR;
                        state <= WAITOUT1;
                    when WAITOUT1 =>
                        state <= WRITEOUT1;
                    when WRITEOUT1 =>
                        o_en <= '0';
                        o_we <= '0';
                        state <= DONE;
                    --scrittura in caso di appartenenza a working zone
                    when REQUESTOUT2 =>
                        o_en <= '1';
                        o_we <= '1';
                        O_address <= "0000000000001001";
                        o_data <= WZBIT & WZNUM & WZOFFSET;
                        state <= WAITOUT2;
                    when WAITOUT2 =>
                        state <= WRITEOUT2;
                    when WRITEOUT2 =>
                        o_en <= '0';
                        o_we <= '0';
                        state <= DONE;
                    --notifica della fine della computazione
                    when DONE =>
                        o_done <= '1';
                        state <= START_WAIT;
                    --attesa del programma
                    when START_WAIT =>
                        if(i_start = '1') then
                            state <= START_WAIT;
                        elsif(i_start = '0') then
                            o_done <= '0';
                            state <= NEXT_EXEC;
                        end if;
                    --decisione di mantenere le working zone e leggere un nuovo ADDR oppure ricominciare completamente
                    when NEXT_EXEC =>
                        if(i_start = '1') then
                            state <= REQUESTADDR;
                        elsif(i_rst = '1') then
                            state <= RST;
                        end if;
                end case;    
            end if;
        end process;
end Behavioral;