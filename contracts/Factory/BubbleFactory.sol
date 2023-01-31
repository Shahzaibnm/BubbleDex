pragma solidity ^0.8.10;
// SPDX-License-Identifier: MIT

import "./interfaces/IBubblePair.sol";
import "./BubblePair.sol";

contract BubbleFactory {
    address public feeTo;
    address public feeToSetter;

    mapping(address => mapping(address => address)) public getPair;
    address[] public allPairs;

    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    constructor(
        address _feeToSetter,
        address _feeTo
    ) {
        feeToSetter = _feeToSetter;
        feeTo = _feeTo;
    }

    function allPairsLength() external view returns (uint256) {
        return allPairs.length;
    }

    function createPair(address tokenA, address tokenB)
        external
        returns (address pair)
    {
        require(tokenA != tokenB, "Bubble: IDENTICAL_ADDRESSES");
        (address token0, address token1) = tokenA < tokenB
            ? (tokenA, tokenB)
            : (tokenB, tokenA);
        require(token0 != address(0), "Bubble: ZERO_ADDRESS");
        require(getPair[token0][token1] == address(0), "Bubble: PAIR_EXISTS"); // single check is sufficient
        bytes memory bytecode = type(BubblePair).creationCode;
        bytes32 salt = keccak256(abi.encodePacked(token0, token1));
        assembly {
            pair := create2(0, add(bytecode, 32), mload(bytecode), salt)
        }
        IBubblePair(pair).initialize(token0, token1);
        getPair[token0][token1] = pair;
        getPair[token1][token0] = pair; // populate mapping in the reverse direction
        allPairs.push(pair);
        emit PairCreated(token0, token1, pair, allPairs.length);
    }

    function getInitHash() public pure returns (bytes32) {
        bytes memory bytecode = type(BubblePair).creationCode;
        return keccak256(abi.encodePacked(bytecode));
    }

    function setFeeTo(address _feeTo) external {
        require(msg.sender == feeToSetter, "Bubble: FORBIDDEN");
        feeTo = _feeTo;
    }

    function setFeeToSetter(address _feeToSetter) external {
        require(msg.sender == feeToSetter, "Bubble: FORBIDDEN");
        feeToSetter = _feeToSetter;
    }
}
