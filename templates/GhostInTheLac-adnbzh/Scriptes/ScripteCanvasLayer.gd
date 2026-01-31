extends CanvasLayer
func _process(delta):
	var vie = ($"/root/ScriptStats".Sante)
	if vie == 3:
		$AnimatedSprite2D.play("3")
	elif vie == 2:
			$AnimatedSprite2D.play("2")
	else:
			$AnimatedSprite2D.play("1")
	$AnimatedSprite2.play(str($"/root/ScriptStats".Score))
	$AnimatedSprite3.play("0")
	$AnimatedSprite3.play(str($"/root/ScriptStats".Palier))
	if $"/root/ScriptStats".Score == 10:
		$"/root/ScriptStats".Score = 0
		$"/root/ScriptStats".Palier+= 1
		$"/root/ScriptStats".Vitesse+= 100
