
extends Node
class_name SkinSelectButton

@onready var parent_button = $".."
@export var skin_texture: Texture2D
@export var skin_type: String

var outline: Material = preload("res://resources/outline_shader_material.tres")

var originalMaterial

func _ready() -> void :
    parent_button.toggled.connect(_on_toggled)
    originalMaterial = parent_button.material
    print("Toggle Mode: ", parent_button.toggle_mode)
    print("Toggled: ", parent_button.toggled)


func _on_toggled(toggled_on: bool):
    print(toggled_on)
    if toggled_on:
        parent_button.material = outline
        SkinManager.assign_skin(skin_type, skin_texture)
    else:
        parent_button.material = originalMaterial
