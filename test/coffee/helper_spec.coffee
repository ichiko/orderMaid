# helper_spec.coffee

describe 'MenuHelper', ->
	it 'be defined', ->
		expect(MenuHelper).toBeDefined()
	describe 'without initialize', ->
		it 'return empty string', ->
			helper = new MenuHelper()
			result = helper.getDishName(1)
			expect(result).toEqual('')

#	context 'with initialized'
#		it 'if specified id doesnt exist, return empty string'
#
#		it 'if specified id is exist, return its name'

	