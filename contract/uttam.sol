pragma solidity ^0.8.0;

contract GratitudeJournalNFT {
    struct ArtNFT {
        uint256 id;
        string name;
        string metadata;
        address owner;
        bool forSale;
        uint256 price;
    }

    mapping(uint256 => ArtNFT) public nfts;
    mapping(address => uint256[]) public ownerNFTs;
    uint256 public nextId;
    
    event NFTCreated(uint256 id, string name, address owner);
    event NFTTransferred(uint256 id, address from, address to);
    event NFTListed(uint256 id, uint256 price);
    event NFTSold(uint256 id, address buyer, uint256 price);
    
    function createNFT(string memory _name, string memory _metadata) public {
        nfts[nextId] = ArtNFT(nextId, _name, _metadata, msg.sender, false, 0);
        ownerNFTs[msg.sender].push(nextId);
        emit NFTCreated(nextId, _name, msg.sender);
        nextId++;
    }

    function transferNFT(uint256 _id, address _to) public {
        require(nfts[_id].owner == msg.sender, "Not the owner");
        nfts[_id].owner = _to;
        emit NFTTransferred(_id, msg.sender, _to);
    }
    
    function listNFT(uint256 _id, uint256 _price) public {
        require(nfts[_id].owner == msg.sender, "Not the owner");
        require(_price > 0, "Price must be greater than zero");
        nfts[_id].forSale = true;
        nfts[_id].price = _price;
        emit NFTListed(_id, _price);
    }
    
    function buyNFT(uint256 _id) public payable {
        require(nfts[_id].forSale, "Not for sale");
        require(msg.value >= nfts[_id].price, "Insufficient funds");
        address seller = nfts[_id].owner;
        payable(seller).transfer(msg.value);
        nfts[_id].owner = msg.sender;
        nfts[_id].forSale = false;
        emit NFTSold(_id, msg.sender, msg.value);
    }
}
