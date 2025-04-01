library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity A429_Tx is
    generic(
        clk_freq           : integer := 100_000_000;  -- Clock da FPGA
        transmission_speed : integer := 100_000;      -- 100 kHz
        frame_label        : std_logic_vector(7 downto 0) := X"4F";
        sdi                 : std_logic_vector(1 downto 0) := "00"; -- 00-All Systems, 01-System1, 10-System2, 11-System3
        ssm                 : std_logic_vector(1 downto 0) := "00"  -- Normal
    );
    port(
        -- INPUT
        clk, rst  : in std_logic;
        start_bit : in std_logic;
        data_in   : in std_logic_vector(18 downto 0);
        
        -- OUTPUT
        ATx_high  : out std_logic;
        ATx_low   : out std_logic
    );
end entity;

architecture main of A429_Tx is
    constant clk_div_bit : integer := clk_freq / transmission_speed;

    type state_A429 is (
        idle,           -- Aguarda um novo dado para transmitir
        load_data,      -- Carrega a palavra de 32 bits para envio
        send_bits,      -- Transmite cada bit conforme a condicao bipolar de return_to_zero(RZ)
        parity_check,   -- Calcula e adiciona o bit de paridade
        gap,            -- Mantem o espacamento entre palavras (min. 4 bits de tempo)
        done            -- Volta ao estado idle
    );
    signal state : state_A429 := idle;

    signal count : integer := 0;
    signal clk_enable : std_logic := '0';


begin

    -- Clock Divider para gerar um pulso de 100 kHz
    div_clk: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                count <= 0;
                clk_enable <= '0';
            elsif count = clk_div_bit / 2 - 1 then
                count <= 0;
                clk_enable <= not clk_enable;
            else
                count <= count + 1;
            end if;
        end if;
    end process div_clk;

    -- FSM de Transmissão ARINC 429
    FSM: process(clk)
    begin
        if rst = '1' then
            state <= idle;
            ATx_high <= '0';
            ATx_low <= '0';  
        elsif rising_edge(clk) then
            if clk_enable = '1' then  -- Só executa a cada 100 kHz
            case state is

                -- Aguarda um novo dado para transmitir
                when idle =>
                    if start_Tx = '1' then
                        state <= load_data;
                    end if;

                -- Carrega a palavra de 32 bits para envio
                when load_data =>
                    tx_word <= frame_label & sdi & data_in & ssm & '0';  -- Último bit reservado para a paridade
                    state <= parity_check;

    end process FSM;
    
end architecture;