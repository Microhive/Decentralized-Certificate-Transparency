pragma solidity ^0.4.11;
contract EiMa {
    //mapping(bytes32 => Certificate) localStore;
    Certificate[] certificates;
    
    function EiMa() public {
    }

    // Add a new certificate to chain.
    function addCertificate(string url) public returns (bool _allowed) {
        //bytes32 hashedInput = keccak256(url);
        bool oldCertFound;
        uint256 oldCertId;
        Certificate oldCert;
        Certificate newCert;
        (oldCertFound, oldCertId, oldCert) = getCertificate(url);
        
        if(!oldCertFound) {
            newCert = new Certificate(url, msg.sender, Certificate(0x0));
            //localStore[hashedInput] = newCert;
            certificates.push(newCert);
            return true;
        }
        else {
            newCert = new Certificate(url, msg.sender, oldCert);
            certificates[oldCertId] = newCert;
            //localStore[hashedInput] = newCert;
        }
    }
    
    function getCertificate(string url) public view returns (bool, uint256, Certificate) {
        bytes32 hashedInput = keccak256(url);
        //if(localStore[hashedInput] != address(0)) return (true, uint256(0), localStore[hashedInput]);
        for(uint256 i = 0; i < certificates.length; i++) {
            if(certificates[i] != address(0) && certificates[i].getUrlHash() == hashedInput) {
                //localStore[hashedInput] = curCert;
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
    bytes32 urlHash;
    //bytes32 certHash; //For later use.
    Certificate prevCert;
    
    function Certificate(string url, address _owner, Certificate _prevCert) public payable {
        owner = _owner;
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
        owner = _newOwner;
    }
}