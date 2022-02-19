minetest.register_entity("spinner_node:spinner", {
	initial_properties = {
		visual = "cube",
		visual_size = {x = 0.6, y = 0.6},
		textures = {
			"spinner_node_side.png", "spinner_node_side.png",
			"spinner_node_side.png", "spinner_node_side.png",
			"spinner_node_side.png", "spinner_node_side.png",
		},
		use_texture_alpha = true,
		physical = false,
		static_save = false,
		pointable = false,
		automatic_rotate = math.pi,
	},
})
if minetest.global_exists("mesecon") and mesecon.register_mvps_unmov then
	mesecon.register_mvps_unmov("spinner_node:spinner")
end

local function set_node_object(pos)
	local object = minetest.add_entity(pos, "spinner_node:spinner")
	if not object then return end
	object:set_yaw(math.random() * 2 * math.pi)
	node_object.set(pos, object)
end

minetest.register_node("spinner_node:spinner", {
	description = "Spinner",
	drawtype = "allfaces",
	tiles = {"spinner_node_side.png"},
	use_texture_alpha = "clip",
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 1, oddly_breakable_by_hand = 3},
	_node_object_set = set_node_object,
})
