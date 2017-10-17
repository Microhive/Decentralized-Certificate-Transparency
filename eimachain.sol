pragma solidity ^0.4.11;
contract EiMa {

    mapping(bytes32 => Certificate) certificates;
    
    function EiMa() public {
        
    }

    /// Add a new certificate to chain.
    function addCertificate(string url) public returns (bool _allowed) {
        bytes32 hashedInput = keccak256(url);
        Certificate oldCert = certificates[hashedInput];
        Certificate newCert = new Certificate(url, msg.sender);
        if(address(oldCert) == 0x0) {
            certificates[hashedInput] = newCert;
            return true;
        }
        else {
            while(!oldCert.isNewest()) oldCert = oldCert.getNextCert(); //Linked list loop
            if(oldCert.getOwner() == msg.sender)
                return oldCert.addCertificate(newCert);
            else
                return false;
        }
    }
    
    function getCertificate(string url) public view returns (Certificate _cert) {
        bytes32 hashedInput = keccak256(url);
        Certificate curCert = certificates[hashedInput];
        while(address(curCert) != 0x0 && !curCert.isNewest()) {
            curCert = curCert.getNextCert();
        }
        return curCert;
    }
    
    function transferOwnership(Certificate cert, address newOwner) public returns (bool _allowed) {
        if(msg.sender != cert.getOwner()) return false;
        cert.transferOwnership(newOwner);
        return true;
    }
    
    //function newCert(bytes32 certUrl) public returns (Certificate cert) { 
    //    cert = Certificate({url:certUrl, owner:msg.sender, newest:true, exist:true, newer:0});
    //}
}

contract Certificate {
    address owner;
    bytes32 urlHash;
    //bytes32 certHash; //For later use.
    bool newest = true;
    Certificate newerCert;
    
    function Certificate(string url, address _owner) public payable {
        owner = _owner;
        urlHash = keccak256(url);
    }
    
    function getCertHash() public view returns (bytes32 _urlHash) {
        return urlHash;
    }
    
    function getOwner() public view returns (address _owner) {
        return owner;
    }
    
    function isNewest() public view returns (bool _newest) {
        return newest;
    }
    
    function getNextCert() public view returns (Certificate _newerCert) {
        return newerCert;
    }
    
    function transferOwnership(address _newOwner) public {
        owner = _newOwner;
    }
    
    function addCertificate(Certificate _certificate) public returns (bool _allowed) {
        if(address(newerCert) == 0x0 && _certificate != this) {
            newest = false;
            newerCert = _certificate;
            return true;
        }
        return false;
    }
}