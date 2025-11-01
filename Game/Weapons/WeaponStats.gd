class_name WeaponStats extends Resource


@export_group("Setup")
@export var sprite: Texture2D
@export var handlePos: Vector2
@export var muzzlePos: Vector2

@export_group("Stats")
@export var damage: int
@export var numBullets: int
@export var fireRate: int
@export var bulletRange: int
@export var bulletSpeed: int
@export var spread: int


func _init(newDamage = 0, newNumBullets = 0, newFireRate = 0,
			newBulletRange = 0, newBulletSpeed = 0, newSpread = 0):
	damage = newDamage
	numBullets = newNumBullets
	fireRate = newFireRate
	bulletRange = newBulletRange
	bulletSpeed = newBulletSpeed
	spread = newSpread
