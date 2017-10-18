pragma solidity ^0.4.11;
contract EiMa {

    mapping(bytes32 => Certificate) certificates;

    /// Add a new certificate to chain.
    function addCertificate(string url) public returns (bool _allowed) {
        bytes32 hashedInput = keccak256(url);
        Certificate oldCert = certificates[hashedInput];
        Certificate newCert = new Certificate(url, msg.sender, oldCert);
        if(address(oldCert) == 0x0) {
            certificates[hashedInput] = newCert;
            return true;
        }
        else {
            if(oldCert.getOwner() == msg.sender) {
                certificates[hashedInput] = newCert;
                return true;
            }
            return false;
        }
    }
    
    function getCertificate(string url) public view returns (Certificate) {
        bytes32 hashedInput = keccak256(url);
        return certificates[hashedInput];
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
    Certificate prevCert;
    
    function Certificate(string url, address _owner, Certificate _prevCert) public payable {
        owner = _owner;
        urlHash = keccak256(url);
        prevCert = _prevCert;
    }
    
    function getCertHash() public view returns (bytes32 _urlHash) {
        return urlHash;
    }
    
    function getOwner() public view returns (address _owner) {
        return owner;
    }
    
    function getPrevCert() public view returns (Certificate _prevCert) {
        return prevCert;
    }
    
    function transferOwnership(address _newOwner) public {
        owner = _newOwner;
    }
}