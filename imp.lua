local function find_free_position_near(pos)
	local tries = {
		{x=1,y=0,z=0},
		{x=-1,y=0,z=0},
		{x=0,y=0,z=1},
		{x=0,y=0,z=-1},
	}
	for _,d in pairs(tries) do
		local p = vector.add(pos, d)
		if not minetest.registered_nodes[minetest.get_node(p).name].walkable then
			return p, true
		end
	end
	return pos, false
end

mobs:register_mob("mobs_fantasy:imp", {
	type = "monster",
	can_dig = true,
	passive = true,
	reach = 1,
	damage = 1,
	attack_type = "dogfight",
	hp_min = 15,
	hp_max = 20,
	armor = 10,
	collisionbox = {-0.4, -0.3, -0.4, 0.4, 0.8, 0.4},
	visual = "mesh",
	mesh = "gnorm.b3d",
	textures = {
		{"dmobs_gnorm.png"},
	},
	blood_texture = "mobs_blood.png",
	visual_size = {x=.5, y=.5},
	makes_footstep_sound = true,
	runaway = true,
	walk_velocity = 3,
	run_velocity = 6,
	jump = true,
	water_damage = 0,
	lava_damage = 1,
	light_damage = 0,
	fall_damage = 0,
	fall_speed = -6,
	fear_height = 4,
	replace_rate = 10,
	replace_what = {"default:apple", "default:stone", "default:stone_with_coal", "default:fence_wood"},
	replace_with = "air",
	follow = {"default:apple"},
	view_range = 20,
	animation = {
		speed_normal = 8,
		speed_run = 30,
		walk_start = 62,
		walk_end = 81,
		stand_start = 2,
		stand_end = 9,
		run_start = 62,
		run_end = 81,
		punch_start = 1,
		punch_end = 1,

	},
  drops = {
		{name = "default:mese_crystal", chance = 9, min = 1, max = 2},
		{name = "default:goldblock", chance = 1, min = 0, max = 2},
	},
  do_custom = function(self)
	local apos = self.object:get_pos()
			--ripped from teleport request mod - tpj function, with some changes by me
  function tpj(imp, param)
  	local pname = self.name
    minetest.sound_play("imp_scream", {pos = apos, gain = 1, max_hear_distance = 15})
    minetest.add_particlespawner(50, 0.4,
      {x=apos.x, y=apos.y + 5, z=apos.z}, {x=apos.x - 0.5, y=apos.y, z=apos.z - 0.5},
      {x=0, y=-5, z=0}, {x=0, y=0, z=0},
      {x=0, y=-5, z=0}, {x=0, y=0, z=0},
      3, 5,
      3, 5,
      false,
      "tps_portal_parti.png")


  	local args = param:split(" ") 
  	local target_coords = apos
  	if args[1] == "x" then
  		target_coords["x"] = target_coords["x"] + tonumber(args[2])
  	elseif args[1] == "y" then
  		target_coords["y"] = target_coords["y"] + tonumber(args[2])
  	elseif args[1] == "z" then
  		target_coords["z"] = target_coords["z"] + tonumber(args[2])

  	self.object:set_pos(find_free_position_near(target_coords))

  	minetest.sound_play("whoosh", {pos = target_coords, gain = 0.5, max_hear_distance = 20})
    minetest.add_particlespawner(50, 0.4,
  		{x=target_coords.x, y=target_coords.y + 5, z=target_coords.z}, {x=target_coords.x - 0.5, y=target_coords.y, z=target_coords.z - 0.5},
  		{x=0, y=-5, z=0}, {x=0, y=0, z=0},
  		{x=0, y=-5, z=0}, {x=0, y=0, z=0},
  		3, 5,
  		3, 5,
  		false,
  		"tps_portal_parti.png")
  end
end

for _,object in ipairs(minetest.get_objects_inside_radius(apos, 10)) do

  if object:is_player()
  or (object:get_luaentity()
  and object:get_luaentity()._cmi_is_mob == true
  and object ~= self.object) then
--ripped from teleport request mod - /tpe command
  local mindistance = 15
	local maxdistance = 30
	local negatives = { '-','' }
	local options = { 'x', 'y', 'z' }
	local isnegative = ''
	local distance = 0
	local axis = ''
	local iteration = .5
  local imp = self.object.name
	do --removed variable number of tries, since it's not needed for this.
		-- do this every 1 second
		minetest.after(iteration,
			function()
				isnegative = negatives[math.random(2)] -- choose randomly whether this is this way or that
				distance = isnegative .. math.random(mindistance,maxdistance) -- the distance to jump
				axis = options[math.random(3)]
				local command = axis .. " " .. distance
				tpj(imp,command)
			end
		)
		iteration = iteration + 1
	end
end
end
end
})

mobs:register_egg("mobs_fantasy:imp", "Imp", "default_lava.png", 1)
