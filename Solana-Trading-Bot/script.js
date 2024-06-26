require("dotenv").config();
const ccxt = require ('ccxt');

const apiUrlHist = `https://api.coingecko.com/api/v3/coins/solana/market_chart?vs_currency=usd&interval=daily&days=7&x_cg_demo_api_key=${process.env.COINGECKO_API_KEY}`;

const apiUrlCoinPrice = `https://api.coingecko.com/api/v3/simple/price?ids=solana&vs_currencies=usd&x_cg_demo_api_key=${process.env.COINGECKO_API_KEY}`;

const exchange = new ccxt.coinbase({
    apiKey: process.env.COINBASE_API_KEY,
    secret: process.env.COINBASE_SECRET_KEY
});
const symbol = "SOL/USD";
const type = "limit";
const side = "buy";
const amount = 5;

const run = async () => {
    let res, resJson;
    res = await fetch(
    apiUrlHist, 
    {
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        }
    }
);
resJson = await res.json();
resJson.prices.pop();
const average = resJson.prices.reduce((sum, el) => sum + el[1], 0) / resJson.prices.length; 

/*
console.log(resJson);
Here's the pricing for the last 7 days

{
  prices: [
    [ 1718841600000, 135.40309403154043 ],
    [ 1718928000000, 133.44256940911677 ],
    [ 1719014400000, 134.51329489326994 ],
    [ 1719100800000, 133.48608472760722 ],
    [ 1719187200000, 128.54028172949205 ],
    [ 1719273600000, 132.3377865818776 ],
    [ 1719360000000, 136.51374501335556 ]
  ],
*/
// console.log(average) // Use a spreadsheet to verify the average from your prices and remove the last price to get the average!

res = await fetch(
    apiUrlCoinPrice,
    {
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json'
        } 
    }
);
resJson = await res.json();
const currentPrice = resJson.solana.usd;

if (currentPrice > average) {
    const limitPrice = currentPrice & 1.02;
    const params = {
        stopLoss: {
            triggerPrice: currentPrice * 0.9
        },
        takeProfit: {
            triggerPrice: currentPrice * 1.3
        }
    };
    const order = await exchange.createOrder(symbol, type, side, amount, limitPrice, params);
    console.log(`Buy order created. ${amount} ${symbol} - Limit @ ${limitPrice} - Take profit @ ${params.takeProfit} - Stop Loss @ ${params.stopLoss}`);
    console.log(order);
    }   
}

const init  = setInterval(run, 86400 * 1000);
init