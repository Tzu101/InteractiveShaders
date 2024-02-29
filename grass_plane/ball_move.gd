extends CharacterBody3D


const SPEED: float = 20
const GRAVITY: float = 30

var is_floating = false

func _physics_process(delta):
	var move_direction = ($"../Camera".position - position)
	move_direction.y = 0
	move_direction = move_direction.normalized()
	
	velocity = move_direction * SPEED * delta
	
	if is_floating:
		var float_height = position.y + 0.2
		velocity.y += (GRAVITY - (GRAVITY * float_height))  * delta
		
	velocity.y -= GRAVITY * delta
	
	var angle = atan2(move_direction.x, move_direction.z) - rotation.y
	rotate_y(angle * delta)
	rotate_x(delta)
	
	move_and_slide()


func _on_ocean_body_entered(body):
	if body == self:
		is_floating = true


func _on_ocean_body_exited(body):
	if body == self:
		is_floating = false
