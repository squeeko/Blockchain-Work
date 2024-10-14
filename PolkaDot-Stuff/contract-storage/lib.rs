#![cfg_attr(not(feature = "std"), no_std, no_main)]

#[ink::contract]
mod contract_storage {
    use ink::prelude::{format, string::String};

    #[ink(storage)]
    #[derive(Default)]
    pub struct ContractStorage;

    impl ContractStorage {
        #[ink(constructor)]
        pub fn new() -> Self {
            Self {}
        }

        /// Read from the contract storage slot, consuming all the data from the buffer.
        #[ink(message)]
        pub fn set_and_get_storage_all_data_consumed(&self) -> Result<(), String> {
            let key = 0u32;
            let value = [0x42; 32];
            ink::env::set_contract_storage(&key, &value);
            let loaded_value = ink::env::get_contract_storage(&key)
                .map_err(|e| format!("get_contract_storage failed: {:?}", e))?;
            assert_eq!(loaded_value, Some(value));
            Ok(())
        }

        /// Read from the contract storage slot, only partially consuming data from the
        /// buffer.
        #[ink(message)]
        pub fn set_and_get_storage_partial_data_consumed(&self) -> Result<(), String> {
            let key = 0u32;
            let value = [0x42; 32];
            ink::env::set_contract_storage(&key, &value);
            // Only attempt to read the first byte (the `u8`) of the storage value data
            let _loaded_value: Option<u8> = ink::env::get_contract_storage(&key)
                .map_err(|e| format!("get_contract_storage failed: {:?}", e))?;
            Ok(())
        }

        /// Read from the contract storage slot, only partially consuming data from the
        /// buffer.
        #[ink(message)]
        pub fn set_and_take_storage_partial_data_consumed(&self) -> Result<(), String> {
            let key = 0u32;
            let value = [0x42; 32];
            ink::env::set_contract_storage(&key, &value);
            // Only attempt to read the first byte (the `u8`) of the storage value data
            let _loaded_value: Option<u8> = ink::env::take_contract_storage(&key)
                .map_err(|e| format!("get_contract_storage failed: {:?}", e))?;
            Ok(())
        }
    }
}

/// This is how you'd write end-to-end (E2E) or integration tests for ink! contracts.
///
/// When running these you need to make sure that you:
/// - Compile the tests with the `e2e-tests` feature flag enabled (`--features e2e-tests`)
/// - Are running a Substrate node which contains `pallet-contracts` in the background
#[cfg(all(test, feature = "e2e-tests"))]
mod e2e_tests;
