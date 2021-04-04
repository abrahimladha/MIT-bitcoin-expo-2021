/*global ethereum, MetamaskOnboarding */

/*
The `piggybankContract` is compiled from:

  pragma solidity ^0.4.0;
  contract PiggyBank {

      uint private balance;
      address public owner;

      function PiggyBank() public {
          owner = msg.sender;
          balance = 0;
      }

      function deposit() public payable returns (uint) {
          balance += msg.value;
          return balance;
      }

      function withdraw(uint withdrawAmount) public returns (uint remainingBal) {
          require(msg.sender == owner);
          balance -= withdrawAmount;

          msg.sender.transfer(withdrawAmount);

          return balance;
      }
  }
*/

const forwarderOrigin = 'http://localhost:9010'

const initialize = () => {
  //You will start here
    const onboardButton = document.getElementById('connectButton');
    const isMetaMaskInstalled = () => {
        const {ethereum} = window;
        return Boolean(ethereum && ethereum.isMetaMask);
    };
    //const onboarding = new MetaMaskOnboarding({forwarderOrigin});
    const onClickInstall = () => {
        onboardButton.innerText = 'onboarding in progerss';
        onboardButton.disabled = true;
        //onboarding.startOnboarding();
    }
    const onClickConnect = async () => {
        try {
            await ethereum.request({method: 'eth_requestAccounts'});
        } catch (error) {
            console.error(error);
        }
    };
    const MetaMaskClientCheck = () => {
        if(!isMetaMaskInstalled()) {
            onboardButton.innerText = 'click me to install metamask lol';
            onboardButton.onclick = onClickInstall;
            onboardButton.disabled = false;
        } else {
            onboardButton.innerText = 'connect!11!';
            onboardButton.onclick = onClickConnect;
            onboardButton.disabled = false;
        }
    };
    MetaMaskClientCheck();
};
window.addEventListener('DOMContentLoaded', initialize)
