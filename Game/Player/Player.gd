class_name Player extends CharacterBody2D


@export_group("Movement")
@export var speed: float = 100.0
@export var accel: float = 0.9
@export var decel: float = 0.1
@export var dashSpeed: float = 500.0
@export var dashTime: float = 0.1
@export var dashDelayTime: float = 5.0

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var dashTimer: Timer = $Timers/DashTimer
@onready var dashDelay: Timer = $Timers/DashDelay
@onready var ghostEffect: GhostEffect = $GhostEffect
@onready var pivot: Node2D = $Pivot
@onready var weapon: Weapon = $Pivot/Weapon

var dir: Vector2 = Vector2.ZERO
var lastDir: Vector2 = Vector2.ZERO
var isDashing: bool = false
var canDash: bool = true
var mousePos: Vector2 = Vector2.ZERO


func _ready() -> void:
	dashTimer.wait_time = dashTime
	dashDelay.wait_time = dashDelayTime
	
	weapon.isFlipped = !(pivot.rotation > PI / 2 and pivot.rotation < 3 * PI / 2)

func _physics_process(_delta: float) -> void:
	mousePos = get_global_mouse_position()
	
	if (Input.is_action_pressed("Shoot")):
		weapon.shoot()
	
	if (Input.is_action_just_pressed("Dash") && canDash):
		dash()
	
	if (isDashing):
		velocity = dir * dashSpeed
	else:
		dir = Input.get_vector("Left", "Right", "Up", "Down").normalized()
		if (dir):
			velocity = velocity.move_toward(dir * speed, speed * accel)
		else:
			velocity = velocity.move_toward(Vector2.ZERO, speed * decel)
	
	move_and_slide()
	handle_sprite()
	handle_weapon()
	
	lastDir = dir

func dash() -> void:
	isDashing = true
	
	dashTimer.start()
	ghostEffect.start()

func _on_dash_timer_timeout() -> void:
	isDashing = false
	canDash = false
	
	dashDelay.start()
	ghostEffect.stop()

func _on_dash_delay_timeout() -> void:
	canDash = true

func handle_sprite() -> void:
	var animation: String = ("Walk" if dir else "Idle")
	if (abs(global_position.x - mousePos.x) > abs(global_position.y - mousePos.y)):
		animation += ("Left" if global_position.x > mousePos.x else "Right")
	else:
		animation += ("Up" if global_position.y > mousePos.y else "Down")
	
	animationPlayer.play(animation)

func handle_weapon() -> void:
	pivot.look_at(mousePos)
	pivot.rotation = wrapf(pivot.rotation, 0, TAU)
	
	var isLeft = (pivot.rotation > PI / 2 and pivot.rotation < 3 * PI / 2)
	if (isLeft and weapon.isFlipped):
		weapon.flip()
	elif (!isLeft and !weapon.isFlipped):
		weapon.flip()
