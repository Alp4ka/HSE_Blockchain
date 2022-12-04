import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";

describe("RockPaperScissors", function(){

    async function getPlayers() {
        const [firstPlayer, secondPlayer] = await ethers.getSigners();
        return {firstPlayer, secondPlayer};
    }

    async function rpsContract() {
        const rpsFactory = await ethers.getContractFactory("RockPaperScissors");
        return await rpsFactory.deploy();
    }

    async function rpsCallerContract() {
        const rpsCallerFactory = await ethers.getContractFactory("RockPaperScissorsCaller");
        return await rpsCallerFactory.deploy();
    }


    describe("Register", function() {
        it("Should register first!", async function () {
            const rps = await loadFixture(rpsContract);
            const {firstPlayer} = await loadFixture(getPlayers);
            await rps.connect(firstPlayer).register();
            expect(await rps.firstPlayer()).is.eq(firstPlayer.address);
        })

        it("Can't register same user!", async function () {
            const rps = await loadFixture(rpsContract);
            const {firstPlayer} = await loadFixture(getPlayers);
            await rps.connect(firstPlayer).register();
            await expect(rps.connect(firstPlayer).register()).to.be.revertedWithoutReason();
        })

        it("Register second player!", async function () {
            const rps = await loadFixture(rpsContract);
            const {firstPlayer, secondPlayer} = await loadFixture(getPlayers);
            await rps.connect(firstPlayer).register();
            await rps.connect(secondPlayer).register();
            expect(await rps.firstPlayer()).is.eq(firstPlayer.address);
            expect(await rps.secondPlayer()).is.eq(secondPlayer.address);
        })
    })

    describe("Caller!", function() {

        it("Set address before call!", async function () {
            const rpsCaller = await loadFixture(rpsCallerContract);
            await expect(rpsCaller.register()).to.be.revertedWithoutReason();
        })

        it("Register with caller!", async function () {
            const rps = await loadFixture(rpsContract);
            const rpsCaller = await loadFixture(rpsCallerContract);
            await rpsCaller.setAddress(rps.address);
            await rpsCaller.register();
            expect(await rps.firstPlayer()).is.eq(rpsCaller.address);
        })
    })

})
