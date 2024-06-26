module aresrpg::fud {
    use sui::coin::{Self, TreasuryCap};
    use sui::url;

    public struct Registry has key{
        id: UID,
        treasury_cap: TreasuryCap<FUD>
    }

    public struct FUD has drop {}

    fun init(witness: FUD, ctx: &mut TxContext) {
        let (treasury_cap, coin_metadata) = coin::create_currency(
            witness,
            9,
            b"FUD",
            b"Test FUD",
            b"FUD tokens minted for testing purposes.",
            option::some(url::new_unsafe_from_bytes(b"https://raw.githubusercontent.com/Sceat/coin-faucet/master/assets/fud.jpg")),
            ctx
        );

        let registry =  Registry {
            id: object::new(ctx),
            treasury_cap
        };

        transfer::public_share_object(coin_metadata);
        transfer::share_object(registry);
    }

    public entry fun mint(registry: &mut Registry, value: u64, ctx: &mut TxContext) {
        assert!(value < 100000000000, 101);
        coin::mint_and_transfer(&mut registry.treasury_cap, value, tx_context::sender(ctx), ctx);
    }
}