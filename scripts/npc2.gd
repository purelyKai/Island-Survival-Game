extends CharacterBody2D


const SPEED = 30
var current_state = IDLE
var dir = Vector2.RIGHT

var start_pos

enum {
	IDLE,
	NEW_DIR,
	MOVE
}

func npc2():
	pass

func _ready():
	randomize()
	start_pos = position
	$Timer.wait_time = choose([0.5, 1, 1.5])
	$Timer.start()

	
			
func _process(delta):
	match current_state:
		IDLE:
			$AnimatedSprite2D.play("idle")
		NEW_DIR:
			$AnimatedSprite2D.play("idle")
		MOVE:
			$AnimatedSprite2D.play("walk")


func move(delta):
	print("Move function called")
	position += dir * SPEED * delta
	if dir.x == 1:
		$AnimatedSprite2D.flip_h = false
	elif dir.x == -1:
		$AnimatedSprite2D.flip_h = true


			
func choose(array):
	array.shuffle()
	return array.front()

func _on_timer_timeout():
	$Timer.wait_time = choose([0.5, 1, 1.5])
	current_state = choose([IDLE, NEW_DIR, MOVE])
	
