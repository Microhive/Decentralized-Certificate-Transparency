pragma solidity ^0.4.18;

import "./certificate.sol";
import "./datastore.sol";

contract DCT {
    address owner;
    datastore dstore;
    uint16 version;

    function DCT(bool withDatastore) public {
        if(withDatastore)
            dstore = new datastore();
        else
            dstore = datastore(0x0);
        owner = msg.sender;
        version = 1;
    }

    /// Add a new certificate to chain.
    function addCertificate(string url, string _certificate) public returns (bool _allowed) {
        bytes32 hashedInput = keccak256(url);
        bytes32 certHash = sha256(_certificate);
        Certificate oldCert = dstore.get(hashedInput);

        if (oldCert == address(0x0)) {
            dstore.set(new Certificate(hashedInput, certHash, msg.sender, dstore.get(0)), hashedInput);
            return true;
        } else {
            if (oldCert.getOwner() == msg.sender) {
                dstore.set(new Certificate(hashedInput, certHash, msg.sender, oldCert), hashedInput);
                return true;
            }
        }
        return false;
    }
    
    function getCertificate(string url) public view returns (Certificate) {
        bytes32 hashedInput = keccak256(url);
        return dstore.get(hashedInput);
    }
    
    function transferOwnership(address _newOwner, Certificate _certificate) public returns (bool _allowed) {
        if (_certificate != address(0x0)) {
            if(_certificate.getOwner() == msg.sender) {
                dstore.set(new Certificate(_certificate.getUrlHash(), _certificate.getCertHash(), _newOwner, _certificate), _certificate.getUrlHash());
                return true;
            }
        }
        return false;
    }
    
    function upgradeContract(DCT _newAddress) public onlyOwner returns (datastore _dstore) {
        if(_newAddress.getVersion() > getVersion()) {
            dstore.transferOwnership(_newAddress);
            selfdestruct(_newAddress); // Transfer any remaining gas or ETH to the new contract before deletion.
            return dstore;
        }
        return datastore(0x0);
    }
    
    function importDatastore(datastore _dstore) public onlyOwner returns (bool _success) {
        if(dstore == address(0x0)) {
            dstore = _dstore;
            return true;
        }
        return false;
    }
    
    function getVersion() public view returns (uint16 _output) {
        return version;
    }
    
    // Only allow owner (DCT contract) to interact
    modifier onlyOwner {
        require(owner == msg.sender);
        _;
    }
}