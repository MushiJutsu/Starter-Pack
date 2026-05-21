return {
	["misc"] = {
		["dictionary"] = {
			---Miscellaneous values that need to be localized can be put here.
			["k_stpck_example"] = "Test",
			["k_kaboom_ex"] = "Boom!" --- used by Volatile Humor when destroyed
		},
	},
	["descriptions"] = {
		["Joker"] = {
			---Object prefix, underscore, mod prefix, underscore, object key
			---Object prefix = j for Joker, mod prefix = stpck, object key = kitsune
			---c for consumable, v for voucher, b for back (deck)
			---k as object prefix means nothing i just like doing it on the misc dictionary items
			["j_stpck_kitsune"] = {
				["name"] = "Kitsune", ---display name
				["text"] = {
					---#1# will reference the first value in the Return in Kitsune's loc_vars section, making it a variable that can change with the internal value.
					--- #2# gets the second, #3# gets the third, so on so forth.
					"Each {C:attention}8{} held in hand",
					"gives {C:chips}+#1#{} Chips",
					---C:chips is a color, which continues until the end of the current line
					---{} clears the current color value, turning it back to normal
					--- C:chips, C:mult, C:attention and C:inactive are the most common colours.
				},
			},

			["j_stpck_floppy_disk"] = {
				["name"] = "Floppy Disk",
				["text"] = {
					"This Joker gains {C:chips}chips{} equal to the",
					"highest {C:attention}chip value{} among",
					"{C:attention}scoring cards{} each hand",
					---scaling jokers display scaled values like this
					"{C:inactive}(currently {C:chips}#1#{C:inactive} Chips)",
				},
			},

			["j_stpck_joker_spawner"] = {
				["name"] = "Joker Spawner",
				["text"] = {
					"When {C:attention}Blind{} is selected,",
					"create a {C:attention}Perishable Joker{}",
					"{C:inactive}(don't need room)"
				},
			},
			["j_stpck_space_invaders"] = {
				["name"] = "Space Invaders",
				["text"] = {
					"Each time a {C:planet}Planet Card{} is used,",
					"permanently add {C:chips}#1#{} Chips to",
					"{C:attention}5{} cards in your full Deck"
				},
			},
			["j_stpck_IOU_card"] = {
				["name"] = "IOU Card",
				["text"] = {
					"After {C:attention}#3#{C:inactive}[#2#]{} rounds,",
					"earn {C:money}$#1#{}",
					"{C:red}self-destructs"
				},
			},

			["j_stpck_stock_image"] = {
				["name"] = "Stock Image",
				["text"] = {
					"Played cards with no {C:attention}Enhancement",
					---X:mult creates the highlight bubble around the text
					---C:white decides the text colour inside that bubble
					"give {X:mult,C:white}X#1#{} Mult when scored",
				},
			},

			["j_stpck_volatile_humor"] = {
				["name"] = "Volatile Humor",
				["text"] = {
					"{X:mult,C:white}X#1#{} Mult",
					"{C:green}#2# in #3#{} chance to {C:red}explode{} when round ends",
					"{C:red,s:0.8}destroys{C:attention,s:0.8} 5{s:0.8} random cards in your full Deck, then {C:red,s:0.8}self-destructs"
				},
			},
			["j_stpck_social_media"] = {
				["name"] = "Social Media",
				["text"] = {
					"{C:attention}Other{} Jokers",
					"give {X:chips,C:white}Xchips{} based on their {C:attention}Rarity",
					"Common: {X:chips,C:white}X1.2{}, Uncommon: {X:chips,C:white}X1.4{}, Rare: {X:chips,C:white}X1.6{}",
				},
			},

			["j_stpck_price_tag"] = {
				["name"] = "Price Tag",
				["text"] = {
					"{C:money}Refund {C:attention}25%{} of money spent in the {C:attention}Shop",
				},
			},
			["j_stpck_chipper"] = {
				["name"] = "Chipper Joker",
				["text"] = {
					"This Joker gains {C:attention}+#1#{} Mult if played hand",
					"scores more than {C:attention}50%{} of required score",
					"{C:inactive}(currently {C:red}#2#{C:inactive} Mult)",
				},
			},
			["j_stpck_ascii"] = {
				["name"] = "ASCII Art",
				["text"] = {
					"This Joker gives {X:mult,C:white}X#1#{} Mult",
					"for each {C:attention}get_id(){} or {C:attention}is_suit(){}",
					"run each hand",
				},
			},
			["j_stpck_poorlydrawn"] = {
				["name"] = "Poorly Drawn",
				["text"] = {
					'NOT IMPLEMENTED YET',
				},
			},
			["j_stpck_jpg"] = {
				["name"] = "joker.jpg",
				["text"] = {
					'NOT IMPLEMENTED YET',
				},
			},
            j_stpck_greentext = {
                name = 'Greentext',
                text = {
                    '{C:green}>be me{}',
                    '{C:green}>joker{}',
                    '{C:green}>make every probability 1/3{}',
                    '{C:green}>mfw{}',
                    '{C:green}>pic related{}'
                }
            },

            j_stpck_artistsrendition = {
                name = "Artist's Rendition",
                text = {
                    'NOT IMPLEMENTED YET'
                }
            },

            j_stpck_tntl = {
                name = "Trying Not to Laugh",
                text = {
                    "{C:mult}#1#{} Mult",
                    "{C:mult}-3{} for each {C:attention}Joker{} card owned",
                    "{C:inactive}(Currently {C:red}+#2#{C:inactive} Mult)"
                }
            },

            j_stpck_offputting = {
                name = "Offputting",
                text = {
                    '{C:mult}+#1#{} Mult for every',
                    'non-face Card in your hand'
                }
            },
            j_stpck_erchiushorror = {
                name = "Erchius Horror",
                text = {
                    'NOT IMPLEMENTED YET'
                }
            },
            j_stpck_snowgravejoker = {
                name = "Snowgrave",
                text = {
                    'NOT IMPLEMENTED YET'
                }
            },
            j_stpck_jimbosinferno = {
                name = "Jimbo's Inferno",
                text = {
                    '{C:green}1 in 3{} chance to destroy',
					'Played {C:hearts}Heart{} cards',
					'Cards destroyed by Joker grant {C:mult}+10{} Mult'
                }
            },
            j_stpck_spaceshiplicense = {
                name = "Spaceship License",
                text = {
                    'NOT IMPLEMENTED YET'
                }
            },
            j_stpck_steamhappy = {
                name = ":steamhappy:",
                text = {
                    ':D'
                }
            },
            j_stpck_realisticjoker = {
                name = "Realistic Joker",
                text = {
                    'NOT IMPLEMENTED YET'
                }
            },
            j_stpck_deepblues = {
                name = "Deep Blues",
                text = {
                    'Playing a hand with a King, Queen, and Ace',
					'Grants {C:mult} x2.5{} Mult'
                }
            },
            j_stpck_cloverjoker = {
                name = "Clover",
                text = {
                    'NOT IMPLEMENTED YET'
                }
            },
            j_stpck_jokerbot = {
                name = "JokerBot",
                text = {
                    'NOT IMPLEMENTED YET'
                }
            },
            j_stpck_wonderflower = {
                name = "Wonder Flower",
                text = {
                    'NOT IMPLEMENTED YET'
                }
            },
            j_stpck_xray = {
                name = "X-Ray",
                text = {
                    'NOT IMPLEMENTED YET'
                }
            },
            j_stpck_warioapparition = {
                name = "Wario Apparition",
                text = {
                    '{C:mult}+20{} Mult',
					'{C:money} $-5{} when Blind is selected'

                }
            }
        }
    }
}