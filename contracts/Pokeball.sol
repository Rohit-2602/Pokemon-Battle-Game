// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Pokeball is ERC1155, Ownable {
    mapping(uint256 => string) public tokenIdToTokenURI;
    mapping(uint256 => uint256) public tokenIdToTokenPrice;

    constructor() ERC1155("") {}

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

    function burnPokeball(address from, uint256 id, uint256 amount) external {
        _burn(from, id, amount);
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
}
