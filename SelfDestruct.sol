pragma solidity ^0.4.24;

contract SelfDest{
    

    address accountAdd;
    
   
       function selectAddress(address _add) {
            accountAdd = _add;         
            //To get the address you wish to remove
       }
       function removeContract() {
         require(accountAdd == msg.sender);
         selfdestruct(accountAdd); 
         //To remove the contract from the selected address
        }
        function viewAddress() view returns  (address){
            return(accountAdd); //This is to view which address will be destroyed or removed
        }
    

}



