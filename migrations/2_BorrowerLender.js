var borrowerLender = artifacts.require("../contracts/BorrowerLender.sol");


module.exports = function(deployer) {

  deployer.deploy(borrowerLender);

};
