var IconCrowdsaleContract = artifacts.require("./IconCrowdsaleContract.sol");

module.exports = function(deployer) {
    deployer.deploy(IconCrowdsaleContract,
        1514650804,
        1514658004,
        7000,
        3000000000000000000,
        5000000000000000000,
        "0x9957a3bca6d3e1f489195330d26911cb00356f6e");
};

// 1514248801, 1514253001, 7000, "3000000000000000000", "5000000000000000000", "0x9957a3bca6d3e1f489195330d26911cb00356f6e"
