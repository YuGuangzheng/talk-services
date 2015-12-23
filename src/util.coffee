path = require 'path'
Promise = require 'bluebird'
request = require 'request'
Err = require 'err1st'
loader = require './loader'

lockMap = {}

module.exports = util =

  userAgent: 'Talk Api Service V1'

  ###*
   * Handle i18n objects
   * @param  {Object} locales
   * @return {Object} locales
  ###
  i18n: (locales) -> locales

  ###*
   * Get url of static resource
   * @param  {String} str - Relative path of local resource
   * @return {String} url - Url of static resource
  ###
  static: (str) -> loader.config.cdnPrefix + path.join('/', str)

  ###*
   * Get url of apis from services, group by service name
   * @param  {String} category - Service category
   * @param  {String} apiName - Api name
   * @return {String} url - The complete api url
  ###
  getApiUrl: (category, apiName) ->
    loader.config.apiHost + "/services/api/#{category}/#{apiName}"

  getAccountUser: (accountToken, callback) ->
    options =
      url: loader.config.talkAccountApiUrl + '/v1/user/get'
      json: true
      qs: accountToken: accountToken
    request options, (err, res, user) ->
      return callback(new Err('TOKEN_EXPIRED')) unless user?._id
      callback err, user

  lock: (key, timeout = 10000) ->
    lockMap[key] = 1
    setTimeout ->
      delete lockMap[key]
    , timeout

  isLocked: (key) -> lockMap[key]

Object.defineProperty util, 'config', get: -> loader.config

Promise.promisifyAll util