module challenge::arena;

use challenge::hero::Hero;
use sui::event;

// ========= STRUCTS =========

public struct Arena has key, store {
    id: UID,
    warrior: Hero,
    owner: address,
}

// ========= EVENTS =========

public struct ArenaCreated has copy, drop {
    arena_id: ID,
    timestamp: u64,
}

public struct ArenaCompleted has copy, drop {
    winner_hero_id: Option<ID>,
    loser_hero_id: Option<ID>,
    timestamp: u64,
}

// ========= FUNCTIONS =========

public fun create_arena(hero: Hero, ctx: &mut TxContext) {
    let arena: Arena = Arena {
        id: object::new(ctx),
        warrior: hero,
        owner: ctx.sender(),
    };

    event::emit(ArenaCreated {
        arena_id: object::id(&arena),
        timestamp: ctx.epoch_timestamp_ms(),
    });

    transfer::share_object(arena);
}

#[allow(lint(self_transfer))]
public fun battle(hero: Hero, arena: Arena, ctx: &mut TxContext) {
    let Arena { id, warrior, owner } = arena;

    let hero_id = object::id(&hero);
    let warrior_id = object::id(&warrior);
    let hero_power = hero.hero_power();
    let warrior_power = warrior.hero_power();

    let timestamp = ctx.epoch_timestamp_ms();

    if (hero_power > warrior_power) {
        transfer::public_transfer(hero, ctx.sender());
        transfer::public_transfer(warrior, ctx.sender());

        event::emit(ArenaCompleted {
            winner_hero_id: option::some(hero_id),
            loser_hero_id: option::some(warrior_id),
            timestamp,
        })
    } else if (hero_power < warrior_power) {
        transfer::public_transfer(hero, owner);
        transfer::public_transfer(warrior, owner);

        event::emit(ArenaCompleted {
            winner_hero_id: option::some(warrior_id),
            loser_hero_id: option::some(hero_id),
            timestamp,
        })
    } else {
        transfer::public_transfer(hero, ctx.sender());
        transfer::public_transfer(warrior, owner);

        event::emit(ArenaCompleted {
            winner_hero_id: option::none(),
            loser_hero_id: option::none(),
            timestamp,
        })
    };

    id.delete();
}
