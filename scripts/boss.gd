extends CharacterBody2D

var speed = 80
var player_chase = false
var player = null
var health = 300
var player_inattack_zone = false
var can_take_damage = true
var is_dead = false

func _ready():
	if global.boss_dead:
		queue_free()
	

func _physics_process(delta):
	deal_with_damage()
	update_health()
	if !is_dead:
		if player_chase:
			position += (player.position - position)/speed
			if !player_inattack_zone:
				if health > 200:
					$AnimatedSprite2D.play("walk1")
				elif health < 200:
					$AnimatedSprite2D.play("walk2")
			elif player_inattack_zone:
				if health > 200:
					$AnimatedSprite2D.play("attack1")
				elif health < 200:
					$AnimatedSprite2D.play("attack2")
				
			if(player.position.x - position.x) < 0:
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.flip_h = false
				
		else:
			if health >= 200:
				$AnimatedSprite2D.play("idle")
			elif health < 200:
				$AnimatedSprite2D.play("idle2")
	elif is_dead:
			$AnimatedSprite2D.play("death")
			$death_ani.start()
			queue_free()
			

func _on_detection_area_body_entered(body):
	player = body
	player_chase = true
	


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false


func boss():
	pass


func _on_enemy_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_zone = true


func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_zone = false



func deal_with_damage():
	if is_dead:
		return
	elif player_inattack_zone and global.player_current_attack == true:
		if can_take_damage == true:
			if health > 200:
				health -= 40
			elif health < 200:
				health -= 20
			print("enemy health: " + str(health))
			$take_damage_cooldown.start()
			can_take_damage = false
			if health < 0:
				is_dead = true
				global.boss_dead = true


func _on_take_damage_cooldown_timeout():
	can_take_damage = true
	
	
func update_health():
	var healthbar = $healthbar
	
	healthbar.value = health
	
	if health >= 300:
		healthbar.visible = false
	else:
		healthbar.visible = true
	



func _on_death_ani_timeout():
	print("It has been 7 seconds")
	queue_free() 
