extends Control

var score = 0
var add = 1
var addpersec = 1
var combo = 0


func _on_Timer_timeout():
	score += addpersec #After the Timer resets, add the add per second to the score.

func _process(_delta):
	$Score.text = str(score) #Change the text to the current score every frame.

var CPSRequirement = 20 #Clicks required to upgrade Clicks Per Second
var CPCRequirement = 20 #Clicks required to upgrade Clicks Per Click
var CPSRequirement2 = 150 #Clicks required to upgrade Clicks Per Second #2
var CPCRequirement2 = 150 #Clicks required to upgrade Clicks Per Click #2

func _on_CPC1_pressed():
	if score >= CPCRequirement:
		score -= CPCRequirement
		CPCRequirement = round(CPCRequirement * 1.4)
		add = add + 1 #Add CPC
		$VBoxContainer/CPC1.text = str("+1 CPC [", CPCRequirement, "]") #Combine multiple strings to show the required clicks.
		$Label3.text = str("CPC:", add)


func _on_Click_pressed():
	$ClickTimer.start()
	if combo < 25: # Make sure combo doesn't get too high
		combo += 1
	if combo >= 25: # Enable the other sparks when combo is over 25
		$ComboEffect3.emitting = true # More Sparks
	if combo > 15: # Enable the sparks when combo is over 15
		$ComboEffect2.emitting = true # Sparks
	if combo > 10: # Enable the effects when combo is over 10
		score += round(add * (combo / 10))
		$ComboEffect.emitting = true
	if combo <= 10: # No combo
		score += add


func _on_CPS1_pressed():
	if score >= CPSRequirement:
		score -= CPSRequirement
		CPSRequirement = round(CPSRequirement * 1.4)
		addpersec = addpersec + 1 #Add CPS.
		$VBoxContainer/CPS1.text = str("+1 CPS [", CPSRequirement, "]") #Combine multiple strings to show the required clicks.
		$Label2.text = str("CPS:", addpersec)


func _on_ClickTimer_timeout():
	combo = 0
	$ComboEffect.emitting = false # Effects
	$ComboEffect2.emitting = false # Sparks
	$ComboEffect3.emitting = false # More Sparks


func _on_CPS2_pressed():
	if score >= CPSRequirement2:
		score -= CPSRequirement2
		CPSRequirement2 = round(CPSRequirement2 * 1.3)
		addpersec = addpersec + 5 #Add CPS.
		$VBoxContainer/CPS2.text = str("+5 CPS [", CPSRequirement2, "]") #Combine multiple strings to show the required clicks.
		$Label2.text = str("CPS:", addpersec)


func _on_CPC2_pressed():
	if score >= CPCRequirement2:
		score -= CPCRequirement2
		CPCRequirement2 = round(CPCRequirement2 * 1.3)
		add = add + 5 #Add CPC
		$VBoxContainer/CPC2.text = str("+5 CPC [", CPCRequirement2, "]") #Combine multiple strings to show the required clicks.
		$Label3.text = str("CPC:", add)
