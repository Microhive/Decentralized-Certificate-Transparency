pragma solidity ^0.4.11;
contract EiMa {
    Certificate[] certificates;

    // Add a new certificate to chain.
    function addCertificate(string url, bytes32 _certSHA2) public returns (bool _allowed) {
        bool oldCertFound;
        uint256 oldCertId;
        Certificate oldCert;
        Certificate newCert;
        (oldCertFound, oldCertId, oldCert) = getCertificate(url);
        
        if(!oldCertFound) {
            newCert = new Certificate(url, _certSHA2, msg.sender, Certificate(0x0));
            certificates.push(newCert);
            return true;
        }
        else {
            newCert = new Certificate(url, _certSHA2, msg.sender, oldCert);
            certificates[oldCertId] = newCert;
        }
    }
    
    function getCertificate(string url) public view returns (bool, uint256, Certificate) {
        bytes32 hashedInput = keccak256(url);
        for(uint256 i = 0; i < certificates.length; i++) {
            if(certificates[i] != address(0) && certificates[i].getUrlHash() == hashedInput) {
                return (true, i, certificates[i]);
            }
        }
        return (false, 0, Certificate(0));
    }
    
    function transferOwnership(Certificate cert, address newOwner) public returns (bool _allowed) {
        if(msg.sender != cert.getOwner()) return false;
        cert.transferOwnership(newOwner);
        return true;
    }

}

contract Certificate {
    address owner;
    bytes32 certSHA2;
    bytes32 urlHash;
    Certificate prevCert;
    
    function Certificate(string url, bytes32 _certSHA2, address _owner, Certificate _prevCert) public payable {
        owner = _owner;
        certSHA2 = _certSHA2;
        urlHash = keccak256(url);
        prevCert = _prevCert;
    }
    
    function getUrlHash() public view returns (bytes32 _urlHash) {
        return urlHash;
    }
    
    function getOwner() public view returns (address _owner) {
        return owner;
    }
    
    function getPrevCert() public view returns (Certificate _prevCert) {
        return prevCert;
    }
    
    function transferOwnership(address _newOwner) public {
        if(msg.sender == owner) owner = _newOwner;
    }
}