SMODS.Joker {
    key = 'artistsrendition',
    atlas = 'StarterPackJokers',
    pos = { x = 2, y = 0 },
    rarity = 1,
    blueprint_compat = true,
    cost = 2,
    discovered = true,
    config = { extra = { mult = 4 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = card.ability.extra.mult }
        end
    end
}

SMODS.Joker {
    key = 'cloverjoker',
    atlas = 'StarterPackJokers',
    pos = { x = 1, y = 1 },
    rarity = 1,
    blueprint_compat = true,
    cost = 2,
    discovered = true,
    config = { extra = { mult = 4 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = card.ability.extra.mult }
        end
    end
}

SMODS.Joker {
    key = 'deepblues',
    atlas = 'StarterPackJokers',
    pos = { x = 5, y = 0 },
    rarity = 1,
    blueprint_compat = true,
    cost = 2,
    discovered = true,
    config = { extra = { mult = 4 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = card.ability.extra.mult }
        end
    end
}

SMODS.Joker {
    key = 'erchiushorror',
    atlas = 'StarterPackJokers',
    pos = { x = 4, y = 0 },
    rarity = 3,
    blueprint_compat = true,
    cost = 2,
    discovered = true,
    config = { extra = { mult = 4 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = card.ability.extra.mult }
        end
    end
}

SMODS.Joker {
    key = 'galacticnova',
    atlas = 'StarterPackJokers',
    pos = { x = 2, y = 1 },
    rarity = 1,
    blueprint_compat = true,
    cost = 2,
    discovered = true,
    config = { extra = { mult = 4 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = card.ability.extra.mult }
        end
    end
}

SMODS.Joker {
    key = 'greentext',
    atlas = 'StarterPackJokers',
    pos = { x = 0, y = 4 },
    rarity = 2,
    cost = 6,
    blueprint_compat = false,

    calculate = function(self, card, context)
        if context.mod_probability and not context.blueprint then
            return { numerator = 1, denominator = 3 }
        end
    end
}

SMODS.Joker {
    key = 'jimbosinferno',
    atlas = 'StarterPackJokers',
    pos = { x = 7, y = 4 },
    rarity = 2,
    blueprint_compat = true,
    cost = 2,
    discovered = true,
    config = { extra = { mult = 4 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = card.ability.extra.mult }
        end
    end
}

SMODS.Joker {
    key = 'jokerbot',
    atlas = 'StarterPackJokers',
    pos = { x = 8, y = 4 },
    rarity = 1,
    blueprint_compat = true,
    cost = 2,
    discovered = true,
    config = { extra = { mult = 4 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = card.ability.extra.mult }
        end
    end
}

SMODS.Joker {
    key = 'offputting',
    atlas = 'StarterPackJokers',
    pos = { x = 3, y = 4 },
    rarity = 1,
    cost = 2,

    config = { extra = { mult = 2 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            local count = 0
            for _, c in ipairs(G.hand.cards or {}) do
                local id = c:get_id()
                if id ~= 11 and id ~= 12 and id ~= 13 and not c.debuff then
                    count = count + 1
                end
            end
            return { mult = count * card.ability.extra.mult }
        end
    end
}

SMODS.Joker {
    key = 'playingmygame',
    atlas = 'StarterPackJokers',
    pos = { x = 5, y = 5 },
    rarity = 2,
    blueprint_compat = true,
    cost = 2,
    discovered = true,
    config = { extra = { mult = 4 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = card.ability.extra.mult }
        end
    end
}

SMODS.Joker {
    key = 'realisticjoker',
    atlas = 'StarterPackJokers',
    pos = { x = 6, y = 4 },
    rarity = 1,
    blueprint_compat = true,
    cost = 2,
    discovered = true,
    config = { extra = { mult = 4 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = card.ability.extra.mult }
        end
    end
}

SMODS.Joker {
    key = 'snowgravejoker',
    atlas = 'StarterPackJokers',
    pos = { x = 0, y = 5 },
    rarity = 3,
    blueprint_compat = true,
    cost = 2,
    discovered = true,
    config = { extra = { mult = 4 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = card.ability.extra.mult }
        end
    end
}

SMODS.Joker {
    key = 'spaceshiplicense',
    atlas = 'StarterPackJokers',
    pos = { x = 4, y = 5 },
    rarity = 2,
    blueprint_compat = true,
    cost = 2,
    discovered = true,
    config = { extra = { mult = 4 } },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { mult = card.ability.extra.mult }
        end
    end
}

SMODS.Joker {
    key = 'tntl',
    atlas = 'StarterPackJokers',
    pos = { x = 1, y = 4 },
    rarity = 1,
    blueprint_compat = true,
    cost = 2,
    discovered = true,
    config = { extra = { mult = 15 } },

    calculate = function(self, card, context)
        if context.joker_main then
            local joker_count = 0
            if G.jokers and G.jokers.cards then
                joker_count = #G.jokers.cards - #SMODS.find_card('j_stpck_tntl')
            end

            return {
                mult = card.ability.extra.mult - (joker_count * 3)
            }
        end
    end
}