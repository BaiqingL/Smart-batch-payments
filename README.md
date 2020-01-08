# Solidity-payment-channel
A simple payment channel that supports multiple deposits, extend contract time and dynamically change payment size.

# Usage
1. The owner will first deploy the contract, and send ether to the contract to be locked up for a year on default.
2. The owner will then invoke the setPayee function to set who can recieve the funds.
3. In an offline scenario, the owner uses their private key to sign a number "1", "2", or "3" representing the pay interval
For the payee, they can at any time submit one of these signed numbers and recieve pay, the pay interval is also recorded on the contract to prevent multiple pays.

# Functions deepdive
* (fallback) payment
  * This function is the deposit, anyone can deposit into the contract, however only the owner (employer) and the payee can extract value
* _balanceOfContract
  * This variable allows monitoring of contract balance
* contractTime
  * This variable shows when the contract expires, after contract expires the owner can retrieve all funds locked within the contract
* payAmount
  * This variable is the pay intervals, the amount being paid per increment
* extendContract
  * The owner can choose to extend the contract to continue the payment channel
* payDay
  * This function can be invoked by the payee, it will take the owner's signed payment agreement and process it accordingly
* returnToOwner
  * This function will return all funds to the owner of the contract if the contract has expired
* setPayee
  * This function allows the owner to set who is the payee of the contract
* updatePayAmount
  * This function allows the owner to update how much pay each payment interval represents

# Notes
* All signed numbers could be done offline, and the payee can then just broadcast the number included with the signature to recieve payments.
 * To prevent the payee from broadcasting, per say, ```5, [signature]``` twice, the contract internally stores and subtracts the payment automatically.
