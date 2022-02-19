std = "lua51c"

max_line_length = 80

globals = {"node_object"}

read_globals = {"minetest", "table.copy"}

files["example/init.lua"] = {
	read_globals = {"default", "mesecon"},
}
