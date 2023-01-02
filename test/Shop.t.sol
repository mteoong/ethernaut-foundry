pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/Shop/ShopHack.sol";
import "../src/Shop/ShopFactory.sol";
import "../src/Ethernaut.sol";

contract ShopTest is Test {
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contract
        ethernaut = new Ethernaut();
    }

    function testShopHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        ShopFactory shopFactory = new ShopFactory();
        ethernaut.registerLevel(shopFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(shopFactory);
        Shop ethernautShop = Shop(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Create ShopHack Contract
        ShopHack shopHack = new ShopHack(ethernautShop);

        // attack Shop contract.
        shopHack.attack();

        //////////////////////
        // LEVEL SUBMISSION //
        //////////////////////

        bool levelSuccessfullyPassed = ethernaut.submitLevelInstance(
            payable(levelAddress)
        );
        vm.stopPrank();
        assert(levelSuccessfullyPassed);
    }
}
