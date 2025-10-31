class_name GhostEffect extends Node


@export var sprite: Sprite2D
@export var interval: float = 0.1
@export var fadeTime: float = 0.5
@export var fadeColor: Color = Color.TRANSPARENT

@onready var timer: Timer = $Timer


func _ready() -> void:
	timer.wait_time = interval

func start() -> void:
	timer.start()

func stop() -> void:
	timer.stop()

func _on_timer_timeout() -> void:
	spawn_ghost()

func spawn_ghost() -> void:
	var newSprite: Sprite2D = Sprite2D.new()
	newSprite.texture = sprite.texture
	newSprite.hframes = sprite.hframes
	newSprite.vframes = sprite.vframes
	newSprite.frame = sprite.frame
	newSprite.global_position = sprite.global_position
	add_child(newSprite)
	
	var tween = get_tree().create_tween()
	tween.tween_property(newSprite, "self_modulate", fadeColor, fadeTime)
	await tween.finished
	newSprite.queue_free()
