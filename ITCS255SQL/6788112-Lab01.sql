DROP DATABASE IF EXISTS Lab01_pokemon_db;
# DROP TABLE IF EXISTS Pokemon;
# DROP TABLE IF EXISTS Trainer;

-- Task 1
CREATE DATABASE IF NOT EXISTS Lab01_pokemon_db;

-- Task 2
USE Lab01_pokemon_db;

CREATE TABLE IF NOT EXISTS Trainer (
    trainerID       INT PRIMARY KEY,
    trainer_name    VARCHAR(50),
    hometown        VARCHAR(50),
    registered_date DATE
);

CREATE TABLE IF NOT EXISTS Pokemon (
    pokemonID      INT PRIMARY KEY,
    pokedex_number INT,
    pokemon_name   VARCHAR(50),
    height         DECIMAL(5, 2),
    weight         DECIMAL(5, 2),
    trainerID      INT,
    CONSTRAINT FK_trainerID FOREIGN KEY (trainerID) REFERENCES Trainer (trainerID)
);

-- Task 3
ALTER TABLE Pokemon
    ADD CONSTRAINT unique_pokedex_number UNIQUE (pokedex_number);

-- Task 4
ALTER TABLE Pokemon
    ADD CONSTRAINT pokedex_number CHECK (( `pokedex_number` > 0 ) AND ( `pokedex_number` <= 999 ));

-- Task 5
ALTER TABLE Trainer
    DROP COLUMN registered_date;

-- Task 6
ALTER TABLE Trainer
    CHANGE COLUMN hometown city VARCHAR(50);