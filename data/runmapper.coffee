module.exports = class DocumentToRunMapper
	mapFrom: (document) ->
		id: document._id
		revision: document._rev
		type: document.type
		date: document.date
		distance: document.distance
		duration: document.duration
		speed: document.speed
		averageHeartRate: document.averageHeartRate
		shoes: document.shoes