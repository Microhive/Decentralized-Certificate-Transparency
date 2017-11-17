pragma solidity ^0.4.18;

import "./certificate.sol";

contract EiMaChain {

    mapping(bytes32 => uint256) pointers;
    Certificate[] certificates;

    function EiMaChain() public {
        certificates.push(Certificate(0x0));
    }

    /// Add a new certificate to chain.
    function addCertificate(string url) public returns (bool _allowed) {
        bytes32 hashedInput = keccak256(url);
        Certificate oldCert = certificates[pointers[hashedInput]];

        if (pointers[hashedInput] == 0) {
            pointers[hashedInput] = certificates.push(new Certificate(url, msg.sender, Certificate(0x0)));
            return true;
        } else {
            if (oldCert.getOwner() == msg.sender) {
                certificates[pointers[hashedInput]] = new Certificate(url, msg.sender, oldCert);
                return true;
            }
        }
        return false;
    }
    
    function getCertificate(string url) public view returns (Certificate) {
        bytes32 hashedInput = keccak256(url);
        return certificates[pointers[hashedInput]];
    }

    function transferOwnership(Certificate cert, address newOwner) public returns (bool _allowed) {
        if (msg.sender != cert.getOwner()) 
            return false;
        cert.transferOwnership(newOwner);
        return true;
    }
}
