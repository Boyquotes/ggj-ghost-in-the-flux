extends Control

@export_file() var credits_file

@export_group("Nodes")
@export var credits_text : MarkdownLabel
@export var back_button : BaseButton

func _ready() -> void:
	credits_text.display_file(credits_file)
	back_button.pressed.connect(on_back_pressed)

func on_back_pressed():
	SceneManager.change_to_packed_with_default_transition(Global.settings.main_menu_scene)
