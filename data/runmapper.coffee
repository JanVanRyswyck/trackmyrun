module.exports = class RunMapper
	mapFrom: (document) ->
		date: document.date
		distance: document.distance
		duration: document.duration
		id: document._id
		revision: document._rev
		speed: document.speed
		averageHeartRate: document.averageHeartRate
		shoes: document.shoes