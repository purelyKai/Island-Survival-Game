extends CharacterBody2D

var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 200
var player_alive = true

var attack_ip = false
var slime_in_range = false
var npcCave_in_range = false
var npc2_in_range = false
var goatMan_in_range = false
const speed = 100
var current_dir = "none"
var snakk = false
func _ready():
	$AnimatedSprite2D.play("front_idle")

func _physics_process(delta):
	if slime_in_range == true:
		if Input.is_action_just_pressed("interaction"):
			DialogueManager.show_example_dialogue_balloon(load("res://dialogue/npc.dialogue"), "npc")
	if npcCave_in_range == true:
		if Input.is_action_just_pressed("interaction"):
			DialogueManager.show_example_dialogue_balloon(load("res://dialogue/npcCave.dialogue"), "npcCave")
	if npc2_in_range == true:
		if Input.is_action_just_pressed("interaction"):
			DialogueManager.show_example_dialogue_balloon(load("res://dialogue/npc2.dialogue"), "npc2")
	if goatMan_in_range == true:
		if Input.is_action_just_pressed("interaction"):
			DialogueManager.show_example_dialogue_balloon(load("res://dialogue/goatMan.dialogue"), "goatMan")		
	player_movement(delta)
	enemy_attack()
	attack()
	update_health()
	#add respawn screen here
	if health <= 0:
		player_alive = false  
		health = 0
		$AnimatedSprite2D.play("dead")
		#self.queue_free()
		get_tree().reload_current_scene()

func player_movement(delta):
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"):
		current_dir = "right"
		play_anim(1)
		velocity.x = speed
		velocity.y = 0
	elif Input.is_action_pressed("ui_up") or Input.is_action_pressed("move_up"):
		current_dir = "up"
		play_anim(1)
		velocity.x = 0
		velocity.y = -speed
	elif Input.is_action_pressed("ui_down") or Input.is_action_pressed("move_down"):
		current_dir = "down"
		play_anim(1)
		velocity.x = 0
		velocity.y = speed
	elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("move_left"):
		current_dir = "left"
		play_anim(1)
		velocity.x = -speed
		velocity.y = 0
	else:
		play_anim(0)
		velocity.x = 0
		velocity.y = 0

	
	move_and_slide()
	
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("side_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("side_idle")
	if dir == "down":
		anim.flip_h = true
		if movement == 1:
			anim.play("front_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("front_idle")
	if dir == "up":
		anim.flip_h = true
		if movement == 1:
			anim.play("back_walk")
		elif movement == 0:
			if attack_ip == false:
				anim.play("back_idle")

func player():
	pass
		
		
var body_type;
func _on_player_hitbox_body_entered(body):
	if body.has_method("enemy"):
		body_type = "enemy"
		enemy_inattack_range = true
	elif body.has_method("enemy2") :
		body_type = "enemy2"
		enemy_inattack_range = true
	elif body.has_method("boss") :
		body_type = "boss"
		enemy_inattack_range = true


func _on_player_hitbox_body_exited(body):
	if body.has_method("enemy") or body.has_method("enemy2") or body.has_method("boss"):
		enemy_inattack_range = false

		
func enemy_attack():
	if body_type == "enemy":
		if enemy_inattack_range and enemy_attack_cooldown == true:
			health -= 10
			enemy_attack_cooldown = false
			$attack_cooldown.start()
			print("player: " + str(health))
	elif body_type == "enemy2":
		if enemy_inattack_range and enemy_attack_cooldown == true:
			health -= 15
			enemy_attack_cooldown = false
			$attack_cooldown.start()
			print("player: " + str(health))
	elif body_type == "boss":
		if enemy_inattack_range and enemy_attack_cooldown == true:
			health -= 30
			enemy_attack_cooldown = false
			$attack_cooldown.start()
			print("player: " + str(health))
	pass


func _on_attack_cooldown_timeout():
	enemy_attack_cooldown = true
	
func attack():
	var dir = current_dir
	
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("side_attack")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()
	

		
	

func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.player_current_attack = false
	attack_ip = false



func update_health():
	var healthbar = $healthbar
	
	healthbar.value = health
	
	if health >= 200:
		healthbar.visible = false
	else:
		healthbar.visible = true

func _on_regen_timer_timeout():
	if health < 200:
		health = health + 10
		if health > 200:
			health = 200
		if health <= 0:
			health = 0



func _on_detection_area_body_entered(body):
	if body.has_method("npc"):
		slime_in_range = true
	if body.has_method("npcCave"):
		npcCave_in_range = true
	if body.has_method("npc2"):
		npc2_in_range = true
	if body.has_method("goatMan"):
		goatMan_in_range = true

func _on_detection_area_body_exited(body):
	if body.has_method("npc"):
		slime_in_range = false
	if body.has_method("npcCave"):
		npcCave_in_range = false
	if body.has_method("npc2"):
		npc2_in_range = false
	if body.has_method("goatMan"):
		goatMan_in_range = false


func _on_end_game_body_entered(body):
	pass # Replace with function body.
