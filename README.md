# Solidity payment channel
A simple payment channel that supports multiple deposits, extend contract time and dynamically change the payment size.
Contract live on ropsten at 0xa1cfe0c85d7e89221d1b870de107ba15cd3d9c11
https://ropsten.etherscan.io/address/0xa1cfe0c85d7e89221d1b870de107ba15cd3d9c11

# Usage
1. The owner will first deploy the contract, and send ether to the contract to be locked up for a year on default.
2. The owner will then invoke the setPayee function to set who can recieve the funds.
3. In an offline scenario, the owner uses their private key to sign a number "1", "2", or "3" representing the pay interval
For the payee, they can at any time submit one of these signed numbers and recieve pay, the pay interval is also recorded on the contract to prevent multiple pays.

# Functions deepdive
* (recieve / fallback) payment [Anyone]
  * This function is the deposit, anyone can deposit into the contract, however only the owner (employer) and the payee can extract value
* contractTime [Anyone]
  * This variable shows when the contract expires, after contract expires the owner can retrieve all funds locked within the contract
* payAmount [Anyone]
  * This variable is the pay intervals, the amount being paid per increment
* getBalance [Anyone]
  * Get the balance of the contract
* extendContract [Owner]
  * The owner can choose to extend the contract to continue the payment channel
* payDay [Payee]
  * This function can be invoked by the payee, it will take the owner's signed payment agreement and process it accordingly
* returnToOwner [Owner after contractTime expires]
  * This function will return all funds to the owner of the contract if the contract has expired
* setPayee [Owner]
  * This function allows the owner to set who is the payee of the contract
* updatePayAmount [Owner]
  * This function allows the owner to update how much pay each payment interval represents

# Notes
* All signed numbers could be done offline, and the payee can then just broadcast the number included with the signature to recieve payments.
 * To prevent the payee from broadcasting, per say, ```5, [signature]``` twice, the contract internally stores and subtracts the payment automatically.

* The owner could technically just set the payment interval to something smaller than previously agreed to, this is another problem that needs to be fixed. Maybe through a multi-sig method.

# Todo
* Reduce gas usage
* Use more safer programming practices
* Implement multi-sig on updatePayAmount
