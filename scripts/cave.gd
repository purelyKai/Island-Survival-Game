extends Node2D

func _process(delta):
	change_scenes()


func _on_cavedoor_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true


func _on_cavedoor_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false


func change_scenes():
	if global.transition_scene == true:
		if global.current_scene == "cave":
			if Input.is_action_just_pressed("interaction"):
				get_tree().change_scene_to_file("res://scenes/world.tscn")
				global.finish_changescenes()
			
