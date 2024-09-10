extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	if global.game_first_loadin == true:
		global.time = 0
		$player.position.x = global.player_start_posx
		$player.position.y = global.player_start_posy
		DialogueManager.show_example_dialogue_balloon(load("res://dialogue/main.dialogue"),"main")
	else:
		$player.position.x = global.player_exit_posx
		$player.position.y = global.player_exit_posy

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_scene()

func _on_cavedoor_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true

func _on_cavedoor_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "world":
			if Input.is_action_just_pressed("interaction"):
				get_tree().change_scene_to_file("res://scenes/cave.tscn")
				global.game_first_loadin = false
				global.finish_changescenes()
