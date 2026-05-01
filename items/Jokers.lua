SMODS.Joker {
	key = "kitsune", ---joker key
	rarity = 1,   ---1=common, 2=uncommon,3=rare, 4=legendary
	cost = 5,     ---cost in dollars, this will be halved for the sell cost
	unlocked = true,
	discovered = true,
	blueprint_compat = true, ---can blueprint copy its effects? This is only visual. You must hardcode incompatibility with blueprint.
	eternal_compat = true, ---can it be eternal? this is true by default, and disabled on jokers with sell effects
	perishable_compat = true, ---can it be perishable? this is true by default, and disabled on jokers with scaling effects
	rental_compat = true,  ---can it be rental? this is true by default, and... uh... i don't know what can't have it.
	---this is where the joker stores information.
	---Consider "card.ability" to be accessing this table, but do not use self.config to refer to it unless you must.
	---This means card.ability.chips = 80
	config = { chips = 80 },
	atlas = "StarterPackJokers",
	attributes = { "chips", "eight" }, ---the spritesheet to get the sprite from
	pos = { x = 3, y = 2 },         ---the grid position to take the joker's sprite from within the atlas.
	---0,0 is the top left corner.
	loc_vars = function(self, info_queue, card)
		---the vars return in loc_vars sends dynamic values to the joker's description. See localization comments for more info
		---
		return { vars = { card.ability.chips } }
	end,
	calculate = function(self, card, context)
		---context.individual and context.cardarea == G.hand is used for held in hand effects.
		---not context.end_of_round makes them not trigger during the checks for held in hand at end of round, like gold cards
		if context.individual and context.cardarea == G.hand and not context.end_of_round then
			---during context.individual, you can reference context.other_card to get the card currently being checked
			---the card:get_id() function returns an integer based on the card's rank value internally
			---2 is the lowest, going up through to 10, then jack is 11, queen is 12, king is 13
			---ace is 14, not 1
			if context.other_card:get_id() == 8 then
				---returning chips makes the card output chips
				return {
					chips = card.ability.chips,
					---This line makes the popup message appear above the card being checked.
					---by default, this is treated as "card = card". This is applicable most of the time.
					card = context.other_card
				}
				---NO CODE CAN BE EXECUTED AFTER A RETURN. You must do this LAST within each code area..
				---This doesn't cause too many issues, unless your joker outputs stuff in multiple effects, in which case it can be annoying.
			end
		end
	end
}

SMODS.Joker {
	key = "floppy_disk",
	rarity = 2,
	cost = 7,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = false, ---This is a scaling joker, so it should not have perishable
	rental_compat = true,
	config = { chips = 0 },
	atlas = "StarterPackJokers",
	attributes = { "chips", "scaling" },
	pos = { x = 5, y = 1 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips } }
	end,
	calculate = function(self, card, context)
		---context.before happens before a hand scores, context.after happens after
		---these are best used for per-hand effects.

		---not context.blueprint makes this effect immune to blueprint.
		---but blueprint should still be compat, right? well we don't wand blueprint to copy the scaling
		---not context.blueprint is not used on the context.joker_main section which outputs chips, which means blueprint can copy the chips output and not the scaling
		---this is how vanilla does blueprinting scaling jokers.
		if context.before and not context.blueprint then
			---scoring_hand is a table containing every scored card, which we will now check through for chip values
			local highest = 0
			local tempchips = 0
			---index is the postion of the card checked, value is the current card being checked
			for index, value in ipairs(context.scoring_hand) do
				---card.debuffed is true if the card is, well, debuffed. wouldnt make sense to scale from a card that was debuffed, unless you scale off debuffed cards themselves.
				if not value.debuffed then
					---base.nominal is the card's regular chip value
					---perma_bonus is the bonus chips applied by Hiker, Bonus Cards and Stone Cards.
					---Honestly, I think stone cards deserve this powerful synergy.
					tempchips = value.base.nominal + value.ability.perma_bonus

					---simply going through and checking if the current card's value is higher than our current highest, if it is, get the bigger one, keep going.
					if tempchips > highest then
						highest = tempchips
					end
				end
			end
			card.ability.chips = card.ability.chips + highest
			---card_eval_status_text is a super old fashioned way of displaying message popups for jokers.
			---There are TONS of better ways to do this, especially SMODS.calculate_effect, I just really like using this one and havent had to change yet.
			card_eval_status_text(card, 'extra', nil, nil, nil,
				{ message = localize('k_upgrade_ex'), colour = G.C.CHIPS })
			---anyway this does the message popup for when the value goes up
		end
		---standard joker value output.
		---chips > 0 makes it do nothing if it has negative or no value, avoiding unnecessary effect triggers, very slight optimisation
		---no "not context_blueprint" so blueprint can copy this effect
		if context.joker_main and card.ability.chips > 0 then
			return {
				chips = card.ability.chips,
				---this line makes the text appear under a copying blueprint, if there s one.
				---The phrase "or" in lua checks if the first thing exists, if it does not, go to the second thing
				---so doing it in this order checks for blueprint, if this is not the blueprint copy, use this card instead
				card = context.blueprint_card or card
			}
		end
	end
}

SMODS.Joker {
	key = "space_invaders",
	rarity = 2,
	cost = 8,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	rental_compat = true,
	config = { chips = 2 },
	atlas = "StarterPackJokers",
	attributes = { "chips", "modify_card", "perma_bonus" },
	pos = { x = 3, y = 3 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.chips } }
	end,
	calculate = function(self, card, context)
		if context.using_consumeable then
			if context.consumeable.ability.set == "Planet" then
				---This check only happens if the whole deck is smaller than 6 cards. This would make it unnecessary to randomly select cards.
				if #G.playing_cards < 6 then
					---G.playing_cards is the table containing all your playing cards
					---this is different from G.deck.cards, which only contains the cards remaining in your deck
					for index, value in ipairs(G.playing_cards) do
						---This first line exists because playing cards do not have card.ability.perma_bonus to begin with
						---the operator "X or Y" acts as a nil check, so if X does not exist, it will choose Y instead.
						---If X does exist, perma_bonus is set to itself, so nothing breaks!
						---It could be written out long-form as "if perma_bonus then <this> end" which does the same check but is written out longer
						value.ability.perma_bonus = value.ability.perma_bonus or 0
						---If you tried to do this without doing the first line first, the game would crash.
						value.ability.perma_bonus = value.ability.perma_bonus + card.ability.chips
					end
					card_eval_status_text(card, 'extra', nil, nil, nil,
						{ message = localize('k_upgrade_ex'), colour = G.C.CHIPS })
				else
					---Actual random checks! there are two ways to do fully random events -
					---math.random(X,Y) makes a random whole number between X and Y
					---pseudorandom(seed, X,Y) makes a random whole number between X and Y - Wait, whats the difference?
					---The difference is that pseudorandom, as well as pseudorandom_element and pseudorandom_probability, respects your game seed. Math.random does not.
					---That means restarting the game with the same seed makes any "pseudorandom ..." function consistent. There are cases where you do or don't want this.
					---In this case, I do want it to respect the game seed, so pseudorandom it is.
					local done = 0
					local count = 0
					---While loops continue until the condition is false. Here the condtion is "not done", so when Done is 1, the while loop will end.
					while done == 0 do
						---pseudorandom functions take the seed argument as a string. the string can be LTERALLY ANYTHING YOU WANT.
						---i'm really sonic frontiers coded right now, so that's what this one means lol
						local current_index = pseudorandom("I'm here", 1, #G.playing_cards)
						---the selected value prevents the card from selecting the same target twice.
						---the count value decides how many cards get the chips.
						if G.playing_cards[current_index] and not G.playing_cards[current_index].stpck_selected then
							G.playing_cards[current_index].stpck_selected = true
							G.playing_cards[current_index].ability.perma_bonus = G.playing_cards[current_index].ability
								.perma_bonus or 0
							G.playing_cards[current_index].ability.perma_bonus = G.playing_cards[current_index].ability
								.perma_bonus + card.ability.chips
							count = count + 1
						end
						if count >= 5 then
							---end the loop after choosing 5
							done = 1
							---remove stpck_selected from all cards to allow the card to restart the loop
							for index, value in ipairs(G.playing_cards) do
								value.stpck_selected = nil
							end
						end
					end

					---send output message since it is done now
					---since i didn't talk about it previously, the localize function is used for localization outside jokers.
					---in the localization files, 'k_upgrade_ex' points to a string which is translated.
					---Hard coding the message prevents this from being possible. Internak joker IDs do not need to be translated.
					card_eval_status_text(card, 'extra', nil, nil, nil,
						{ message = localize('k_upgrade_ex'), colour = G.C.CHIPS })
				end
			end
		end
	end
}

SMODS.Joker {
	key = "joker_spawner", ---changed jimbo to joker to be more in line with the actual joker
	rarity = 2,
	cost = 8,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	rental_compat = true,
	atlas = "StarterPackJokers",
	attributes = { "joker" },
	pos = { x = 0, y = 2 },
	---This joker has no stored values, so it doesn't need the config section
	---it does however need the info_queue for jimbo, so I get to talk about that now
	loc_vars = function(self, info_queue, card)
		---info_queue is a table which manages extra info boxes on Jokers. These are used for Jokers with editions and other information, such as the fool showing you what tarot it will make
		---the # is lua's length modifier, so #table is an integer which represents the length of the table, aka how many values are in it
		---THE # SYMBOL IS CALLED A HASH BY THE WAY NOT A HASHTAG I WILL :START_DISSOLVE() ON THIS HILL
		---A HASHTAG IS A HASH PLUS A TAG IF YOU REMOVE THE TAG YOU ARE LEFT WITH JUST A HASH SYMBOL
		---#deep is a hashtag, # is the hash, deep is the tag.
		info_queue[#info_queue + 1] = G.P_CENTERS.j_joker
		---square brackets reference table index, so info_queue[2] references index 2
		---using [#table+1] appends our index queue onto the table without interfering with or overwriting the others
		---G.P_CENTERS is the index for object centers. Putting an object's key after this gets its center, which can be put into info_queue to display the name and effect of ANY card.
		---info_queue can do custom popup box descriptions too, but we don't need those yet.
	end,

	calculate = function(self, card, context)
		---context.setting_blind runs when blind is selected
		if context.setting_blind then
			---hover over a function's name when it is called to see the comments that were written near its definition!
			StarterPack_Cardmaker(false, false, true, false, "j_joker")
		end
	end
}

SMODS.Joker {
	key = "IOU_card",
	rarity = 1,
	cost = 2,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	eternal_compat = false, ---this joker self-destructs, so it cannot be eternal
	perishable_compat = true,
	rental_compat = true,
	config = { money = 20, tally = 0, maxrounds = 3 },
	atlas = "StarterPackJokers",
	attributes = { "economy"},
	pos = { x = 9, y = 1 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.money, card.ability.tally, card.ability.maxrounds } }
	end,
	calculate = function(self, card, context)
		---context.main_eval is super important here, without it, context.end_of_round triggers 8 times each round for some dumbass reason
		if context.end_of_round and context.main_eval and not context.blueprint then
			card.ability.tally = card.ability.tally + 1
			if card.ability.tally >= card.ability.maxrounds then
				---start_dissolve() destroys cards
				---also card:start_dissolve() is technically the same as start_dissolve(card) but EVERYONE uses the former and you should too
				card:start_dissolve()
				return {
					---return dollars to give money or use ease_dollars
					dollars = card.ability.money
				}
			end
		end
	end
}

SMODS.Joker {
	key = "stock_image",
	rarity = 2,
	cost = 7,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	eternal_compat = true,
	perishable_compat = true,
	rental_compat = true,
	config = { xmult = 1.5 },
	atlas = "StarterPackJokers",
	attributes = { "xmult" },
	pos = { x = 5, y = 3 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.xmult } }
	end,
	calculate = function(self, card, context)
		---this context is used for per-played-card effects
		---similarly to .cardarea == G.hand, this code runs on every played card, with context.other_card referring to the current card being checkecd
		if context.individual and context.cardarea == G.play then
			---G.P_CENTERS.<enhancement key> can be used to check for enhancements, or the lack thereof
			---c_base is none, m_steel is steel, m_gold is gold, etc
			if context.other_card.config.center == G.P_CENTERS.c_base then
				---The event manager is...Hard to explain.
				---Right now it is being used for one purpose; the code inside function() will run every time a card is physically scored on screen
				---but why do this when it is calculated on every card? If not for this event sequence, the code inside function() would run instantly multiple times when the hand is first calculated
				---because balatro calculates the whole hand before it is shown to you
				G.E_MANAGER:add_event(Event({
					func = function()
						---juice_uo is the function that shakes the cards when they do stuff
						---card is the joker's own object
						card:juice_up()

						---return true ends the event, if you remove this the event loops forever
						return true
					end
				}))

				---I will explain the event manager more when its other quirks become relevant. just know that bare minimum, all the code here is needed, except replace card:juice_up() with the code you want the event to run
				return {
					xmult = card.ability.xmult,
					---card = dictates which card is "giving" the xmult, which also decides where the message appears
					card = context.other_card
				}
			end
		end
	end
}

---2 in 1 chance of probability induced headache
SMODS.Joker {
	key = "volatile_humor",
	discovered = true,
	blueprint_compat = true,
	eternal_compat = false,
	rarity = 3,
	cost = 8,
	atlas = "StarterPackJokers",
	attributes = { "xmult", "destroy_card" },
	pos = { x = 6, y = 3 },
	config = { extra = { odds = 6, xmult = 3.5 } },
	loc_vars = function(self, info_queue, card)
		---okay, alright, alright okay,alright, okay
		---SMODS.get_probability_vars() allows modded probabilities to interact with each other
		---card.ability.extra.odds is the denominator, aka the lower number in the fraction, or the second number in balatro
		---1 in 3 | 1 = numerator, 3 = denominator
		---card refers to the joker once again, and the string on the end is an identifier
		---the identifier should denote the source of the probability - this is mostly for debugging, in case someone fucks it up
		local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds,
			'starterpack-volatile')
		---numerator and denominator are then passed through the loc_vars return and sent as variables for the joker description
		return { vars = { card.ability.extra.xmult, numerator, denominator } }
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint then
			---if SMODS.pseudorandom_probability(...) checks for the probability
			---this is what actually rolls the 1 in 5
			if SMODS.pseudorandom_probability(card, 'starterpack-volatile', 1, card.ability.extra.odds) then
				SMODS.destroy_cards(card, nil, nil, true)
				if #G.playing_cards < 6 then
					---destroy every card in the deck if its 5 or smaller
					for index, value in ipairs(G.playing_cards) do
						value:start_dissolve()
					end
				else
					---destroy 5 random cards if its not 5 or smaller
					for i = 1, 5 do
						pseudorandom_element(G.playing_cards, "one-way-dream"):start_dissolve()
					end
				end
				---this is how we check for config values. This makes the sound only play if you have it enabled.
				if StarterPack_Config.extrasounds then
					---EVENT MANAGER TIME!!!!
					---The Event Manager is used for events which happen in "real-time", as previously explained.
					---Though, it has some other arguments i'll show off here
					G.E_MANAGER:add_event(Event({
						---event manager arguments go between func = function and the top line
						blockable = false, ---can other events stop this event from running? if true, it will wait until there are no other events running before it runs.
						blocking = false, ---can this event stop other events from running? if true,  it will stop all other events until the "return true" is reached.
						delay = 0.05, ---delay time in seconds before the event runs.
						func = function()
							---when you play a sound you need to add the sound's mod prefix before its key
							---the two 1s here are volume and speed of the played audio
							play_sound('stpck_kaboom', 1, 1)
							return true
						end
					}))
				end
				return {
					message = localize('k_kaboom_ex') ---this is a custom localized message string
				}
			else
				return {
					message = localize('k_safe_ex') ---this one is vanilla though
				}
			end
		end
		---the part where it gives the xmult
		if context.joker_main then
			return {
				xmult = card.ability.extra.xmult
			}
		end
	end,
}


SMODS.Joker {
	key = "social_media",
	rarity = 3,
	cost = 9,
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	atlas = "StarterPackJokers",
	attributes = { "xmult", "joker" },
	pos = { x = 2, y = 3 },
	calculate = function(self, card, context)
		---context.other_joker goes through every joker after joker_main
		---baseball card uses this too!
		if context.other_joker then
			---Legendaries, Jokebox's Cosmic Rarity, Tsunami's Legendary Fusion/Gold Fusion/Gold Legendary rarities
			---and Cryptid's Epic and Exotic rarities
			---I added support for the Jokebox and Tsunami rarities cause I made them, and cryptid is popular, so...
			if context.other_joker.config.center.rarity == 4 or context.other_joker.config.center.rarity == "jkbx_cosmic" or context.other_joker.config.center.rarity == "tsun_leg_fusion" or context.other_joker.config.center.rarity == "tsun_gold_legendary" or context.other_joker.config.center.rarity == "tsun_gold_fusion" or context.other_joker.config.center.rarity == "cry_exotic" or context.other_joker.config.center.rarity == "cry_epic" then
				return {
					xchips = 2
				}
				---Rares, Fused Jokers (FusionJokers), and Evolved Jokers (JokerEvolution)
			elseif context.other_joker.config.center.rarity == 3 or context.other_joker.config.center.rarity == "fuse_fusion" or context.other_joker.config.center.rarity == "evo_evolved" then
				if context.other_joker.config.center.key ~= "j_stpck_social_media" then
					return {
						xchips = 1.6
					}
				end
				---Uncommons
			elseif context.other_joker.config.center.rarity == 2 then
				return {
					xchips = 1.4
				}
				---Everything Else (Commons and other rarities not accounted for)
			else
				return {
					xchips = 1.2
				}
			end
		end
	end,
}

SMODS.Joker {
	key = "price_tag",
	rarity = 3,
	cost = 9,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	atlas = "StarterPackJokers",
	attributes = { "economy", "shop" },
	pos = { x = 9, y = 2 },
	calculate = function(self, card, context)
		if not context.blueprint then
			---money_altered tracks when money is changed
			---if context.amount is negative, it was removed, if it is positive it was added
			---and amount is well the amount added or removed
			if context.money_altered and context.amount < 0 then
				local temp_amount = context.amount / 4
				---checking config for jokers rounding values
				if StarterPack_Config.stpck_rounding then
					---I don't get why there is a red underline here.
					---Just..Ignore it. It means nothing here.
					temp_amount = math.min(1, (math.floor(temp_amount + 0.5)))
				end
				return {
					dollars = temp_amount * -1
				}
			end
		end
	end,
}

SMODS.Joker {
	key = "chipper",
	name = "Chipper Joker",
	rarity = 2,
	cost = 5,
	unlocked = true,
	discovered = true,
	blueprint_compat = false,
	rental_compat = false,
	perishable_compat = false,
	pos = { x = 7, y = 0 },
	atlas = "StarterPackJokers",
	attributes = { "mult", "scaling" },
	config = { mult = 0, gain = 6 },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.gain, card.ability.mult } }
	end,
	calculate = function(self, card, context)
		if context.after and not context.blueprint then
			---if G.GAME.chips is recorded in context.after without an event check, it does not include the current scored hand
			------if G.GAME.chips is recorded inside an event check in context.after, it does include the current scored hand
			---The difference betweeen these two values is the score of the current played hand (this_hand_score)

			local prev_score = G.GAME.chips
			G.E_MANAGER:add_event(Event({
				blockable = true,
				blocking = true,
				func = function()
					local this_hand_score = G.GAME.chips - prev_score
					if this_hand_score >= G.GAME.blind.chips / 2 then
						card.ability.mult = card.ability.mult + card.ability.gain
						card_eval_status_text(card, 'extra', nil, nil, nil,
							{ message = localize('k_upgrade_ex'), colour = G.C.MULT })
					end
					return true
				end
			}))
		end
		if context.joker_main then
			return {
				mult = card.ability.mult,
				card = context.blueprint_card or card
			}
		end
	end,
}

--- time to hook a function! Two functions actually, for ASCII Art


--- Step 1: Save the original function as a LOCAL variable
local card_is_suit_ref = Card.is_suit
--- Step 2: Re-define a copy of the function using its original arguments
--- if you exclude an argument, it cannot be used by the original function or any other hook of the function
--- ignore the error on the function being defined
function Card:is_suit(suit, bypass_debuff, flush_calc)
	---Step 3: Feed the function from Step 1 the arguments from the function in Step 2
	---Important side note: Card:is_suit() is the same as is_suit(card) or in this case is_suit(self), but you can't write card:is_suit here, so is_suit(self) is used.
	---Step 3.5: Save this value as another LOCAL variable
	local ret = card_is_suit_ref(self, suit, bypass_debuff, flush_calc)
	---Our code goes here.
	G.GAME.stpck_ascii = G.GAME.stpck_ascii or
		0 ---G.GAME.<anything> values reset when starting a new run. This line checsk if it exists, and creates it if it doesn't.
	G.GAME.stpck_ascii = G.GAME.stpck_ascii + 1
	---Our code goes here.
	---Step 4: return the value saved in step 3.5
	---if you put a return befpre this, or if you don't return it, the function will STOP when it reaches your hook.
	return ret
end

local Card_get_id_ref = Card.get_id
function Card:get_id()
	local ret = Card_get_id_ref(self)
	G.GAME.stpck_ascii = G.GAME.stpck_ascii or 0
	G.GAME.stpck_ascii = G.GAME.stpck_ascii + 1
	return ret
end

SMODS.Joker {
	key = "ascii",
	unlocked = true,
	discovered = true,
	blueprint_compat = true,
	rarity = 3,
	cost = 8,
	atlas = "StarterPackJokers",
	attributes = { "xmult", "scaling" },
	pos = { x = 3, y = 0 },
	config = { extra = { xmult = 0.1 } },
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.xmult, 1 + (G.GAME.stpck_ascii or 0) * card.ability.extra.xmult } }
	end,
	calculate = function(self, card, context)
		if context.before then
			G.GAME.stpck_ascii = 0
		end
		if context.joker_main then
			return {
				xmult = 1 + (G.GAME.stpck_ascii or 0) * card.ability.extra.xmult
			}
		end
	end,
}
