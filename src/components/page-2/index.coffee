class PageB
	constructor : ->
		@initLayout()

	initLayout : ->
		$('.page-2-content').css(
			'left':'50%'
			'top':'50%'
			'margin-left':'-'+$('.page-2-content').width()/2+'px'
			'margin-top':(60-$('.page-2-content').height())/2+'px'
		)

module.exports = PageB