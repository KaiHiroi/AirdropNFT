// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {ERC721} from "@openzeppelin/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/access/Ownable.sol";

import "forge-std/console2.sol";

contract AirdropNFT is ERC721, Ownable {
    string[] public tokenURIs;
    mapping(address minter => bool) public minters;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        tokenURIs.push("");
    }

    modifier onlyMinter() {
        require(minters[msg.sender], "You are not the eligible minter.");
        _;
    }

    function setMinters(address[] memory _minters) public onlyOwner {
        for (uint8 i; i < _minters.length;) {
            minters[_minters[i]] = true;
            unchecked {
                ++i;
            }
        }
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        return tokenURIs[tokenId];
    }

    function airdrop(address[] memory _recipients, string memory _tokenURI) public onlyMinter {
        uint256 _tokenIdsFrom = tokenURIs.length;
        for (uint8 i; i < _recipients.length;) {
            _mint(_recipients[i], _tokenIdsFrom + i);
            tokenURIs.push(_tokenURI);
            unchecked {
                ++i;
            }
        }
    }

}
