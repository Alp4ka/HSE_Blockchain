// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @title MyErc20Token
 * @dev Create a sample ERC20 standard token
 */
contract MyErc20Token is ERC20 {
    constructor(string memory tokenName, string memory tokenSymbol)
        ERC20(tokenName, tokenSymbol)
    {}

    function mint(address to, uint256 amount) external {
        _mint(to, amount);
    }
}
