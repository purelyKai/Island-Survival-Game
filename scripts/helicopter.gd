extends CharacterBody2D

var speed = 50
var player_chase = false
var player = null
var health = 30
var player_inattack_zone = false
var can_take_damage = true


func _physics_process(delta):
		$AnimatedSprite2D.play("idle")



	
