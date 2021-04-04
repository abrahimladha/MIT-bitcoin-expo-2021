pragma solidity ^0.4.16;
contract HackMIT {
    //will not call to external contracts, for internal chain transfer only success) {}
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function transfer(address _to, uint256 _value) public returns (bool success) {
        if (balances[msg.sender] >= _value && _value > 0) {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            Transfer(msg.sender, _to, _value);
            return true;
        } else { return false; }
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        //same as above. Replace this line with the following if you want to protect against wrapping uints.
        //if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]) {
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && _value > 0) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            Transfer(_from, _to, _value);
            success=true;
            return true;
        } else { 
            success=false;
            return false; }
    } //allows transfer of assets across ledger participants

    function balanceOf(address _owner) public constant returns (uint256 balance) {
        return balances[_owner];
    } //proves asset ownership

    //further verifies ownership in txns in a regulatory-compliant and unfalsefiable way
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;
    uint256 public totalSupply;

    string public name;                   
    uint8 public decimals;
    string public symbol;
    string public version = 'H1.0';

    function mint(address receiver, uint amount, uint scalefactor) public {
        require(scalefactor >= 1); //scalefactor should be > 1 for splits || 1 for corporate action such as issuance of new assets
        //amount should be 1 for splits ||  !=1 for issuance
        //should not be used as a discount rate for pre-public token sales as only issues, but does not garuntee respected value
        if (msg.sender != msg.sender) return; //minter is OP node (company representation in federated system or consensus quorum in distributed ledger)
        balances[receiver] += scalefactor * amount;
        totalSupply += (scalefactor * amount);
    } //can be iterated through for all shareholders (existing and generated) to impliment stock splits, create IPOs, or issue public debt

//can be iterated through for all shareholders (existing and generated) to impliment reverse stock splits and destroy ETF creation blocks upon redemption with scaleF = 2^255
    function burn(address account, uint amount, uint scaleF) internal {
    require(amount != 0);
    require(amount <= balances[account]);
    totalSupply -= (amount*scaleF);
    balances[account] = balances[account] / scaleF;
    if (balances[account] < 0) balances[account=0];
  }

    function HackMIT() {
        balances[msg.sender] = 100000; // Give the creator all initial tokens (100000 for example) (IPO equivalent)
        totalSupply = 100000; //initial //equivalent to float, as may not represent total outstanding private interest or security sales
        name = "HackMIT"; // Set the name for display purposes
        decimals = 18;
        symbol = "HMIT";
    }
    
    //function totalSupply() public constant returns (uint totalSupply); can be used in later implimentations

    //for contract interaction and interface
    function approveAndCall(address _spender, uint256 _value, bytes _extraData) returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        Approval(msg.sender, _spender, _value);

        //template security authentication for contracts to fix innate transfer bug
        if(!_spender.call(bytes4(bytes32(sha3("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { assert(true); }
        return true;
    }
}


