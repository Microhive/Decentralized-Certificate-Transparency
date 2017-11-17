pragma solidity ^0.4.18;

import "./certificate.sol";

contract EiMaChain {

    mapping(bytes32 => Certificate) certificates;

    /// Add a new certificate to chain.
    function addCertificate(string url) public returns (bool _allowed) {
        bytes32 hashedInput = keccak256(url);
        Certificate oldCert = certificates[hashedInput];
        Certificate newCert = new Certificate(url, msg.sender, oldCert);
        if (address(oldCert) == 0x0) {
            certificates[hashedInput] = newCert;
            return true;
        } else {
            if (oldCert.getOwner() == msg.sender) {
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
        if (msg.sender != cert.getOwner()) 
            return false;
        cert.transferOwnership(newOwner);
        return true;
    }
}
