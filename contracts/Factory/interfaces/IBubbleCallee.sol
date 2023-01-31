pragma solidity ^0.8.9;
// SPDX-License-Identifier: MIT

interface IBubbleCallee {
    function BubbleCall(address sender, uint amount0, uint amount1, bytes calldata data) external;
}
