// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import {AirdropNFT} from "../src/AirdropNFT.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        address deployerAddress = vm.addr(deployerPrivateKey);
        address[] memory _minters = new address[](1);
        _minters[0] = deployerAddress;

        vm.startBroadcast(deployerPrivateKey);

        AirdropNFT nft = new AirdropNFT("SolidityHouse Accommodation Voucher", "SHAV");
        nft.setMinters(_minters);

        vm.stopBroadcast();
    }
}
