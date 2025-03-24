
### Instructions for Using Auction

**Description:**  `Auction`  is a Solidity 0.7.5 contract for a Dutch Auction  
(also known as a reverse auction) on Ethereum or BNB Chain networks. Unlike an English auction, the price starts high  
and decreases over time until someone bids or the time runs out. It’s ideal for selling assets (NFTs, tokens, rights)  
with quick liquidity as of March 2025.  
**How it works:**  The owner sets the starting price, duration, and price decrement. Participants bid, and  
the first bid above the current price ends the auction. If no bids are placed, the owner can manually end it.  
**Advantages:**  Automatic price reduction, instant completion upon bidding, simplicity, and transparency.  
**What it offers:**  An efficient way to sell an asset at a fair market price.

**Compilation:**  Go to the "Deploy Contracts" page in BlockDeploy,  
paste the code into the "Contract Code" field (no external imports required),  
select Solidity version 0.7.5 from the dropdown menu,  
click "Compile" — the "ABI" and "Bytecode" fields will populate automatically.

**Deployment:**  In the "Deploy Contract" section:  
- Select the network (Ethereum Mainnet, BNB Chain),  
- Enter the private key of a wallet with ETH/BNB for gas in the "Private Key" field,  
- Specify constructor parameters: starting price (e.g., 1000000000000000000 for 1 ETH),  
duration in seconds (e.g., 86400 for 1 day), price decrement per second  
(e.g., 1000000000000000 for 0.001 ETH/sec),  
- Click "Deploy," review the network and fee in the modal window, and confirm.  
After deployment, you’ll get the contract address (e.g.,  `0xYourAuctionAddress`) in the BlockDeploy logs.

**How to Use Auction:**  

-   **Check Current Price:**  Call  `currentPrice`,  
    to see the price at that moment (it decreases over time).
-   **Place a Bid:**  Call  `bid`,  
    sending ETH greater than the current price (e.g., 0.8 ETH if the price is 0.75 ETH). The first bid ends the auction.
-   **Get Information:**  Use  `getAuctionInfo`,  
    to see the current leader, their bid, the price, end time, and status.
-   **End the Auction:**  If time runs out and there are no bids, the owner calls  
    `endAuction`  to claim the balance (if any).

**Example Workflow:**  
- The owner creates an auction with a starting price of 1 ETH, a 1-day duration (86400 sec), and a decrement of 0.00001 ETH/sec.  
- After 12 hours (43200 sec), the price drops to 0.568 ETH (1 - 43200 * 0.00001).  
- A participant bids 0.6 ETH via  `bid`, the auction ends, and they win.  
- The owner receives 0.6 ETH; previous bids (if any) are refunded.
