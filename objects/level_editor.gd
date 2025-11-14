extends Node2D

# set this constant before game start
const in_edit_mode: bool = false # change to play
var current_level_name = "RHYTHM_HELL"

# time it takes for falling key to reach critical spot
var fk_fall_time: float = 2.22
var fk_output_arr = [[], [], [], []]

var level_info = {
	"RHYTHM_HELL" = {
		"fk_times": "[[2.65439918518066, 6.66485240936279, 10.6646483230591, 10.8673012542725, 11.1126072692871, 11.656576423645, 11.8805668640137, 12.1472332763672, 14.6751015472412, 14.8457596588135, 14.9950802612305, 15.6350338745117, 15.7736962127686, 16.0190251159668, 16.1576874542236, 18.8988659667969, 19.282857208252, 22.7813370513916, 23.7306130218506, 24.1572563934326, 26.5784580993652, 26.8131058502197, 27.0370972442627, 27.2610886383057, 27.4957363891602, 27.7197277832031, 27.9543755340576, 28.1890480804443, 34.5993664550781], [3.10238101959229, 7.62480762481689, 10.6539681243896, 10.8673012542725, 11.1126072692871, 11.656576423645, 11.8805668640137, 12.1365530776978, 19.9334690856934, 23.3786385345459, 23.5279591369629, 23.9439232635498, 24.3812477874756, 34.7700245666504, 35.0793431091309, 35.3779804992676, 36.1566212463379, 38.5351460266113], [3.62501123428345, 7.13414981842041, 7.28349235534668, 8.1474373626709, 15.3577320861816, 16.3603394317627, 19.1121990966797, 19.5068257141113, 20.3174603271484, 31.8048527526855, 32.4021542358398, 34.9193432617188, 35.2180035400391, 36.1459400939941, 36.5405895996094], [4.11564615249634, 20.1148064422607, 20.4881184387207, 30.9729016113281, 31.2075512695313, 32.0928356933594, 35.5593197631836, 35.6979801940918, 35.8153050231934, 35.9539692687988, 36.3379376220703]]",
		"music": load("res://music/Rhythm Hell.wav")
	}
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$MusicPlayer.stream = level_info.get(current_level_name).get("music")
	$MusicPlayer.play()
	
	if in_edit_mode:
		Signals.KeyListenerPress.connect(KeyListenerPress)
		
	else:
		var fk_times = level_info.get(current_level_name).get("fk_times")
		var fk_times_arr = str_to_var(fk_times)
		#print(fk_times_arr[0])
		
		
		var counter: int = 0
		for key in fk_times_arr:
			
			var button_name: String = ""
			match counter:
				0:
					button_name = "button_Q"
				1:
					button_name = "button_W"
				2:
					button_name = "button_E"
				3:
					button_name = "button_R"
			
			for delay in key:
				SpawnFallingKey(button_name, delay)
			
			counter += 1

func KeyListenerPress(button_name: String, array_num: int):
	#print(str(array_num) + " " + str($MusicPlayer.get_playback_position()))
	fk_output_arr[array_num].append($MusicPlayer.get_playback_position() - fk_fall_time)

func SpawnFallingKey(button_name: String, delay: float):
	await get_tree().create_timer(delay).timeout
	Signals.CreateFallingKey.emit(button_name)
	


func _on_music_player_finished() -> void:
	print(fk_output_arr)
