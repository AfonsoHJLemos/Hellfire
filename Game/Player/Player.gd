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

var dir: Vector2 = Vector2.ZERO
var lastDir: Vector2 = Vector2.ZERO
var isDashing: bool = false
var canDash: bool = true


func _ready() -> void:
	dashTimer.wait_time = dashTime
	dashDelay.wait_time = dashDelayTime

func _physics_process(_delta: float) -> void:
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
	if (dir.x != 0):
		animationPlayer.play("Walk" + ("Left" if dir.x < 0 else "Right"))
		return
	if (dir.y != 0):
		animationPlayer.play("Walk" + ("Up" if dir.y < 0 else "Down"))
		return
	
	if (lastDir.x != 0):
		animationPlayer.play("Idle" + ("Left" if lastDir.x < 0 else "Right"))
		return
	if (lastDir.y != 0):
		animationPlayer.play("Idle" + ("Up" if lastDir.y < 0 else "Down"))
		return
