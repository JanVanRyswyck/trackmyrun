module.exports = class Calculator
	calculateSpeedFor: (run) -> 
		durationInSeconds = (run.duration.hours * 3600) + (run.duration.minutes * 60) + run.duration.seconds
		speed = (run.distance / durationInSeconds) * 3600
		return parseFloat(speed.toFixed(2))