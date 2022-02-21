node_object = {version = "0.1.0"}

local objects = setmetatable({}, {__mode = "v"})

function node_object.set(pos, object)
	local old_object = node_object.swap(pos, object)
	if old_object and old_object ~= object then old_object:remove() end
end

function node_object.get(pos)
	local hash = minetest.hash_node_position(pos)
	local object = objects[hash]
	if object and object:get_pos() == nil then
		objects[hash] = nil
		object = nil
	end
	return object
end

function node_object.swap(pos, object)
	local hash = minetest.hash_node_position(pos)
	local old_object = objects[hash]
	if old_object and old_object:get_pos() == nil then old_object = nil end
	objects[hash] = object
	return old_object
end

local function check_set(pos)
	local node = minetest.get_node(pos)
	local set = minetest.registered_nodes[node.name]._node_object_set
	if set then set(pos) end
end

minetest.register_on_mods_loaded(function()
	for name, def in pairs(minetest.registered_nodes) do
		if def._node_object_set then
			local groups = table.copy(def.groups or {})
			groups.node_object = 1
			local old_on_construct = def.on_construct
			local function on_construct(pos, ...)
				minetest.after(0, check_set, vector.new(pos))
				if old_on_construct then
					return old_on_construct(pos, ...)
				end
			end
			local old_on_destruct = def.on_destruct
			local function on_destruct(pos, ...)
				node_object.set(pos)
				if old_on_destruct then
					return old_on_destruct(pos, ...)
				end
			end
			local old_on_movenode = def.on_movenode
			local function on_movenode(from_pos, to_pos, ...)
				node_object.set(from_pos)
				minetest.after(0, check_set, vector.new(to_pos))
				if old_on_movenode then
					return old_on_movenode(
						from_pos, to_pos, ...)
				end
			end
			minetest.override_item(name, {
				groups = groups,
				on_construct = on_construct,
				on_destruct = on_destruct,
				on_movenode = on_movenode,
			})
		end
	end
end)

minetest.register_lbm({
	label = "Creating node objects",
	name = "node_object:create",
	nodenames = {"group:node_object"},
	run_at_every_load = true,
	action = function(pos, node)
		minetest.registered_nodes[node.name]._node_object_set(pos)
	end,
})
