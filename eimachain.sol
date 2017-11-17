pragma solidity ^0.4.18;

import "./certificate.sol";

contract EiMaChain {

    mapping(bytes32 => uint256) pointers;
    Certificate[] certificates;

    function EiMaChain() public {
        certificates.push(Certificate(0x0));
    }

    /// Add a new certificate to chain.
    function addCertificate(string url, string _certificate) public returns (bool _allowed) {
        bytes32 hashedInput = keccak256(url);
        bytes32 certHash = keccak256(_certificate);
        uint256 index;
        Certificate oldCert = certificates[pointers[hashedInput]];

        if (pointers[hashedInput] == 0) {
            index = certificates.push(new Certificate(url, certHash, msg.sender, certificates[0])) - 1;
            pointers[hashedInput] = index;
            return true;
        } else {
            if (oldCert.getOwner() == msg.sender) {
                index = pointers[hashedInput];
                certificates[index] = new Certificate(url, certHash, msg.sender, oldCert);
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
