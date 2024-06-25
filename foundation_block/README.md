Blockchain-Foundation

These are the commands to run operations on the blockchain

blockchain_rust 0.1.0

USAGE:
    foundation_block <SUBCOMMAND>

FLAGS:
    -h, --help       Prints help information
    -V, --version    Prints version information

SUBCOMMANDS:
    createblockchain    Create a new blockchain
    createwallet        Create a new wallet
    getbalance          Get the wallet balance of the target address
    help                Prints this message or the help of the given subcommand(s)
    listaddresses       Print local wallet addres
    printchain          Print blockchain all block
    reindexutxo         rebuild UTXO index set
    send                Add new block to chain
    startnode           Start a node

    Examples: cargo run --bin foundation_block createwallet -> Your new address: <Wallet address>

    cargo run --bin foundation_block createblockchain <Wallet address> -> Mining the block
    009f8295e90cd3f8b10b14e4d81fe9ca011b80177d6d3c089cca764c43fd6ebe

    Done!

    cargo run --bin foundation_block getbalance <Wallet address> -> Balance of <Wallet address>: 10
