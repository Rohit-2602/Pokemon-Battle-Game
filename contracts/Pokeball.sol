// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "./Pokemon.sol";

contract Pokeball is ERC1155, Ownable, VRFConsumerBaseV2 {
    mapping(uint256 => string) public tokenIdToTokenURI;
    mapping(uint256 => uint256) public tokenIdToTokenPrice;
    mapping(uint256 => uint256) public tokenIdToProbability;

    mapping(uint256 => address) public requestIdToSender;
    mapping(uint256 => uint256) public requestIdToTokenId;

    address vrfCoordinatorV2Address = address(0x7a1BaC17Ccc5b313516C5E16fb24f7659aA5ebed);
    VRFCoordinatorV2Interface public immutable vrfCoordinatorV2 = VRFCoordinatorV2Interface(vrfCoordinatorV2Address);
    uint64 private subscriptionId;
    bytes32 private immutable keyHash = bytes32(0x4b09e658ed251bcafeebbc69400383d49f344ace09b9576fe248bb02c003fe9f);
    uint32 private immutable callbackGasLimit = 500000;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;

    function setSubscriptionID(uint64 _subscriptionId) external onlyOwner {
        subscriptionId = _subscriptionId;
    }

    constructor() ERC1155("") VRFConsumerBaseV2(vrfCoordinatorV2Address) {}

    address public pokemonAddress;

    function setPokemonAddress(address _pokemonAddress) external onlyOwner {
        pokemonAddress = _pokemonAddress;
    }

    function buyPokeball(
        address to,
        uint256 id,
        uint256 amount
    ) external payable {
        require(id > 0 && id < 5, "Invalid TokenID");
        require(
            msg.value == tokenIdToTokenPrice[id] * amount,
            "Not enough value"
        );
        _mint(to, id, amount, "");
    }

    function openPokeball(address from, uint256 id, uint32 amount) external {
        _burn(from, id, uint256(amount));
        uint256 requestId = vrfCoordinatorV2.requestRandomWords(
            keyHash,
            subscriptionId,
            REQUEST_CONFIRMATIONS,
            callbackGasLimit,
            amount
        );
        requestIdToSender[requestId] = from;
        requestIdToTokenId[requestId] = id;
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] memory randomWords
    ) internal override {
        uint256 tokenId = requestIdToTokenId[requestId];
        uint256 probability = tokenIdToProbability[tokenId];
        for(uint256 i=0; i<randomWords.length; i++) {
            uint256 random = randomWords[i] % 10;
            if(probability >= random) {
                Pokemon(pokemonAddress).revealPokemon(randomWords[i], requestIdToSender[requestId]);
            }
        }
    }

    function uri(
        uint256 id
    ) public view virtual override returns (string memory) {
        return tokenIdToTokenURI[id];
    }

    function updateTokenUri(
        uint256 id,
        string memory tokenUri
    ) external onlyOwner {
        tokenIdToTokenURI[id] = tokenUri;
    }

    function updateTokenPrice(
        uint256 id,
        uint256 tokenPrice
    ) external onlyOwner {
        tokenIdToTokenPrice[id] = tokenPrice;
    }

    function updateTokenProbability(
        uint256 id,
        uint256 probability
    ) external onlyOwner {
        tokenIdToProbability[id] = probability;
    }
}
