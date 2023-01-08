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

    event PokemonCatched(uint256 tokenId, PokemonBaseStats pokemonStats);
    event UpdatedTokenURI(uint256 tokenId, string tokenURI);

    address public pokeballAddress;

    function setPokeballAddress(address _pokeballAddress) external onlyOwner {
        pokeballAddress = _pokeballAddress;
    }

    modifier onlyPokeball {
        require(msg.sender == pokeballAddress, "Function can accessable to Pokeball Contract");
        _;
    }

    function revealPokemon(uint256 randomNumber, address _address) external onlyPokeball {
        _tokenId.increment();
        uint256 tokenId = _tokenId.current();
        string memory pokemonName = listOfPokemonNames[randomNumber % listOfPokemonNames.length];
        // 6 for HP, ATK, DEF, SATK, SDEF, Speed
        uint256[] memory randomIVs = generateRandomNumbers(6);
        PokemonBaseStats memory pokemonStats = pokemonNameToPokemonBaseStats[pokemonName];
        uint256 hpIV = randomIVs[0] % 31;
        uint256 attackIV = randomIVs[1] % 31;
        uint256 defenceIV = randomIVs[2] % 31;
        uint256 specialAttackIV = randomIVs[3] % 31;
        uint256 specialDefenceIV = randomIVs[4] % 31;
        uint256 speedIV = randomIVs[5] % 31;

        pokemonStats.hp += hpIV;
        pokemonStats.attack += attackIV;
        pokemonStats.defence += defenceIV;
        pokemonStats.specialAttack += specialAttackIV;
        pokemonStats.specialDefence += specialDefenceIV;
        pokemonStats.speed += speedIV;

        tokenIdToStats[tokenId] = pokemonStats;
        tokenIdToIvs[tokenId] = PokemonBaseStats(pokemonStats.pokemonName, pokemonStats.number, hpIV, attackIV, defenceIV, specialAttackIV, specialDefenceIV, speedIV, pokemonStats.types);
        tokenIdToEvs[tokenId] = PokemonBaseStats(pokemonStats.pokemonName, pokemonStats.number, 0, 0, 0, 0, 0, 0, pokemonStats.types);

        _safeMint(_address, tokenId);
        emit PokemonCatched(tokenId, pokemonStats);
    }

    function setTokenIdToTokenURI(uint256 tokenId, string memory _tokenURI) external onlyOwner {
        tokenIdToTokenURI[tokenId] = _tokenURI;
        emit UpdatedTokenURI(tokenId, _tokenURI);
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