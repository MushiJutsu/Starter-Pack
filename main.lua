------------MOD CODE -------------------------
---The mod code barriers arent needed without the smods header I just like them

--- Every played card counts in scoring


---These values are more important than they let off.
---Not only does the global table allow other mods to check if this mod exists by doing "If StarterPack then", but it allows functions and other important globals to be put under the mod handle, reducing the chance of them colliding with another mod's.
StarterPack = {}
StarterPack_Mod = SMODS.current_mod
---This is in case we make a config file. I will handle the UI on it if it is needed.
StarterPack_Config = StarterPack_Mod.config

---This function makes it SUPER easy to control blind size.
---mod = the number to mulitply the current blind's size by
function StarterPack.ease_blind_size(mod)
	G.GAME.blind.chips = math.floor(G.GAME.blind.chips * mod)
	G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
end

SMODS.Atlas {
	key = "StarterPackJokers", ---key put into "atlas" argument in jokers
	path = "jokers.png",    ---filename
	px = 71,                --- width
	py = 95,                ---height
}

---sounds are defined like the sprite atlas
SMODS.Sound({
	key = "kaboom",
	path = "deltarune-explosion.mp3", ---file name WITH THE CORRECT FILE EXTENSION!!! this routes to StarterPack/assets/sounds/...
	pitch = 1,
})



---most of these functions were copied from jokebox, they may prove useful or spark new ideas

---check if card is in collection (thanks minty and or pokermon)
StarterPack.in_collection = function(card)
	if G.your_collection then
		for k, v in pairs(G.your_collection) do
			if card.area == v then
				return true
			end
		end
	end
	return false
end

---get percentage from two values
StarterPack.Get_Percentage = function(num1, num2)
	local temp1 = num2 / num1
	local temp2 = temp1 * 100
	return math.floor(temp2 + 0.5)
end

---Adds a dummy function that does nothing if Talisman isn't loaded, lets me avoid having Talisman be a dependency
---and avoid crashes if Talisman is loaded
to_big = to_big or function(num)
	return num
end
to_number = to_number or function(num)
	return num
end


---I absolutely despise SMODS.add_card personally and will use this to spawn cards instead.
---You could totally just use SMODS.add_card if you prefer it, though.
---enter an edition in _edition to set edition, enter true or false in each sticker to set them
function StarterPack_Cardmaker(_edition, eternal, perishable, rental, _key)
	local _card = SMODS.create_card({
		area = G.jokers,
		key = _key
	})
	if _edition == "e_negative" or _edition == "negative" then
		_card:set_edition({ negative = true }, nil)
		_card.edition.negative = true
	end
	if eternal then
		_card.ability.eternal = true
	end
	if perishable then
		_card.ability.perishable = true
	end
	if rental then
		_card.ability.rental = true
	end
	_card:add_to_deck()
	G.jokers:emplace(_card)
	return _card
end

---Deck key finder, returns key of deck you are using
function StarterPack_Deck_Check()
	if Galdur and Galdur.config.use and Galdur.run_setup.choices.deck then
		return Galdur.run_setup.choices.deck.effect.center.key
	elseif G.GAME.viewed_back then
		return G.GAME.viewed_back.effect.center.key
	elseif G.GAME.selected_back then
		return G.GAME.selected_back.effect.center.key
	end
	return "b_red"
end

---function for merging tables. MOVES VALUES FROM TABLE1 TO TABLE2!!!!	
function StarterPack.table_merge(table1, table2)
	for _, value in ipairs(table1) do
		table.insert(table2, value)
	end
end

---removing stuff from tables by key
function table.jkbxremovekey(table, key)
	local element = table[key]
	table[key] = nil
	return element
end

---split string at symbol (thanks Meta, Rock Muncher)
function StarterPack.string_split(string, symbol)
	local index = string.find(string, symbol)
	local string1 = string.sub(string, 1, index - 1)
	local string2 = string.sub(string, index + 1, -1)
	return string1, string2
end

---This is the line of code that loads the lua file containing the jokers.
---Splitting up the files is not required, but it helps a lot with reading clarity.
SMODS.load_file("items/Jokers.lua")()

---hook for playing more than 6 cards at a time
---smods might implement this? maybe they already have? I don't really know.
local canplayref = G.FUNCS.can_play
G.FUNCS.can_play = function(e)
	canplayref(e) ---complete function hook
	if #G.hand.highlighted <= G.hand.config.highlighted_limit then
		if #G.hand.highlighted > 5 then
			e.config.colour = G.C.BLUE
			e.config.button = 'play_cards_from_highlighted'
		end
	end
end

---function for redeeming vouchers by key
function StarterPack.redeem_voucher(local_voucher, _delay)
	local voucher_card = SMODS.create_card({ area = G.play, key = local_voucher })
	voucher_card:start_materialize()
	voucher_card.cost = 0
	G.play:emplace(voucher_card)
	delay(0.3)
	voucher_card:redeem()
	G.E_MANAGER:add_event(Event({
		trigger = 'after',
		delay = _delay or 0.8,
		func = function()
			voucher_card:start_dissolve()
			return true
		end
	}))
end

---function for swapping a joker out for a new one
function StarterPack.change_card(card_object, new_card_key, transfer_ability, extra)
	local old_ability = 0
	if transfer_ability then
		if extra then
			old_ability = card_object.ability.extra[transfer_ability]
		else
			old_ability = card_object.ability[transfer_ability]
		end
	end
	card_object:set_ability(G.P_CENTERS[new_card_key])
	if transfer_ability then
		if extra then
			card_object.ability.extra[transfer_ability] = old_ability
		else
			card_object.ability[transfer_ability] = old_ability
		end
	end
	card_object:juice_up()
end

---function for removing all stickers (thanks minty)
StarterPack.Stickerclear = function(target)
	local stickers = SMODS.stickers
	target.ability.rental = false
	target.ability.perishable = false
	target.ability.eternal = false
	target.pinned = false
	if stickers ~= nil then
		for k, v in pairs(SMODS.stickers) do
			if target.ability[k] then
				if v.removed then v:removed(target) end --Patch for Gemstones; I don't think this is universal
				target:remove_sticker(k)
			end
		end
	end
end


---there are only 3 things you need to know about this config UI code

StarterPack_Mod.config_tab = function()
	return {
		n = G.UIT.ROOT,
		config = { align = "m", r = 0.1, padding = 0.1, colour = G.C.BLACK, minw = 8, minh = 6 },
		nodes = {
			{ n = G.UIT.R, config = { align = "cl", padding = 0, minh = 0.1 }, nodes = {} },

			---copy this segment to add a new toggle
			{
				n = G.UIT.R,
				config = { align = "cl", padding = 0 },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = "cl", padding = 0.05 },
						nodes = {
							---the ref_value argument is the value in the config file which corresponds to this setting
							create_toggle { col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = StarterPack_Config, ref_value = "extrasounds" },
						}
					},
					{
						n = G.UIT.C,
						config = { align = "c", padding = 0 },
						nodes = { --- the text value is the text displayed on the button
							{ n = G.UIT.T, config = { text = "Extra Sound Effects", scale = 0.45, colour = G.C.UI.TEXT_LIGHT } },
						}
					},
				}
			},
			---everything between these two outer comments, copy it and paste it right below this comment to add a new toggle if you need one
			---see config.lua for more
			{
				n = G.UIT.R,
				config = { align = "cl", padding = 0 },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = "cl", padding = 0.05 },
						nodes = {
							---the ref_value argument is the value in the config file which corresponds to this setting
							create_toggle { col = true, label = "", scale = 1, w = 0, shadow = true, ref_table = StarterPack_Config, ref_value = "stpck_rounding" },
						}
					},
					{
						n = G.UIT.C,
						config = { align = "c", padding = 0 },
						nodes = { --- the text value is the text displayed on the button
							{ n = G.UIT.T, config = { text = "Round Joker Values", scale = 0.45, colour = G.C.UI.TEXT_LIGHT } },
						}
					},
				}
			},
		}
	}
end

---The mod code barriers arent needed without the smods header I just like them
------------MOD CODE END----------------------
