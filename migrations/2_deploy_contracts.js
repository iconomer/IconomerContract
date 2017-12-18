var PreIconContract = artifacts.require("./IconCrowdsaleContract.sol");

module.exports = function(deployer) {
    deployer.deploy(IconCrowdsaleContract,
        1513530001000,
        1513562401000,
        7000,
        3000000000000000000,
        5000000000000000000,
        "0x9957a3bca6d3e1f489195330d26911cb00356f6e");
};
