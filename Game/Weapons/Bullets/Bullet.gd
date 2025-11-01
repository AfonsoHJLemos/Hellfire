class_name Bullet extends Area2D


@export var time: float = 1.0

@onready var timer: Timer = $Timer
@onready var tip: Node2D = $Tip

const bulletSplash = preload("uid://dx20rwtjjiwh1")

var bulletSpeed: int = 250
var bulletRange: int = 100
var currentRange: float = 0


func _ready() -> void:
	timer.wait_time = time
	timer.start()

func init(stats: WeaponStats) -> void:
	bulletSpeed = stats.bulletSpeed
	bulletRange = stats.bulletRange

func _physics_process(delta: float) -> void:
	var distance: Vector2 = (Vector2.RIGHT * bulletSpeed * delta).rotated(rotation)
	global_position += distance
	currentRange += distance.length()
	
	if currentRange >= bulletRange:
		despawn()

func _on_area_entered(_area: Area2D) -> void:
	despawn()

func _on_body_entered(_body: Node2D) -> void:
	despawn()

func _on_timer_timeout() -> void:
	despawn()

func despawn() -> void:
	var instance: GPUParticles2D = bulletSplash.instantiate()
	instance.global_position = tip.global_position
	$"..".add_child(instance)
	queue_free()
