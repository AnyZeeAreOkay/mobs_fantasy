
local S = mobs.intllib




mobs:register_mob("mobs_fantasy:fire_elemental", {
	type = "monster",
	passive = false,
	damage = 3,
	attack_type = "shoot",
	shoot_interval = 0.5,
	arrow = "mobs_fantasy:firebolt",
	shoot_offset = 2,
	hp_min = 10,
	hp_max = 25,
	armor = 80,
	collisionbox = {-0.5, -1.5, -0.5, 0.5, 0.5, 0.5},
	visual = "mesh",
	mesh = "fire_elemental.obj",
	textures = "coal.png",

	blood_texture = "default_mese_crystal_fragment.png",
	makes_footstep_sound = false,
	sounds = {
		random = "mobs_mesemonster",
	},
	view_range = 30,
	visual_size = {x=14, y=4},
	fly = true,
	attack_monsters = true,
	walk_velocity = 5,
	run_velocity = 20,
	jump = true,
	jump_height = 8,
	fall_damage = 0,
	fall_speed = 1,
	stepheight = 10.1,
	drops = {
		{name = "default:mese_crystal", chance = 9, min = 0, max = 2},
		{name = "default:mese_crystal_fragment", chance = 1, min = 0, max = 2},
	},
	water_damage = 4,
	lava_damage = 0,
	light_damage = 0,
	animation = {
		speed_normal = 15,
		speed_run = 10,
		stand_start = 0,
		stand_end = 14,
		walk_start = 15,
		walk_end = 38,
		run_start = 40,
		run_end = 63,
		punch_start = 40,
		punch_end = 63,
	},
	do_custom = function(self)
	local apos = self.object:get_pos()
	 local vec = self.object:get_velocity()
	 local part = minetest.add_particlespawner(
		 1, --amount
		 0.3, --time
		 {x=apos.x-0.3, y=apos.y-0.4, z=apos.z-0.3}, --minpos
		 {x=apos.x+0.3, y=apos.y+0.4, z=apos.z+0.3}, --maxpos
		 {x=-0, y=-0, z=-0}, --minvel
		 {x=.2, y=.2, z=.2}, --maxvel
		 {x=1,y=1,z=1}, --minacc
		 {x=-vec.x,y=0,z=-vec.z}, --maxacc
		 0.5, --minexptime
		 1.5, --maxexptime
		 1, --minsize
		 1, --maxsize
		 false, --collisiondetection
		 "mobs_fireball.png" --texture
	 )

	end,
})


mobs:spawn({
	name = "mobs_fantasy:fire_elemental",
	nodes = {"default:stone", "default:lava_source"},
	max_light = 14,
	chance = 300,
	active_object_count = 1,
	max_height = 200,
})


mobs:register_egg("mobs_fantasy:fire_elemental", S("Fire Elemental"), "default_lava.png", 1)


mobs:alias_mob("mobs:fire_elemental", "mobs_fantasy:fire_elemental") -- compatiblity


-- mese arrow (weapon)
mobs:register_arrow("mobs_fantasy:firebolt", {
	visual = "sprite",
	visual_size = {x = 1, y = 1},
	textures = {"mobs_fireball.png"},
	collisionbox = {-0.1, -0.1, -0.1, 0.1, 0.1, 0.1},
	velocity = 14,
	tail = 1,
	tail_texture = "mobs_fireball.png",
	tail_size = 1,
	glow = 8,
	expire = 0.1,

	on_activate = function(self, staticdata, dtime_s)
		-- make fireball indestructable
		self.object:set_armor_groups({immortal = 1, fleshy = 100})
	end,

	-- if player has a good weapon with 7+ damage it can deflect fireball
	on_punch = function(self, hitter, tflp, tool_capabilities, dir)

		if hitter and hitter:is_player() and tool_capabilities and dir then

			local damage = tool_capabilities.damage_groups and
				tool_capabilities.damage_groups.fleshy or 1

			local tmp = tflp / (tool_capabilities.full_punch_interval or 1.4)

			if damage > 6 and tmp < 4 then

				self.object:set_velocity({
					x = dir.x * self.velocity,
					y = dir.y * self.velocity,
					z = dir.z * self.velocity,
				})
			end
		end
	end,

	-- direct hit, no fire... just plenty of pain
	hit_player = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 8},
		}, nil)
	end,

	hit_mob = function(self, player)
		player:punch(self.object, 1.0, {
			full_punch_interval = 1.0,
			damage_groups = {fleshy = 8},
		}, nil)
	end,

	-- node hit
	hit_node = function(self, pos, node)
		mobs:boom(self, pos, 1)
	end
})

--minetest.override_item("default:obsidian", {on_blast = function() end})
