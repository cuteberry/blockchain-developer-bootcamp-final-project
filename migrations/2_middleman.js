const MiddleMan = artifacts.require("MiddleMan");

module.exports = function (deployer) {
  deployer.deploy(MiddleMan);
};
