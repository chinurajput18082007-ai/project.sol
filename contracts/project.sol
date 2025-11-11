// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TicketSafe
 * @dev A simple smart contract for creating and managing event tickets securely on-chain.
 */
contract TicketSafe {
    address public owner;
    uint256 public nextTicketId;

    struct Ticket {
        uint256 id;
        address owner;
        string eventName;
        bool isUsed;
    }

    mapping(uint256 => Ticket) public tickets;

    event TicketCreated(uint256 ticketId, string eventName, address indexed owner);
    event TicketTransferred(uint256 ticketId, address indexed from, address indexed to);
    event TicketUsed(uint256 ticketId, address indexed owner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only contract owner can call this");
        _;
    }
// edit code

    modifier onlyTicketOwner(uint256 _ticketId) {
        require(tickets[_ticketId].owner == msg.sender, "You do not own this ticket");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /**
     * @notice Create a new event ticket.
     * @param _eventName The name of the event for which the ticket is issued.
     */
    function createTicket(string memory _eventName) external onlyOwner {
        tickets[nextTicketId] = Ticket(nextTicketId, msg.sender, _eventName, false);
        emit TicketCreated(nextTicketId, _eventName, msg.sender);
        nextTicketId++;
    }

    /**
     * @notice Transfer ticket ownership to another address.
     * @param _ticketId The ID of the ticket to transfer.
     * @param _to The address to which the ticket will be transferred.
     */
    function transferTicket(uint256 _ticketId, address _to) external onlyTicketOwner(_ticketId) {
        require(!tickets[_ticketId].isUsed, "Ticket already used");
        address previousOwner = tickets[_ticketId].owner;
        tickets[_ticketId].owner = _to;
        emit TicketTransferred(_ticketId, previousOwner, _to);
    }

    /**
     * @notice Mark a ticket as used for entry.
     * @param _ticketId The ID of the ticket to use.
     */
    function useTicket(uint256 _ticketId) external onlyTicketOwner(_ticketId) {
        require(!tickets[_ticketId].isUsed, "Ticket already used");
        tickets[_ticketId].isUsed = true;
        emit TicketUsed(_ticketId, msg.sender);
    }
}
