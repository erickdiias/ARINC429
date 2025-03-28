--
-- Description: Protocol ARINC 429 Data Transmission
-- Author: Erick S. Dias
-- last update: 27/03/25

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity A429_Tx is
    generic(
        clk_freq            : integer := 100_000_000;
        tranmssion_speed    : integer := 100_000;
        frame_label         : std_logic_vector(7 downto 0) := "01001111";
        sdi                 : std_logic_vector(1 downto 0) := "00"; -- 00-All Systems, 01-System1, 10-System2, 11-System3
        ssm                 : std_logic_vector(1 downto 0) := "00"  -- Normal
    );
    port(
        -- INPUT
        clk, rst            : in std_logic;
        start_Tx            : in std_logic; -- start of transmission signal
        data_in             : in std_logic_vector(18 downto 0);
        
        -- OUTPUT
        ATx_high            : out std_logic;
	    ATx_low             : out std_logic
    );
end entity;

architecture main of A429_Tx is
    constant clk_div: integer := clk_freq / tranmssion_speed;

    type state_A429 is (
        idle,           -- Aguarda um novo dado para transmitir
        load_data,      -- Carrega a palavra de 32 bits para envio
        send_bits,      -- Transmite cada bit conforme a condicao bipolar de return_to_zero(RZ)
        parity_check,   -- Calcula e adiciona o bit de paridade
        gap,            -- Mantem o espacamento entre palavras (min. 4 bits de tempo)
        done            -- Volta ao estado idle
    );
    signal state : state_A429 := idle;

    signal parity_bit : std_logic;
begin

    process(clk)
    begin
        if rst = '1' then
            state <= idle;
        elsif rising_edge(clk) then

            case state is
                when idle =>
                    if start_Tx = '1' then
                        state <= load_data;
                    end if;
                when load_data =>
                        
    end process;

end architecture;