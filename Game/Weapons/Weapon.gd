@tool
class_name Weapon extends Node2D


@export var stats: WeaponStats:
	set(value):
		stats = value
		if Engine.is_editor_hint():
			load_weapon()
@export var bullet: PackedScene

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $Sprite
@onready var handle: Node2D = $Handle
@onready var muzzle: Node2D = $Muzzle
@onready var fireDelay: Timer = $FireDelay

var canFire: bool = true
var isFlipped: bool


func _ready() -> void:
	load_weapon()
	
	fireDelay.wait_time = 1.0 / stats.fireRate

func load_weapon() -> void:
	sprite.texture = stats.sprite
	sprite.position = stats.handlePos
	muzzle.position = stats.muzzlePos

func shoot() -> void:
	if (!canFire):
		return
	
	canFire = false
	animationPlayer.play("Shoot")
	fireDelay.start()
	
	spawn_bullets()

func _on_fire_delay_timeout() -> void:
	canFire = true

func spawn_bullets() -> void:
	for i in range(0, stats.numBullets):
		var instance: Bullet = bullet.instantiate()
		instance.init(stats)
		instance.global_position = muzzle.global_position
		instance.rotation = $"..".rotation
		instance.rotation += deg_to_rad(randf_range(-stats.spread, stats.spread))
		$"../../../Bullets".add_child(instance)

func flip() -> void:
	self.scale.y = (-1 if isFlipped else 1) * scale.x
	isFlipped = !isFlipped
