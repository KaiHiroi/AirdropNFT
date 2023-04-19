// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/AirdropNFT.sol";

contract CounterTest is Test {
    AirdropNFT public nft;
    address eligibleAddr;
    address ineligibleAddr;

    function setUp() public {
        address deployer = makeAddr("DEPLOYER");
        eligibleAddr = makeAddr("ELIGIBLE");
        ineligibleAddr = makeAddr("INELIGIBLE");
        address[] memory minters = new address[](2);
        minters[0] = deployer;
        minters[1] = eligibleAddr;

        vm.startPrank(deployer);
        nft = new AirdropNFT("", "");
        nft.setMinters(minters);
        vm.stopPrank();

    }

    function test_Airdrop() public {
        uint256 numberOfRecipients = 50;

        address[] memory _recipients = new address[](numberOfRecipients);
        for (uint8 i; i < numberOfRecipients; ++i) {
            _recipients[i] = makeAddr(string(bytes(abi.encode(i))));
        }

        string memory _tokenURI = "https://gateway.pinata.cloud/ipfs/QmQieb9wDc5SuKpK1KWeqdCtgY7ztPKhij6oVEJFVj2Ggr";

        vm.prank(eligibleAddr);
        nft.airdrop(_recipients, _tokenURI);

        for (uint8 i; i < numberOfRecipients; ++i) {
            assertTrue(nft.ownerOf(i + 1) == _recipients[i]);
        }
    }

    function test_Fail_IneligibleMinter() public {
        uint256 numberOfRecipients = 5;

        address[] memory _recipients = new address[](numberOfRecipients);
        for (uint8 i; i < numberOfRecipients; ++i) {
            _recipients[i] = makeAddr(string(bytes(abi.encode(i))));
        }

        string memory _tokenURI = "https://gateway.pinata.cloud/ipfs/QmQieb9wDc5SuKpK1KWeqdCtgY7ztPKhij6oVEJFVj2Ggr";

        vm.prank(ineligibleAddr);
        vm.expectRevert("You are not the eligible minter.");
        nft.airdrop(_recipients, _tokenURI);
    }

}
