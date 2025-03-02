extends Control

@onready var topCam: Camera3D = $TopScreenContainer/TopScreenViewport/TopScreenCam
@onready var bottomCam: Camera3D = $BottomScreenContainer/BottomScreenViewport/BottomScreenCam
@onready var worldRotationAreaA: Area3D = $BottomScreenContainer/WorldRotationAreaA
@onready var worldRotationAreaB: Area3D = $TopScreenContainer/WorldRotationAreaB

const max_rotation = 0.75
const rotation_accel_threshold = 0.15
const rotation_thresholds = [0.15, 0.45, 0.75]
const rotation_accels = [0.001, 0.005, 0.01]
var rotation_speed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for i in rotation_thresholds.size():
		if rotation_speed < rotation_thresholds[i]:
			rotation_speed += rotation_accels[i]
			break
	rotation += rotation_speed * delta
	topCam.rotation.z = -rotation
	bottomCam.rotation.z = -rotation
	worldRotationAreaA.rotation.z = -rotation
	worldRotationAreaB.rotation.z = -rotation
