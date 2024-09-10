extends Node

const SAVE_JSON := "user://save.json"

var player_current_attack = false

var current_scene = "world"
var transition_scene = false

var found_slimes_item = false
var given_slimes_teim = false

var boss_dead = false

var game_first_loadin = true

var player_start_posx = -401
var player_start_posy = 580

var player_exit_posx = 1291
var player_exit_posy = 256

var time = 0
var finish_time = INF

var saved_finish_time = false

func _process(delta):
	time += delta

func update_finish_time():
	if saved_finish_time == false:
		finish_time = time
		# Some method of displaying time to player, saving to file, or sending signal to server
		
		OS.alert(finish_time, 'Finish Time')
		#save_json()
		saved_finish_time = true

func finish_changescenes():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "world":
			current_scene = "cave"
		else:
			current_scene = "world"

func save_json() -> void:
	# Create a dictionary to hold the finish_time data
	var output := {
		"finish_time": finish_time
	}
	# Convert the dictionary to a JSON string
	var json := JSON.stringify(output)
	# Save the resulting JSON to a file using the `File` class in write mode
	var file := JSON.new()
	file.open(SAVE_JSON, JSON)
	# Store the JSON string in the file
	file.store_string(json)
	# Clean up
	file.close()
