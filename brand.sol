// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@chainlink/contracts/src/v0.8/interfaces/KeeperCompatibleInterface.sol";
// import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol";


error NFT_decayed();
error Admin__UpkeepNotTrue();
error Admin__NoBrandAvailable();

contract brand is ERC721URIStorage, Ownable, KeeperCompatibleInterface{

    // uint256 public tokenCounter;
    address public creator;
    bool public isMintEnabled;
    uint256 public totalSupply;
    uint fee;
    uint maxSupply;
    uint256 private immutable day_interval;
    uint256 private s_currentTimeStamp;
    string public brandURI;
    // bool private isValid;

    struct Token{
        address owner;
        string tokenURI;
        uint256 warrantyPeriod;
        bool isValid;
    }

    Token[] private tokens;
    // mapping(uint256 => address) public tokenIdToOwner;
    // mapping(uint256 => string) public tokenIdToTokenURI;

    constructor(string memory _brandURI)
    payable
    ERC721("Product", "PRD")
    {
        brandURI = _brandURI;
        fee = 0.1 * 10 ** 18;
        totalSupply = 0;
        isMintEnabled = true;
        maxSupply = 100;
        creator = msg.sender;
    }

    function createCollectible(string memory _tokenURI, uint256 _warrantyPeriod) 
        external onlyOwner payable{
        require(isMintEnabled, "Minting is not enabled");
        require(msg.value > fee, "Wrong Value");
        require(maxSupply > totalSupply, "Sold Out");

        totalSupply++;
        uint256 tokenId = totalSupply;
        
        tokens.push(Token(msg.sender, _tokenURI, _warrantyPeriod, false));
        // warrantyPeriod[tokenId] = _warrantyPeriod;
        // _safeMint(msg.sender, tokenId);
        // _setTokenURI(tokenId, tokenURI);
    }

    function toggleMint() external onlyOwner {
        isMintEnabled = !isMintEnabled;
    }

    function setMaxSupply(uint256 _maxSupply) external onlyOwner{
        maxSupply = _maxSupply;
    }

    // function startWarrantyPeriod(uint256 tokenId, uint256 _warrantyPeriod) onlyOwner {
        
    // }


    function transferOwnership(address _sendTo, uint256 _tokenId) public payable{
        if(msg.sender == creator){
            tokens[tokenId].isValid = true;
        }
        if(tokens[tokenId].owner == msg.sender){
            tokens[tokenId].owner = _sendTO;
        }
    }

    function checkUpkeep(
        bytes memory /* checkData */
    )
        public
        view
        override
        returns (
            bool upkeepNeeded,
            bytes memory /* performData */
        )
    {
        upkeepNeeded = ((block.timestamp - s_currentTimeStamp) > i_interval);
        return (upkeepNeeded, "0x0");
    }

    function performUpkeep(
        bytes calldata /* performData */
    ) external override {
        (bool upkeepNeeded, ) = checkUpkeep("");

        if (!upkeepNeeded) revert Admin__UpkeepNotTrue();
        if (tokens.length == 0) revert Admin__NoBrandAvailable();
        if (!isValid) revert NFT_decayed();
        for (uint256 i = 0; i < tokens.length; i++) {
            tokens[i].warrantyPeriod -= 1;
            if (tokens[i].warrantyPeriod == 0) {
                tokens[i].isValid = false;
                // delete (tokens[i]);
            }
        }

        s_currentTimeStamp = block.timestamp;
    }

    // function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
    //     require(
    //         _isApprovedOrOwner(_msgSender(), tokenId),
    //         "ERC721: transfer caller is not owner nor approved"
    //     );
    //     setTokenURI(tokenId, _tokenURI);
    // }


}
