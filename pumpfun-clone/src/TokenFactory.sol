// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import "./Token.sol";
import "../dependencies/@uniswap-v2-core-1.0.1/contracts/interfaces/IUniswapV2Factory.sol";
import "../dependencies/@uniswap-v2-periphery-1.1.0-beta.0/contracts/interfaces/IUniswapV2Router01.sol";
import "../dependencies/@uniswap-v2-periphery-1.1.0-beta.0/contracts/interfaces/IUniswapV2Router02.sol";
import "../dependencies/@uniswap-v2-core-1.0.1/contracts/interfaces/IUniswapV2Pair.sol";

contract TokenFactory {
    enum TokenState {
        NOT_CREATED,
        ICO,
        TRADING
    }
    uint public constant DECIMALS = 10 ** 18;
    uint public constant MAX_SUPPLY = (10 ** 9) * DECIMALS;
    uint public constant INITIAL_MINT = (MAX_SUPPLY * 20) / 100;
    uint public constant k = 46875;
    uint public constant offset = 18750000000000;
    uint public constant SCALING_FACTOR = 10 ** 21;
    uint public constant FUNDING_GOAL = 30 ether;
    address public constant UNISWAP_V2_FACTORY =
        0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f;
    address public constant UNISWAP_V2_ROUTER =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    mapping(address => TokenState) public tokens;
    mapping(address => uint) public collateral; // amount of ETH received for a token
    mapping(address => mapping(address => uint)) public balances; // token balances for people who bought tokens not released yet

    function createToken(
        string memory name,
        string memory ticker
    ) external returns (address) {
        Token token = new Token(name, ticker, INITIAL_MINT);
        tokens[address(token)] = TokenState.ICO;
        return address(token);
    }

    function buy(address tokenAddress, uint amount) external payable {
        require(
            tokens[tokenAddress] == TokenState.ICO,
            "Token doesn't exist or not available for ICO"
        );
        Token token = Token(tokenAddress);
        uint availableSupply = MAX_SUPPLY - INITIAL_MINT - token.totalSupply();
        require(amount <= availableSupply, "Not enough available supply");
        //calculate amount of ETH to buy
        uint requiredEth = calculateRequiredEth(tokenAddress, amount);
        require(msg.value >= requiredEth, "Not enough ETH");
        collateral[tokenAddress] += requiredEth;
        balances[tokenAddress][msg.sender] += amount;
        token.mint(address(this), amount);

        if (collateral[tokenAddress] >= FUNDING_GOAL) {
            address pool = _createLiquidityPool(tokenAddress);

            uint liquidity = _provideLiquidity(
                tokenAddress,
                INITIAL_MINT,
                collateral[tokenAddress]
            );

            _burnLpTokens(pool, liquidity);
        }
    }

    function withdraw(address tokenAddress, address to) external {
        require(
            tokens[tokenAddress] == TokenState.TRADING,
            "Token does not exist or hasn't reached funding goal yet"
        );
        uint balance = balances[tokenAddress][msg.sender];
        require(balance > 0, "No token to withdraw");
        balances[tokenAddress][msg.sender] = 0;
        Token token = Token(tokenAddress);
        token.transfer(to, balance);
    }

    function calculateRequiredEth(
        address tokenAddress,
        uint amount
    ) public view returns (uint) {
        // amount eth = (b - a) * (f(a) + f(b)) / 2
        Token token = Token(tokenAddress);
        uint b = token.totalSupply() - INITIAL_MINT + amount;
        uint a = token.totalSupply() - INITIAL_MINT;
        uint f_a = k * a + offset;
        uint f_b = k * b + offset;
        return (((b - a) * (f_a + f_b)) / 2) * SCALING_FACTOR;
    }

    function _createLiquidityPool(
        address tokenAddress
    ) internal returns (address) {
        Token token = Token(tokenAddress);
        IUniswapV2Factory factory = IUniswapV2Factory(UNISWAP_V2_FACTORY);
        IUniswapV2Router02 router = IUniswapV2Router02(UNISWAP_V2_ROUTER);
        address pair = factory.createPair(tokenAddress, router.WETH());
        return pair;
    }

    function _provideLiquidity(
        address tokenAddress,
        uint tokenAmount,
        uint ethAmount
    ) internal returns (uint) {
        Token token = Token(tokenAddress);
        IUniswapV2Router02 router = IUniswapV2Router02(UNISWAP_V2_ROUTER);
        token.approve(UNISWAP_V2_ROUTER, tokenAmount);
        (uint _amountToken, uint _amountETH, uint liquidity) = router
            .addLiquidityETH{value: ethAmount}(
            tokenAddress, // transferFrom() - delegated transfer, pull the ETH
            tokenAmount,
            tokenAmount,
            ethAmount,
            address(this),
            block.timestamp
        );
        return liquidity;
    }

    function _burnLpTokens(address poolAddress, uint amount) internal {
        IUniswapV2Pair pool = IUniswapV2Pair(poolAddress);
        pool.transfer(address(0), amount);
    }
}
