// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

contract PokemonStorage is Ownable {
    mapping(string => PokemonBaseStats) public pokemonNameToPokemonBaseStats;
    mapping(string => PokemonMaxStats) public pokemonNameToPokemonMaxStats;
    mapping(string => string) public pokemonNameToPokemonImage;
    string[] public listOfPokemonNames;

    struct PokemonBaseStats {
        string pokemonName;
        uint256 number;
        uint256 hp;
        uint256 attack;
        uint256 defence;
        uint256 specialAttack;
        uint256 specialDefence;
        uint256 speed;
        string[] types;
    }

    struct PokemonMaxStats {
        string pokemonName;
        uint256 number;
        uint256 maxHp;
        uint256 maxAttack;
        uint256 maxDefence;
        uint256 maxSpecialAttack;
        uint256 maxSpecialDefence;
        uint256 maxSpeed;
    }

    function addPokemonBaseStats(
        PokemonBaseStats[] memory _PokemonBaseStats
    ) public onlyOwner {
        for (uint i = 0; i < _PokemonBaseStats.length; i++) {
            PokemonBaseStats memory pokemonBaseStats = _PokemonBaseStats[i];
            string memory _pokemonName = _PokemonBaseStats[i].pokemonName;
            pokemonNameToPokemonBaseStats[_pokemonName] = pokemonBaseStats;
            listOfPokemonNames.push(_pokemonName);
        }
    }

    function addPokemonMaxStats(
        PokemonMaxStats[] memory _PokemonMaxStats
    ) public onlyOwner {
        for (uint i = 0; i < _PokemonMaxStats.length; i++) {
            PokemonMaxStats memory pokemonMaxStats = _PokemonMaxStats[i];
            string memory _pokemonName = _PokemonMaxStats[i].pokemonName;
            pokemonNameToPokemonMaxStats[_pokemonName] = pokemonMaxStats;
        }
    }

    function addPokemonImages(
        string[] memory _pokemonName,
        string[] memory _pokemonImage
    ) public onlyOwner {
        require(_pokemonName.length == _pokemonImage.length, "Lenght should be same");
        for(uint256 i=0; i<_pokemonName.length; i++) {
            pokemonNameToPokemonImage[_pokemonName[i]] = _pokemonImage[i];
        }
    }

    function lengthOfListOfPokemonNames() public view returns (uint256) {
        return listOfPokemonNames.length;
    }
}
