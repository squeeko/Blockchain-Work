pub fn create_blockchain(genesis_address: &str) -> Blockchain {
    let db = sled::open(current_dir().unwrap().join("data")).unwrap();
    let blocks_tree = db.open_tree(BLOCKS_TREE).unwrap();
    let data = blocks_tree.get(TIP_BLOCK_HASH_KEY).unwrap();
    let tip_hash;
    if data.is_none() {
        let coinbase_tx = Transaction::new_coinbase_tx(genesis_address);
    }
}
