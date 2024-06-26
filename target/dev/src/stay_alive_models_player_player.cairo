impl PlayerIntrospect<> of dojo::database::introspect::Introspect<Player<>> {
    #[inline(always)]
    fn size() -> Option<usize> {
        let sizes: Array<Option<usize>> = array![
            dojo::database::introspect::Introspect::<CharacterType>::size(), Option::Some(2)
        ];

        if dojo::database::utils::any_none(@sizes) {
            return Option::None;
        }
        Option::Some(dojo::database::utils::sum(sizes))
    }

    fn layout() -> dojo::database::introspect::Layout {
        dojo::database::introspect::Layout::Struct(
            array![
                dojo::database::introspect::FieldLayout {
                    selector: 434741367601683122261563262936620114720213509063869209189755786333245521202,
                    layout: dojo::database::introspect::Introspect::<CharacterType>::layout()
                },
                dojo::database::introspect::FieldLayout {
                    selector: 1255174133449447254735351304457281547355869513201380084579561211077820777104,
                    layout: dojo::database::introspect::Introspect::<u64>::layout()
                },
                dojo::database::introspect::FieldLayout {
                    selector: 1275106329409434172824427927513550837566786971953511485343475677766844231503,
                    layout: dojo::database::introspect::Introspect::<u64>::layout()
                }
            ]
                .span()
        )
    }

    #[inline(always)]
    fn ty() -> dojo::database::introspect::Ty {
        dojo::database::introspect::Ty::Struct(
            dojo::database::introspect::Struct {
                name: 'Player',
                attrs: array![].span(),
                children: array![
                    dojo::database::introspect::Member {
                        name: 'character_id',
                        attrs: array!['key'].span(),
                        ty: dojo::database::introspect::Introspect::<u8>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'character_type',
                        attrs: array![].span(),
                        ty: dojo::database::introspect::Introspect::<CharacterType>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'hp',
                        attrs: array![].span(),
                        ty: dojo::database::introspect::Introspect::<u64>::ty()
                    },
                    dojo::database::introspect::Member {
                        name: 'attack',
                        attrs: array![].span(),
                        ty: dojo::database::introspect::Introspect::<u64>::ty()
                    }
                ]
                    .span()
            }
        )
    }
}

impl PlayerModel of dojo::model::Model<Player> {
    fn entity(
        world: dojo::world::IWorldDispatcher,
        keys: Span<felt252>,
        layout: dojo::database::introspect::Layout
    ) -> Player {
        let values = dojo::world::IWorldDispatcherTrait::entity(
            world,
            711011379911436309259372467342761500657237775100998141763491044473508065524,
            keys,
            layout
        );

        // TODO: Generate method to deserialize from keys / values directly to avoid
        // serializing to intermediate array.
        let mut serialized = core::array::ArrayTrait::new();
        core::array::serialize_array_helper(keys, ref serialized);
        core::array::serialize_array_helper(values, ref serialized);
        let mut serialized = core::array::ArrayTrait::span(@serialized);

        let entity = core::serde::Serde::<Player>::deserialize(ref serialized);

        if core::option::OptionTrait::<Player>::is_none(@entity) {
            panic!(
                "Model `Player`: deserialization failed. Ensure the length of the keys tuple is matching the number of #[key] fields in the model struct."
            );
        }

        core::option::OptionTrait::<Player>::unwrap(entity)
    }

    #[inline(always)]
    fn name() -> ByteArray {
        "Player"
    }

    #[inline(always)]
    fn version() -> u8 {
        1
    }

    #[inline(always)]
    fn selector() -> felt252 {
        711011379911436309259372467342761500657237775100998141763491044473508065524
    }

    #[inline(always)]
    fn instance_selector(self: @Player) -> felt252 {
        Self::selector()
    }

    #[inline(always)]
    fn keys(self: @Player) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.character_id, ref serialized);
        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn values(self: @Player) -> Span<felt252> {
        let mut serialized = core::array::ArrayTrait::new();
        core::serde::Serde::serialize(self.character_type, ref serialized);
        core::serde::Serde::serialize(self.hp, ref serialized);
        core::serde::Serde::serialize(self.attack, ref serialized);
        core::array::ArrayTrait::span(@serialized)
    }

    #[inline(always)]
    fn layout() -> dojo::database::introspect::Layout {
        dojo::database::introspect::Introspect::<Player>::layout()
    }

    #[inline(always)]
    fn instance_layout(self: @Player) -> dojo::database::introspect::Layout {
        Self::layout()
    }

    #[inline(always)]
    fn packed_size() -> Option<usize> {
        let layout = Self::layout();

        match layout {
            dojo::database::introspect::Layout::Fixed(layout) => {
                let mut span_layout = layout;
                Option::Some(dojo::packing::calculate_packed_size(ref span_layout))
            },
            dojo::database::introspect::Layout::Struct(_) => Option::None,
            dojo::database::introspect::Layout::Array(_) => Option::None,
            dojo::database::introspect::Layout::Tuple(_) => Option::None,
            dojo::database::introspect::Layout::Enum(_) => Option::None,
            dojo::database::introspect::Layout::ByteArray => Option::None,
        }
    }
}

#[starknet::interface]
trait Iplayer<T> {
    fn ensure_abi(self: @T, model: Player);
}

#[starknet::contract]
mod player {
    use super::Player;
    use super::Iplayer;

    #[storage]
    struct Storage {}

    #[abi(embed_v0)]
    impl DojoModelImpl of dojo::model::IModel<ContractState> {
        fn selector(self: @ContractState) -> felt252 {
            dojo::model::Model::<Player>::selector()
        }

        fn name(self: @ContractState) -> ByteArray {
            dojo::model::Model::<Player>::name()
        }

        fn version(self: @ContractState) -> u8 {
            dojo::model::Model::<Player>::version()
        }

        fn unpacked_size(self: @ContractState) -> Option<usize> {
            dojo::database::introspect::Introspect::<Player>::size()
        }

        fn packed_size(self: @ContractState) -> Option<usize> {
            dojo::model::Model::<Player>::packed_size()
        }

        fn layout(self: @ContractState) -> dojo::database::introspect::Layout {
            dojo::model::Model::<Player>::layout()
        }

        fn schema(self: @ContractState) -> dojo::database::introspect::Ty {
            dojo::database::introspect::Introspect::<Player>::ty()
        }
    }

    #[abi(embed_v0)]
    impl playerImpl of Iplayer<ContractState> {
        fn ensure_abi(self: @ContractState, model: Player) {}
    }
}
