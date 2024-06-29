// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {TokenFactory} from "../src/TokenFactory.sol";
import {Token} from "../src/Token.sol";

contract TokenFactoryTest is Test {
    TokenFactory public factory;

    function setUp() public {
        factory = new TokenFactory();
    }

    // function test_createToken() public {
    //     string memory name = "My awesome token";
    //     string memory ticker = "MAK";
    //     address tokenAddress = factory.createToken(name, ticker);
    //     Token token = Token(tokenAddress);

    //     assertEq(token.balanceOf(address(factory)), factory.INITIAL_MINT());
    //     assertEq(token.totalSupply(), factory.INITIAL_MINT());
    //     assertEq(factory.tokens(tokenAddress), true);
    // }

    function test_CalculateRequiredEth() public {
        string memory name = "My awesome token";
        string memory ticker = "MAK";
        address tokenAddress = factory.createToken(name, ticker);
        Token token = Token(tokenAddress);
        uint totalBuyableSupply = factory.MAX_SUPPLY() - factory.INITIAL_MINT();
        uint requiredEth = factory.calculateRequiredEth(
            tokenAddress,
            totalBuyableSupply
        );

        assertEq(requiredEth, 30 * 10 ** 18);

        // 15000000000000000015000000000000000000 != 30000000000000000000
    }
}
