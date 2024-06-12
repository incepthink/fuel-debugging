contract;

use std::{constants::ZERO_B256, hash::Hash};

storage {
    item_counter: u64 = 0,
    tokens: StorageMap<u64, Identity> = StorageMap {}
}

enum InvalidError {
    InvalidTokenId: u64,
    OnlyOwner: Identity,
    AuthError: Identity,
}

abi HashCaseNFTs {
    #[storage(write)]
    fn burn(id: u64);

    #[storage(read, write)]
    fn mint(to: Identity, metadata: str);
}

#[storage(read)]
fn _token_exists(id: u64) -> bool {
    let token_exists: bool = storage.tokens.get(id).try_read().is_some();
    if !token_exists {
        return false;
    }
    true
}

#[storage(read)]
fn _get_token_owner(id: u64) -> Identity {
    storage.tokens.get(id).try_read().unwrap_or(Identity::Address(Address::from(ZERO_B256)))
}

#[storage(read, write)]
fn _mint(to: Identity, metadata: str) {
    let new_token_index: u64 = storage.item_counter.read() + 1;
    storage.tokens.insert(new_token_index, to);
    storage.item_counter.write(new_token_index);
}

#[storage(write)]
fn _burn(id: u64) {
    storage.tokens.remove(id);
}

impl HashCaseNFTs for Contract {
    #[storage(write)]
    fn burn(id: u64) {
        require(_token_exists(id), InvalidError::InvalidTokenId(id));
        require(
            msg_sender()
                .unwrap() == _get_token_owner(id),
            InvalidError::AuthError(msg_sender().unwrap()),
        );
        _burn(id)
    }

    #[storage(read, write)]
    fn mint(to: Identity, metadata: str) {
        _mint(to, metadata);
    }
}
