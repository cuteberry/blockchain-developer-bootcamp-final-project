const ContractRegister = artifacts.require("ContractRegister");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */

contract("ContractRegister", function (accounts) {
  const [contractOwner, backendContract1, backendContract2, test] = accounts;

  beforeEach(async () => {
    instance = await ContractRegister.new();
  });

  it("is owned by owner", async () => {
    assert.equal(
      await instance.getOwner.call(),
      contractOwner,
      "owner is not correct",
    );
  });

  it("should mark backendContract1 when it's from contractOwner", async () => {
    const changed = await instance.changeBackend.call(backendContract1, { from: contractOwner });
    console.log(changed);
    assert.equal(
      changed,
      true,
      "should change backendContract to backendContract1",
    );
  });


  it("should not mark backendContract1 when it's same contract from contractOwner", async () => {

    await instance.changeBackend(backendContract1, { from: contractOwner });
    const changed = await instance.changeBackend.call(backendContract1, { from: contractOwner });
    assert.equal(
      changed,
      false,
      "should not change backendContract",
    );
  });


  it("should mark backendContract2 when it's from contractOwner", async () => {

    await instance.changeBackend(backendContract1, { from: contractOwner });
    const changed = await instance.changeBackend.call(backendContract2, { from: contractOwner });
    assert.equal(
      changed,
      true,
      "should mark backendContract to backendContract2",
    );
  });

  it("should not mark backendContract2 when it's not from contractOwner", async () => {

    await instance.changeBackend(backendContract1, { from: contractOwner });
    try{
      const changed = await instance.changeBackend.call(backendContract2, { from: test });
    } catch (error) {
      const invalidOwner = error.message.search('revert') >= 0;
      assert(
        invalidOwner,
        "Expected throw, got '" + error + "' instead",
      );
      return;
    }
    assert.fail('Expected throw not received'); 
  });
});

