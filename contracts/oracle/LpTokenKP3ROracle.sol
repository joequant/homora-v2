pragma solidity 0.6.12;

import './BaseKP3ROracle.sol';
import '../Governable.sol';
import '../../interfaces/IBaseOracle.sol';
import '../../interfaces/IKeep3rV1Oracle.sol';
import '../../interfaces/IUniswapV2Factory.sol';

contract LpTokenKP3ROracle is IBaseOracle, BaseKP3ROracle, Governable {
  /// @dev Create the contract and initialize the first governor.
  /// @param _KP3R The keeper oracle smart contract.
  constructor(IKeep3rV1Oracle _KP3R) public BaseKP3ROracle(_KP3R) {
    Governable.initialize();
  }

  /// @dev Return the value of the given input as ETH per unit, multiplied by 2**112.
  /// @param token The LP ERC-20 token to check the value.
  function getETHPx(address token) external view override returns (uint) {
    address pair = IUniswapV2Factory(factory).getPair(token, weth);
    if (token < weth) {
      return price0TWAP(pair);
    } else {
      return price1TWAP(pair);
    }
  }
}
