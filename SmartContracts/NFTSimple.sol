// Kalytn IDE users solidity 0.4.24, 0.5.6 versions.
pragma solidity >=0.4.24 <=0.5.6;

contract NFTSimple {
    string public name = "KlayBooks";
    string public symbol = "KB";
    
    mapping (uint256 => address) public tokenOwner;
    mapping (uint256 => string) public tokenURIs;

    // 소유한 토큰 리스트
    mapping(address => uint256[]) private _ownedTokens;
    // onKIP17Received bytes value
    bytes4 private constant _KIP17_RECEIVED = 0x6745782b;

    ///////////////////////////////////////////////////////

    mapping (uint256 => address) public tokenLender;
    mapping (uint256 => string) private contentsURIs;
    
    mapping(address => uint256[]) private _lendedTokens;
    
    ///////////////////////////////////////////////////////

    function mintWithTokenURI(address to, uint256 tokenId, string memory tokenURI) public returns (bool) {
        // to 에게 tokenId(일련번호)를 발행한다.
        // 적힐 글자는 tokenURI
        tokenOwner[tokenId] = to;
        tokenURIs[tokenId] = tokenURI;
        
        // 적힐 글자는 실제 컨텐츠의 <CID> --> ex) "ipfs://..."
        contentsURIs[tokenId] = contentsURI;

        // add token to the list
        _ownedTokens[to].push(tokenId);
    }
    

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
        require(from == msg.sender, "from != msg.sender");
        require(from == tokenOwner[tokenId], "you are not the owner of the token");
        //
        _removeTokenFromList(from, tokenId);
        _ownedTokens[to].push(tokenId);
        //
        tokenOwner[tokenId] = to;

        // 만약에 받는 쪽이 실행할 코드가 있는 스마트 컨트랙트라면 코드를 실행할 것.
        require(
            _checkOnKIP17Received(from, to, tokenId, _data), "KIP17 : transfer to non KIP17Receiver implementer"
        );
    }
    
    function safeLendingFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
        require(from == msg.sender, "from != msg.sender");
        require(from == tokenOwner[tokenId], "you are not the owner of the token");
        require(from != tokenLender[tokenId], "you are already lended");
        //

        _lendedTokens[to].push(tokenId);
        //
        tokenLender[tokenId] = to;

    }

    function _checkOnKIP17Received(address from, address to, uint256 tokenId, bytes memory _data) internal returns (bool) {
        bool success;
        bytes memory returndata;

        if (!isContract(to)) {
            return true;
        }

        (success, returndata) = to.call(
            abi.encodeWithSelector(
                _KIP17_RECEIVED,
                msg.sender,
                from,
                tokenId,
                _data
            )
        );
        if(
            returndata.length != 0 &&
            abi.decode(returndata, (bytes4)) == _KIP17_RECEIVED
        ) {
            return true;
        }
        return false;
    }

    function isContract(address account) internal view returns (bool) {
        uint256 size;
        assembly { size := extcodesize(account) }
        return size > 0;
    }

    function _removeTokenFromList(address from, uint256 tokenId) private {
        // [10, 15, 19, 20] --> 19번 삭제 하고 싶어요.
        // [10, 15, 20, 19]
        // [10, 15, 20]
        uint256 lastTokenIdex = _ownedTokens[from].length - 1;
        for(uint256 i=0;i<_ownedTokens[from].length;i++){
            if (tokenId == _ownedTokens[from][i]) {
                // Swap last token with deleting token;
                _ownedTokens[from][i] = _ownedTokens[from][lastTokenIdex];
                _ownedTokens[from][lastTokenIdex] = tokenId;
                break;
            }
        }
        _ownedTokens[from].length--;
    }

    function ownedTokens(address owner) public view returns (uint256[] memory) {
        return _ownedTokens[owner];
    }

    function setTokenURI(uint256 id, string memory uri) public {
        tokenURIs[id] = uri;
    }
    
    function getContents(address from, uint256 tokenId) public view returns (string memory) {

        require(tokenLender[tokenId] == from || tokenOwner[tokenId] == from, "You don't have permmission");     

        return contentsURIs[tokenId];
    }
    
    
}

contract NFTMarket {
    mapping(uint256 => address) public seller;
    mapping(uint256 => address) public lender;

    function buyNFT(uint256 tokenId, address NFTAddress) public payable returns (bool) {
        // 구매한 사람한테 0.01 KLAY 전송
        address payable receiver = address(uint160(seller[tokenId]));
        
        // Send 0.01 KLAY ot receiver
        // 10 ** 18 PEB = 1 KLAY
        // 10 ** 16 PEB = 0.01 KLAY
        receiver.transfer(10 ** 16);

        NFTSimple(NFTAddress).safeTransferFrom(address(this), msg.sender, tokenId, '0x00');

        return true;
    }
    
    function rentalNFT(uint256 tokenId, address NFTAddress) public payable returns (bool) {
        require(msg.sender != seller[tokenId], "You are the seller");
        // 구매한 사람한테 0.01 KLAY 전송
        address payable receiver = address(uint160(seller[tokenId]));

        // Send 0.01 KLAY ot receiver
        // 10 ** 18 PEB = 1 KLAY
        // 10 ** 16 PEB = 0.01 KLAY
        receiver.transfer(10 ** 16);

        NFTSimple(NFTAddress).safeLendingFrom(address(this), msg.sender, tokenId, '0x00');

        lender[tokenId] = msg.sender;

        return true;
    }
    

    // Market이 토큰을 받았을 때(판매대에 올라갔을 때), 판매자가 누구인지 기록해야함
     function onKIP17Received(address operator, address from, uint256 tokenId, bytes memory data) public returns (bytes4) {
        // Set token seller, who was a token owner
        seller[tokenId] = from;

        // return signature which means this contract implemented interface for ERC721
        return bytes4(keccak256("onKIP17Received(address,address,uint256,bytes)"));
    }

}
