pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/utils/Strings.sol";

contract RockPaperScissors {
    event GameInitialized(address);

    event GameStarted(address);

    event GameFinished(address);

    event GamePhaseChanged(GamePhase);

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

    GamePhase public currentGamePhase;

    address public winner;
    address public firstPlayer;
    address public secondPlayer;


    address private owner;
    address private nullAddress;
    bytes32 private firstPlayerMoveEncrypted;
    bytes32 private secondPlayerMoveEncrypted;

    Move public firstPlayerMove;
    Move public secondPlayerMove;
    
    constructor() {
        owner = payable(msg.sender);
        restart();
    }

    modifier unregistered() {
        require(msg.sender != firstPlayer && msg.sender != secondPlayer);
        _;
    }

    modifier registered() {
        require(msg.sender == firstPlayer || msg.sender == secondPlayer);
        _;
    }

    modifier correctGamePhase(GamePhase phase) {
        require(currentGamePhase == phase);
        _;
    }
    
    modifier ableToRestart() {
        require(msg.sender == firstPlayer || msg.sender == secondPlayer || msg.sender == owner);
        _;
    }
    
    function register() public unregistered correctGamePhase(GamePhase.Preparation) returns (uint) {
        if (firstPlayer == address(0x0)) {
            firstPlayer = payable(msg.sender);
            emit GameInitialized(msg.sender);

            return 1;
        } 
        
        
        if (secondPlayer == address(0x0)) {
            secondPlayer = payable(msg.sender);
            emit GameStarted(msg.sender);

            changeGamePhase(GamePhase.Commit);
            return 2;
        }

        return 0;
    }

    function move(bytes32 move) public registered correctGamePhase(GamePhase.Commit) returns (bool) {
        bool result = false;
        if (msg.sender == firstPlayer && firstPlayerMoveEncrypted == 0x0) {
            firstPlayerMoveEncrypted = move;
            result = true;
        } else if (msg.sender == secondPlayer && secondPlayerMoveEncrypted == 0x0) {
            secondPlayerMoveEncrypted = move;
            result = true;
        }
        
        if (firstPlayerMoveEncrypted != 0x0 && secondPlayerMoveEncrypted != 0x0) {
            changeGamePhase(GamePhase.Reveal);
        }

        return result;
    }

    function reveal(Move element, uint32 salt) public registered correctGamePhase(GamePhase.Reveal) returns (address){
        require(firstPlayerMoveEncrypted != 0x0 && secondPlayerMoveEncrypted != 0x0);

        bytes32 encrypted = sha256(bytes.concat(bytes(Strings.toString(uint(element))), bytes(Strings.toString(salt))));

        if (element == Move.None) {
            return nullAddress;
        }

        if (msg.sender == firstPlayer && encrypted == firstPlayerMoveEncrypted) {
            firstPlayerMove = element;
        } else if (msg.sender == secondPlayer && encrypted == secondPlayerMoveEncrypted) {
            secondPlayerMove = element;
        } else {
            return nullAddress;
        }

        if (firstPlayerMove != Move.None || secondPlayerMove != Move.None) {
            if (firstPlayerMove == secondPlayerMove) {
                winner = nullAddress;
            }
            else if (
                (firstPlayerMove == Move.Scissors && secondPlayerMove == Move.Paper) || 
                (firstPlayerMove == Move.Paper && secondPlayerMove == Move.Rock) || 
                (firstPlayerMove == Move.Rock && secondPlayerMove == Move.Scissors) || (
                firstPlayerMove != Move.None && secondPlayerMove == Move.None)) {
                winner = firstPlayer;
            }
            else {
                winner = secondPlayer;
            }
        } else {
            winner = nullAddress;
        }

        emit GameFinished(winner);
        return winner;
    }

    function restart() public ableToRestart{
        nullAddress = address(0x0);
        
        winner = nullAddress;
        firstPlayer = nullAddress;
        secondPlayer = nullAddress;

        firstPlayerMoveEncrypted = 0x0;
        secondPlayerMoveEncrypted = 0x0;

        firstPlayerMove = Move.None;
        secondPlayerMove = Move.None;

        changeGamePhase(GamePhase.Preparation);
    }

    function changeGamePhase(GamePhase phase) private {
        currentGamePhase = phase;
        emit GamePhaseChanged(currentGamePhase);
    }
}