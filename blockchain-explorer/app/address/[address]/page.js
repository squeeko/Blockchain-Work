require("dotenv").config();
import { ethers } from "ethers";
import tokenJson from "../../token.json";

const infuraURL = `https://mainnet.infura.io/v3/${process.env.INFURA_API_KEY}`
const getBalance = async address => {
    const res = await fetch(
        infuraURL,
        {
        method: 'POST',
        headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
            },
            body: JSON.stringify({
                jsonrpc:"2.0",
                method: "eth_getBalance",
                params: [address, "latest"],
                id: 1
            })
        }
    );
    const resJson = await res.json();
    return resJson.result;
}

const getTokenBalance = async (tokenAddress, wallet) => {
    const provider = new ethers.JsonRpcProvider(infuraURL);
    const token = new ethers.Contract(tokenAddress, tokenJson.abi, provider);
    const res = await token.balanceOf(wallet);
    return res;
}



export default async function Address({params}) {
    const balance = await getBalance(params.address);
    const usdcBalance = await getTokenBalance(tokenJson.usdcAddress, params.address);
    console.log(ethers.formatUnits(usdcBalance, 6));
   
    return (
        <main id="main">
          <h1 id="title">ETB Blockchain Explorer</h1>
          <div id="header">
            The Etherum Blockchain Explorer by EatTheBlocks
          </div>
    
          <div id="content">
            <div id ="address">
                <div className="field">
                    <div className="name">Address:</div>
                    <div className="value">{params.address}</div>
                </div>
                <div className="field">
                    <div className="name">ETH Balance:</div>
                    <div className="value">{ethers.formatEther(balance)} ETH</div>
                </div>
                <div className="field">
                    <div className="name">USDC Balance:</div>
                    <div className="value">{ethers.formatUnits(usdcBalance, 6)} USDC</div>
                </div>
            </div>
            </div>
        
        </main>
      );
      
}