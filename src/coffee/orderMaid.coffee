# orderMaid.coffee

window.onload = ->
	console.log "window.onload"
	stageInfo = new StageInfo()
	stageInfo.set('status', StageInfo.STATE_LOADING)
	new StatusView({model: stageInfo})

