const MiddleMan = artifacts.require("MiddleMan");

/*
 * uncomment accounts to access the test accounts made available by the
 * Ethereum client
 * See docs: https://www.trufflesuite.com/docs/truffle/testing/writing-tests-in-javascript
 */

contract("MiddleMan", function (accounts) {
  const [contractOwner, alice, jeff] = accounts;
  const deposit = web3.utils.toBN(2);
  const zero = web3.utils.toBN(0);

  beforeEach(async () => {
    instance = await MiddleMan.new();
  });

  it("ready to be solved!", async() => {
    const eth100 = 100e18;
    assert.equal(await web3.eth.getBalance(alice), eth100.toString());
  });


  it("is owned by owner", async () => {
    assert.equal(
      // Hint:
      //   the error `TypeError: Cannot read property 'call' of undefined`
      //   will be fixed by setting the correct visibility specifier. See
      //   the following two links
      //   1: https://docs.soliditylang.org/en/v0.8.5/cheatsheet.html?highlight=visibility#function-visibility-specifiers
      //   2: https://docs.soliditylang.org/en/v0.8.5/contracts.html#getter-functions
      await instance.owner.call(),
      contractOwner,
      "owner is not correct",
    );
  });

  it("should mark addresses as enrolled", async () => {
    await instance.enroll({ from: alice });

    const aliceEnrolled = await instance.enrolled(alice, { from: alice });
    assert.equal(
      aliceEnrolled,
      true,
      "sender is not enrolled",
    );
  });

  it("should not mark unenrolled users as enrolled", async () => {
    const ownerEnrolled = await instance.enrolled(contractOwner, { from: contractOwner });
    assert.equal(
      ownerEnrolled,
      false,
      "only enrolled users should be marked enrolled",
    );
  });

  it("should withold correct amount for receiver from sender", async () => {
    await instance.enroll({ from: alice });
    await instance.withhold(jeff, { from: alice, value: deposit});
    const balance = await instance.getBalanceForReceiver.call(jeff, { from: alice });

    assert.equal(
      deposit.toString(),
      balance,
      "withold amount incorrect, check deposit method",
    );
  });

  it("should distribute to receiver with right amount", async () => {
    await instance.enroll({ from: alice });
    await instance.withhold(jeff, { from: alice, value: deposit});
    await instance.distributeToReceiver(jeff, { from: alice});

    const balance = await instance.getBalanceForReceiver.call(jeff, { from: alice });

    assert.equal(
      zero.toString(),
      balance,
      "distrubution amount incorrect, check distributeToReceiver method",
    );
  });


  it("should refund to sender with right amount", async () => {
    await instance.enroll({ from: alice });
    await instance.withhold(jeff, { from: alice, value: deposit});
    await instance.refundSender(jeff, { from: alice});

    const balance = await instance.getBalanceForReceiver.call(jeff, { from: alice });

    assert.equal(
      zero.toString(),
      balance,
      "distrubution amount incorrect, check distributeToReceiver method",
    );
  });
});

