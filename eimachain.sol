pragma solidity ^0.4.11;
contract EiMa {

    mapping(bytes32 => Cert) certs;
    
    function EiMa() public {
        
    }

    /// Add a new certificate to chain.
    function addCertificate(string url) public {
        bytes32 hashedInput = keccak256(url);
        Cert certi = new Cert(url);
        certs[hashedInput] = certi;
        //if(!cert.exist()) {
        //    cert.getOwner = msg.sender;
        //    certs[hashedInput] = cert;
            
        //    return;
        //}
        //if(certs[hashedInput].owner != msg.sender) return;
        
        //Certificate memory curCert = cert.newer;
        //while(!curCert.newest) {
        //    curCert = getCertificate(curCert.newer);
        //}
        //curCert.newest = false;
        //curCert.newer = cert.url;
    }
    
    function getCertificate(string url) public view returns (Cert) {
        bytes32 hashedInput = keccak256(url);
        return certs[hashedInput];
    }
    
    //function transferOwnership(Certificate cert, address newOwner) public {
    //    if(msg.sender != cert.owner) return;
    //    cert.owner = msg.sender;
    //}
    
    //function newCert(bytes32 certUrl) public returns (Certificate cert) { 
    //    cert = Certificate({url:certUrl, owner:msg.sender, newest:true, exist:true, newer:0});
    //}
}

contract Cert {
    address owner;
    bytes32 urlHash;
    //bytes32 certHash; //For later use.
    bool exist;
    bool newest;
    address newerCert;
    
    function Cert(string url) public {
        owner = msg.sender;
        urlHash = keccak256(url);
        exist = true;
        newest = true;
    }
    
    function isExisting() public view returns (bool) {
        return exist;
    }
    
    function getCertHash() public view returns (bytes32) {
        return urlHash;
    }
}