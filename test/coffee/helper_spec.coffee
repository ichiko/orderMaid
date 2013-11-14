# helper_spec.coffee

describe 'MenuHelper', ->
	it 'be defined', ->
		expect(MenuHelper).toBeDefined()
	describe 'without initialize', ->
		it 'return empty string', ->
			helper = new MenuHelper()
			result = helper.getDishName(1)
			expect(result).toEqual('')

	describe 'with initialized', ->
		helper = null

		beforeEach ->
			menu = new DishList()
			menu.add( { id:1, name: '炒飯' })
			menu.add( { id:2, name: '天丼' })
			menu.add( { id:3, name: 'きつねうどん' })
			console.log menu

			helper = new MenuHelper()
			helper.init(menu)

		it 'member is not undefined', ->
			expect(helper.dishList).toBeDefined()

		it 'member is contains 3 items', ->
			expect(helper.dishList.length).toEqual(3)

		it 'member\'s first item is {id:1, name:\'炒飯\' } (id)', ->
			model = helper.dishList.models[0]
			expect(model.get('id')).toEqual(1)

		it 'member\'s first item is {id:1, name:\'炒飯\' } (name)', ->
			model = helper.dishList.models[0]
			expect(model.get('name')).toEqual('炒飯')

		it 'if specified id doesnt exist, return empty string', ->
			result = helper.getDishName(100)
			expect(result).toEqual('')

		it 'if specified id is exist, return its name', ->
			result = helper.getDishName(2)
			expect(result).toEqual('天丼')

	