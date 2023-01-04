// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "./PokemonStorage.sol";

contract Pokemon is ERC721, PokemonStorage {
    using Counters for Counters.Counter;
    Counters.Counter public _tokenId;

    mapping(uint256 => string) tokenIdToTokenURI;

    mapping(uint256 => PokemonBaseStats) public tokenIdToStats;
    mapping(uint256 => PokemonBaseStats) public tokenIdToIvs;
    mapping(uint256 => PokemonBaseStats) public tokenIdToEvs;

    constructor() ERC721("Pokemon", "PKMN") {}

    function catchPokemon(string memory pokemonName) external {
        _tokenId.increment();
        uint256 tokenId = _tokenId.current();
        // 6 for HP, ATK, DEF, SATK, SDEF, Speed
        uint256[] memory randomIVs = generateRandomNumbers(6);
        PokemonBaseStats memory pokemonBaseStats = pokemonNameToPokemonBaseStats[pokemonName];
        uint256 hpIV = randomIVs[0] % 31;
        uint256 attackIV = randomIVs[1] % 31;
        uint256 defenceIV = randomIVs[2] % 31;
        uint256 specialAttackIV = randomIVs[3] % 31;
        uint256 specialDefenceIV = randomIVs[4] % 31;
        uint256 speedIV = randomIVs[5] % 31;

        pokemonBaseStats.hp += hpIV;
        pokemonBaseStats.attack += attackIV;
        pokemonBaseStats.defence += defenceIV;
        pokemonBaseStats.specialAttack += specialAttackIV;
        pokemonBaseStats.specialDefence += specialDefenceIV;
        pokemonBaseStats.speed += speedIV;

        tokenIdToStats[tokenId] = pokemonBaseStats;
        tokenIdToIvs[tokenId] = PokemonBaseStats(pokemonBaseStats.pokemonName, pokemonBaseStats.number, hpIV, attackIV, defenceIV, specialAttackIV, specialDefenceIV, speedIV, pokemonBaseStats.types);
        tokenIdToEvs[tokenId] = PokemonBaseStats(pokemonBaseStats.pokemonName, pokemonBaseStats.number, 0, 0, 0, 0, 0, 0, pokemonBaseStats.types);

        _safeMint(msg.sender, tokenId);
    }

    function generateRandomNumbers(uint256 n) public view returns(uint256[] memory randomNumbers) {
        randomNumbers = new uint256[](n);
        uint rand = uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, block.coinbase, msg.sender, block.number)));
        for(uint256 i=0; i<n; i++) {
            randomNumbers[i] = uint256(keccak256(abi.encodePacked(rand, i)));
        }
        return randomNumbers;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);
        return tokenIdToTokenURI[tokenId];
    }
}