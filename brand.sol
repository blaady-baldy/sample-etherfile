// SPDX-License-Identifier: MIT
 pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract brand is ERC721, Ownable{

    // uint256 public tokenCounter;
    address public creator;
    bool public isMintEnabled;
    uint256 public totalSupply;
    uint fee;
    uint maxSupply;

    // mapping(bytes32 => address) public tokenIdToSender;
    mapping(uint256 => string) public tokenIdToTokenURI;

    constructor()
    payable
    ERC721("Product", "PRD")
    {
 
        fee = 0.1 * 10 ** 18;
        totalSupply = 0;
        creator = msg.sender;
        isMintEnabled = true;
        maxSupply = 100;
    }








    function createCollectible(string memory tokenURI) 
        external payable{
        require(isMintEnabled, "Minting is not enabled");
        require(msg.value > fee, "Wrong Value");
        require(maxSupply > totalSupply, "Sold Out");

        totalSupply++;
        uint256 tokenId = totalSupply;
        tokenIdToTokenURI[tokenId] = tokenURI;
        _safeMint(msg.sender, tokenId);
    }

    function toggleMint() external onlyOwner {
        isMintEnabled = !isMintEnabled;
    }

    function setMaxSupply(uint256 _maxSupply) external onlyOwner{
        maxSupply = _maxSupply;
    }


    function transferOwnership(address _sender, uint256 _tokenID) public payable{
        if(msg.sender == creator){
            _safeMint(_sender, _tokenID);
        }
    }
    // function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
    //     require(
    //         _isApprovedOrOwner(_msgSender(), tokenId),
    //         "ERC721: transfer caller is not owner nor approved"
    //     );
    //     setTokenURI(tokenId, _tokenURI);
    // }
}
