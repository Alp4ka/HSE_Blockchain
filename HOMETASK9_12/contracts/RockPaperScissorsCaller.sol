pragma solidity >=0.7.0 <0.9.0;


abstract contract RockPaperScissorsInterface {
    enum Move {
        None, 
        Rock, 
        Scissors, 
        Paper
    }

    enum GamePhase {
        Preparation,
        Commit,
        Reveal
    }

    function register() external virtual returns (uint);

    function reveal(Move element, uint32 salt) external virtual returns (address);

    function restart() external virtual;
}



contract RockPaperScissorsCaller {
    address public contractAddress;

    modifier addressSet() {
        require(contractAddress != address(0x0));
        _;
    }

  
    RockPaperScissorsInterface rpsinterface;

    function setAddress(address addr) public {
        contractAddress = addr;
        rpsinterface = RockPaperScissorsInterface(addr);

    }

    function register() public addressSet returns (uint) {
        return rpsinterface.register();
    }

    function reveal(RockPaperScissorsInterface.Move element, uint32 salt) public addressSet returns (address) {
        return rpsinterface.reveal(element, salt);
    }


    function restart() public addressSet {
        return rpsinterface.reset();
    }
}
