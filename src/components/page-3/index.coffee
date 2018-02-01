class PageC
	constructor : ->
		@initLayout()

	initLayout : ->
		$('.page-3-content').css(
			'left':'50%'
			'top':'50%'
			'margin-left':'-'+$('.page-3-content').width()/2+'px'
			'margin-top':(10-$('.page-3-content').height())/2+'px'
		)

module.exports = PageC