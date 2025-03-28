--
-- Description 
-- Author: Erick S. Dias
-- last update: 27/03/25

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity A429_Rx is
    generic(
        clk_freq : integer := 100_000_000;
    );
    port(
        clk, rst : in std_logic;
    );
end entity;

architecture main of A429_Rx is
begin
end architecture;