const BubbleRouter = artifacts.require("BubbleRouter");

module.exports = function(deployer) {

  deployer.deploy(BubbleRouter,"0x109D2cCE87b68A8330FEA7a3e26454f14bd5Ec88","0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6");
};