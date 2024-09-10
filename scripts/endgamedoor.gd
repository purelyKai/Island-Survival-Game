extends Area2D


var entered = false




func _on_body_entered(body):
	if body.has_method("player"):
		entered = true


func _on_body_exited(body):
	if body.has_method("player"):
		entered = false
	
func _process(delta):
	if entered == true:
		if Input.is_action_just_pressed("interaction") and global.boss_dead:
			get_tree().change_scene_to_file("res://scenes/endgame.tscn")
			global.finish_changescenes()
