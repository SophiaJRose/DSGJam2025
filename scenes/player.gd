extends CharacterBody3D

@export var player_slot: int = -1
@export var device_id: int = -1

var vulnerable: bool = false

const SPEED = 32.0
const JUMP_VELOCITY = 48.0
const gravity = 112.0
const copy_offsets = [256, -256]

@onready var animations = $AnimatedSprite3D
@onready var copy = $Copy
@onready var copyAnimations = $Copy/AnimatedSprite3D
@onready var jump_action = "Jump P%s" % player_slot
@onready var left_action = "Left P%s" % player_slot
@onready var right_action = "Right P%s" % player_slot

func _physics_process(delta: float) -> void:
	# Handle jump and gravity
	if Input.is_action_just_pressed(jump_action) and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if velocity.y >= 0 and !Input.is_action_pressed(jump_action):
		velocity.y /= 2
	if velocity.y >= 0 and Input.is_action_pressed(jump_action):
		velocity.y -= (gravity / 2) * delta
	else:
		velocity.y -= (gravity) * delta
	var direction := Input.get_axis(left_action, right_action)
	if direction:
		velocity.x = direction * SPEED
		animations.scale.x = -sign(direction)
		animations.play(("Walk P%s Vuln" if vulnerable else "Walk P%s") % player_slot)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animations.play(("Stand P%s Vuln" if vulnerable else "Stand P%s") % player_slot)
	move_and_slide()
	copy.global_position = Vector3(position.x + copy_offsets[player_slot-1], position.y, position.z)
	copyAnimations.play(animations.animation)
	copyAnimations.scale.x = animations.scale.x

func _on_world_rotation_area_entered(area):
	vulnerable = true

func _on_world_rotation_area_exited(area):
	vulnerable = false
