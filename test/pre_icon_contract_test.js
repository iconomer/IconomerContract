var PreIconContract = artifacts.require('./PreIconContract.sol');

contract('PreIconContractTest', function(accounts) {
  it("should assert true", function(done) {
    var pre_icon_contract_test = PreIconContractTest.deployed();
    assert.isTrue(true);
    done();
  });
});
