### Main.gd

extends Node2D

# Node refs
@onready var game_panel = $GamePanel
@onready var game_mode_popup = $GamePanel/StartScreen/GameModePopup
### NEW
@onready var environment_slection_popup = $GamePanel/StartScreen/EnvironmentSelectionPopup
### END NEW
@onready var ai_selection_popup = $GamePanel/StartScreen/AISelectionPopup
@onready var ai_player_amount = $GamePanel/StartScreen/AISelectionPopup/Border/Container/AIAmountTextEdit
@onready var error_label = $GamePanel/StartScreen/AISelectionPopup/Border/Container/ErrorLabel
@onready var load_game_button = $GamePanel/StartScreen/LoadGameButton
@onready var level_info = $GamePanel/StartScreen/LevelInfo
@onready var last_saved_level = $GamePanel/StartScreen/LevelInfo/Label
@onready var game_info_screen = $GamePanel/StartScreen/GameInfoScreen

# Music Node refs
@onready var menu_music = $GameMusic/MenuMusic
@onready var button_click_sfx = $GameMusic/ButtonClick_SFX

func _ready():
	game_panel.visible = true
	check_for_save_file()
	update_last_saved_level_label()
	# Cursor state
	Global.activate_cursor()
	# Music state
	menu_music.play()
	
# Play click sound effect
func _input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if Global.can_play_button_sfx == true:
			button_click_sfx.play()
			
# ------------------------ Main Menu Buttons -------------------------	
# Start new game
func _on_new_game_button_pressed():
	Global.current_level = 1
	environment_slection_popup.show() ###NEW
	#game_mode_popup.show() ###original

# Load game
func _on_load_game_button_pressed():
	if SaveLoadManager.is_save_file_exists():
		SaveLoadManager.load_game()
		environment_slection_popup.show()
		
# Exit game
func _on_exit_game_button_pressed():
	get_tree().quit()

# ------------------------ Game Start Logic -------------------------
# Create an instance of our Level scene
func start_level():
	game_panel.visible = false
	var level = Global.level_scene.instantiate()
	add_child(level)
	get_tree().paused = false
	# Music state
	menu_music.stop()
	Global.can_play_button_sfx = false

# ------------------------ Game Mode Logic -------------------------
# NORMAL Mode
func _on_normal_mode_button_pressed():
	game_mode_popup.hide()
	Global.current_game_mode = Global.GameMode.NORMAL
	start_level()

# BATTLE Mode
func _on_battle_mode_button_pressed():
	game_mode_popup.hide()
	ai_selection_popup.show() #move into environment selection
	
	###
	
#Environment selections
func _on_environment_button_1_pressed():
	Global.current_environment = Global.Environments.DEFAULT
	game_mode_popup.show()

func _on_environment_button_2_pressed():
	Global.current_environment = Global.Environments.BEACH
	game_mode_popup.show()

func _on_environment_button_3_pressed():
	Global.current_environment = Global.Environments.GREEN
	game_mode_popup.show()
	
	
	###

# Hide popups
func _on_close_button_pressed():
	game_mode_popup.hide()
	ai_selection_popup.hide()
	game_info_screen.hide()
	environment_slection_popup.hide() ###NEW

# ------------------------ AI Selection Logic -------------------------
func _on_start_button_pressed():
	#fetch values
	Global.number_of_ai_players = int(ai_player_amount.text)
	Global.current_game_mode = Global.GameMode.BATTLE
	#err handling
	if Global.number_of_ai_players > 3 or Global.number_of_ai_players == 0:
		error_label.visible = true
	#start game
	else:
		ai_selection_popup.hide()
		start_level()

# ------------------------ Load Game Logic ------------------------------
func check_for_save_file():
	if SaveLoadManager.is_save_file_exists():
		level_info.visible = true
		load_game_button.disabled = false
	else:
		level_info.visible = false
		load_game_button.disabled = true 
		
func update_last_saved_level_label():
	var last_saved_level_value = SaveLoadManager.get_last_saved_level()
	last_saved_level.text = str("LAST SAVED LEVEL: ", last_saved_level_value)

# ------------------------ Game Info Screen ------------------------------
func _on_game_info_button_pressed():
	game_info_screen.visible = true



