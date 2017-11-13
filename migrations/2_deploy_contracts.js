var PreIconContract = artifacts.require("./PreIconContract.sol");

module.exports = function(deployer) {
    deployer.deploy(PreIconContract,
        "0x9957a3bca6d3e1f489195330d26911cb00356f6e",
        "0x9957a3bca6d3e1f489195330d26911cb00356f6e",
        1509144421000,
        1511822821000,
        50000000000000000000000,
        100000000000000000000000,
        2500);
};
