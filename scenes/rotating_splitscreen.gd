extends Control

@onready var topCam: Camera3D = $TopScreenContainer/TopScreenViewport/TopScreenCam
@onready var bottomCam: Camera3D = $BottomScreenContainer/BottomScreenViewport/BottomScreenCam
@onready var worldRotationAreaA: Area3D = $BottomScreenContainer/WorldRotationAreaA
@onready var worldRotationAreaB: Area3D = $TopScreenContainer/WorldRotationAreaB

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rotation += 0.75 * delta
	topCam.rotation.z = -rotation
	bottomCam.rotation.z = -rotation
	worldRotationAreaA.rotation.z = -rotation
	worldRotationAreaB.rotation.z = -rotation
