# orderMaid.coffee

class OrderMaid
	constructor: ->
		console.log "window.onload"
		stageInfo = new StageInfo()
		stageInfo.set('status', StageInfo.STATE_LOADING)
		new StatusView({ model: stageInfo })
		new GameScreenView({ model: stageInfo })

window.OrderMaid = OrderMaid