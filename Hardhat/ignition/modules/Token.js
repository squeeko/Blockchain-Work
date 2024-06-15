const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

const TokenModule = buildModule("TokenModule", (m) => {
  const token = m.contract("Token");

  
  m.call(token, "transfer", ['0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266', 20])

  return { token };
});

module.exports = TokenModule;