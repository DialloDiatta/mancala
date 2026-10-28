extends TextureButton
class_name BoardSelectButton

@export_group("Skin Select")

@export var board_resource: Board

@export var skin_texture: Texture2D
@export var skin_type: String = "board"

var outline: Material = preload("res://resources/outline_shader_material.tres")
var originalMaterial

@export_group("Hover Variables")
@export var tween_intensity: float = 1.03
@export var tween_duration: float = 0.1

@onready var button = self


func _ready() -> void :
    toggled.connect(_on_toggled)

    mouse_entered.connect(_on_mouse_entered)
    mouse_exited.connect(_on_mouse_exited)


    pivot_offset = size / 2
    originalMaterial = material




    skin_texture = texture_normal

func start_tween(object: Object, property: String, final_val: Variant, duration: float):
    var tween = create_tween()
    tween.tween_property(object, property, final_val, duration)

func _on_mouse_entered():
    print("something")
    start_tween(self, "scale", Vector2.ONE * tween_intensity, tween_duration)

func _on_mouse_exited():
    start_tween(self, "scale", Vector2.ONE, tween_duration)

func _on_toggled(toggled_on: bool):
    print(toggled_on)
    if toggled_on:
        material = outline
        SkinManager.assign_skin(skin_type, skin_texture)
    else:
        material = originalMaterial
