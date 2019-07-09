
'use strict'

const now = new Date()

setInterval(function() {
  console.log(`timestamp: ${now.toLocaleString()}`)
}, 60000)
