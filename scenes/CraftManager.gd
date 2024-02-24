extends Node
class_name CraftManager

@onready var audio = $AudioStreamPlayer
@export var mp3_crafting: AudioStreamMP3
@export var mp3_success: AudioStreamMP3
var list: Dictionary = {} # List of all dropped item and what items they are colliding with

func add_item(item: DroppedItem):
	if not has_item(item):
		list[item] = {}
func has_item(item: DroppedItem) -> bool:
	return list.has(item)
func rm_item(item: DroppedItem):
	list.erase(item)
func add_link(a: DroppedItem, b: DroppedItem) -> bool:
	add_item(a)
	add_item(b)
	if list[a].has(b):
		return false # no link was created, link already existed
	list[a][b] = 1
	list[b][a] = 1
	return true
func rm_link(a: DroppedItem, b: DroppedItem):
	list[a].erase(b)
	list[b].erase(a)
func get_all_link(item: DroppedItem):
	var arr: Array[String] = []
	var merged = {item: item} # Start with the item itself
	for key in list[item]:
		merged[key] = key
		# TODO Should we do it recursively?
	# Ugly trick because the type checking is brocken in Godot4
	for i in merged.values().map(func(drop: DroppedItem) -> String: return drop.common_name):
		arr.append(i)
	return arr
func item_has_link(item: DroppedItem):
	if list.has(item) and list[item].size() > 0:
		return true
	return false


# Connectted to the function new_collision() of all DroppedItem
# Will make sure item1 and item2 are in the same entry in 'groups'
func _callback_new_collision(item1, item2):
	print("Craft manager: Something is ready to be crafted")
	if add_link(item1, item2):
		item1._start_merge_anim()
		item2._start_merge_anim()
		audio.stream = mp3_crafting
		audio.play()
		await audio.finished
		var names: Array[String] = get_all_link(item1)
		print("Item craft: ", name, " => ", get_craft(names))
		# TODO instanciate the new object
		audio.stream = mp3_success
		audio.play()

# Will make sure item1 and item2 are no longer in the same entry of 'groups'
func _callback_rm_collision(item1: DroppedItem, item2: DroppedItem):
	rm_link(item1, item2)
	if not item_has_link(item1):
		item1._stop_merge_anim()
	if not item_has_link(item2):
		item2._stop_merge_anim()

var craft_rules = [
	{
		"materials": [
			"rock",
			"rock"
		],
		"result": { # outcome
			"pile_of_rock": 10, # % of change
			"furnace": 90
		}
	},
	{
		"materials": [
			"wood",
			"wood"
		],
		"result": { # outcome
			"pile_of_wood": 10, # % of change
			"pickaxe": 90
		}
	}
]

func weighted_rnd_sel(dict: Dictionary):
	# Input: Dictionary[String : Int]
	# The int is the change in % (0% to 100%) or getting the String
	# If int is 0% then this function will never return the value
	# If int is 100%, the function will always return the value
	var sum_chance = dict.values().reduce(func(a, b): return a+b) # Should be 100, but better be safe
	var past_chance = 0
	for string in dict:
		var chance = dict[string] # probability in % to get this item
		if randi()%sum_chance+1 <= chance+past_chance:
			return string
		past_chance += chance
	assert(false, "This should never be reached")

func get_craft(names: Array[String]) -> String:
	var possible_outcomes = []
	for craft in craft_rules:
		if names == craft["materials"]:
			possible_outcomes.append(craft["result"])
	
	if possible_outcomes.is_empty():
		print("No possible outcome to the merge, cancelling...")
		return ""
	else:
		var result = possible_outcomes.pick_random()
		return weighted_rnd_sel(result) # within the randomly choosen craft, choose one possible outcome
