local S = technic.worldgen.gettext

local function for_each_registered_item(action)
	local already_reg = {}
	for k, _ in pairs(minetest.registered_items) do
		table.insert(already_reg, k)
	end
	local really_register_craftitem = minetest.register_craftitem
	minetest.register_craftitem = function(name, def)
		really_register_craftitem(name, def)
		action(string.gsub(name, "^:", ""))
	end
	local really_register_tool = minetest.register_tool
	minetest.register_tool = function(name, def)
		really_register_tool(name, def)
		action(string.gsub(name, "^:", ""))
	end
	local really_register_node = minetest.register_node
	minetest.register_node = function(name, def)
		really_register_node(name, def)
		action(string.gsub(name, "^:", ""))
	end
	for _, name in ipairs(already_reg) do
		action(name)
	end
end

local steel_to_iron = {}
local steel_to_iron_desc = {}
for _, i in pairs({
  {"default:axe_steel", S("Iron Axe")},
  {"default:pick_steel", S("Iron Pickaxe")},
  {"default:shovel_steel", S("Iron Shovel")},
  {"default:sword_steel", S("Iron Sword")},
  {"doors:door_steel", S("Iron Door")},
  {"farming:hoe_steel", S("Iron Hoe")},
  {"glooptest:hammer_steel", S("Iron Hammer")},
  {"glooptest:handsaw_steel", S("Iron Handsaw")},
  {"glooptest:reinforced_crystal_glass", S("Steel-Reinforced Crystal Glass")},
  {"mesecons_doors:op_door_steel", S("Iron Door")},
  {"mesecons_doors:sig_door_steel", S("Iron Door")},
  {"vessels:steel_bottle", S("Empty Heavy Iron Bottle")},
}) do
	steel_to_iron[i[1]] = true
  steel_to_iron_desc[i[1]] = i[2]
end

for_each_registered_item(function(item_name)
	local item_def = minetest.registered_items[item_name]
	if steel_to_iron[item_name] and string.find(item_def.description, "Steel") then
	  minetest.override_item(item_name, { description = steel_to_iron_desc[item_name] })
  end
end)
