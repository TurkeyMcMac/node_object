node_object = {version = "0.0.2"}

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

minetest.register_on_mods_loaded(function()
	for name, def in pairs(minetest.registered_nodes) do
		if def._node_object_set then
			local groups = table.copy(def.groups or {})
			groups.node_object = 1
			local old_on_construct = def.on_construct
			local function on_construct(pos, ...)
				def._node_object_set(vector.new(pos))
				if old_on_construct then
					return old_on_construct(pos, ...)
				end
			end
			local old_after_destruct = def.after_destruct
			local function after_destruct(pos, ...)
				node_object.set(pos)
				if old_after_destruct then
					return old_after_destruct(pos, ...)
				end
			end
			minetest.override_item(name, {
				groups = groups,
				on_construct = on_construct,
				after_destruct = after_destruct,
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
