# view.coffee
# require backbone.js
# require model.coffee
# require helper.coffee

class GameScreenView extends Backbone.View
	# model: StageInfo
	el: '#playView'

	initialize: ->
		@game = new OrderMaid(@model)
		@game.start()

class StatusView extends Backbone.View
	# model: StageInfo
	el: '#statusbar'

	initialize: ->
		@model.on("sync", @render, @)
		@model.on("change:status", @onchangeStateOrScore)
		@model.on("change:totalScore", @onchangeStateOrScore)
		@render()

	template: _.template($('#status_template').html())

	onchangeStateOrScore: (model, status) =>
		log = "onChange status (" + model.previous('status') + " > " + model.get('status') + "), score (" + model.previous('score') + " > " + model.get('score') + ")"
		console.log log
		@render

	render: ->
		ctx = @model.toJSON()
		html = @template(ctx)
		$(@el).html(html)
		@