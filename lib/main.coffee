{ resolve } = require 'path'

merge = require 'lodash.merge'

module.exports = (file, keys) ->

  try

    config = require "#{file}"

  catch err then config = {}

  Object.keys(process.env).map (key) ->

    if key.match(/^npm_package_config_/) isnt null

      value = process.env[key]

      key = key.replace(/^npm_package_config_/, '').split "_"

      if key[key.length-1].match(/[0-9]+$/) isnt null

        type = key.shift()

        index = JSON.parse key.pop()

        type = [type].concat(key).join "_"

        config[type] ?= []

        config[type][index] = value

      else if key.length is 1

        config[key.shift()] = value

  try

    if keys.length > 0

      pkg = require resolve "#{process.env.PWD}", "package"

      keys.map (key) ->

        if value = pkg?.config?[key]

          config[key] = merge config[key] or {}, value

  catch err then console.log err.message, err.stack

  console.log JSON.stringify config, null, 2

  config
