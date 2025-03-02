extends CharacterBody3D

signal player_damage(player:int, health: int)

@export var player_slot: int = -1
@export var device_id: int = -1

var vulnerable: bool = false
var direction: float = 1.0
var sword_active: bool = false
var sword_end_timer: int = 0
var health: int = 3

const SPEED = 32.0
const JUMP_VELOCITY = 48.0
const gravity = 112.0
const copy_offsets = [256, -256]
const sword_start_angle = deg_to_rad(60)
const sword_end_angle = deg_to_rad(-45)
const sword_end_hold = 20

@onready var animations = $AnimatedSprite3D
@onready var copy = $Copy
@onready var copyAnimations = $Copy/AnimatedSprite3D
@onready var sword = $Sword
@onready var swordSprite = $Sword/SwordArea/SwordSprite
@onready var swordCopy = $Copy/SwordCopy
@onready var swordCopySprite = $Copy/SwordCopy/SwordArea/SwordSprite
@onready var jump_action = "Jump P%s" % player_slot
@onready var left_action = "Left P%s" % player_slot
@onready var right_action = "Right P%s" % player_slot

func _ready():
	swordSprite.play("P%s" % player_slot)
	swordCopySprite.play("P%s" % player_slot)

func _unhandled_input(event):
	if event.is_action_pressed("Melee P%s" % player_slot):
		## Start sword swing
		sword_active = true
		sword.visible = true
		swordCopy.visible = true
		sword_end_timer = 0
		if animations.scale.x == 1:
			sword.rotation.y = deg_to_rad(180)
			swordCopy.rotation.y = deg_to_rad(180)
		else:
			sword.rotation.y = 0
			swordCopy.rotation.y = 0
		sword.rotation.z = sword_start_angle
		swordCopy.rotation.z = sword_start_angle
	elif event.is_action_pressed("Mine P%s" % player_slot):
		## do lay mine
		pass

func _physics_process(delta: float) -> void:
	# Handle sword movement
	if sword.rotation.z > sword_end_angle:
		sword.rotation.z -= deg_to_rad(10.5)
		swordCopy.rotation.z -= deg_to_rad(10.5)
	else:
		sword_end_timer += 1
		if (sword_end_timer >= sword_end_hold):
			sword_active = false
			sword.visible = false
			swordCopy.visible = false
			sword_end_timer = 0
			sword.rotation.y = deg_to_rad(90)
			swordCopy.rotation.y = deg_to_rad(90)
	# Handle jump and gravity
	if Input.is_action_just_pressed(jump_action) and is_on_floor():
		velocity.y = JUMP_VELOCITY
	if velocity.y >= 0 and !Input.is_action_pressed(jump_action):
		velocity.y /= 2
	if velocity.y >= 0 and Input.is_action_pressed(jump_action):
		velocity.y -= (gravity / 2) * delta
	else:
		velocity.y -= (gravity) * delta
	direction = Input.get_axis(left_action, right_action)
	if direction:
		velocity.x = direction * SPEED
		animations.scale.x = -sign(direction)
		#animations.play(("Walk P%s Vuln" if vulnerable else "Walk P%s") % player_slot)
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

func _on_b_box_area_entered(area):
	if area.is_in_group("Sword") and vulnerable:
		health -= 1
		player_damage.emit(player_slot, health)
		if health == 0:
			queue_free()
