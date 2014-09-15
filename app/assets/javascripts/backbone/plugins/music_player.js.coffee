class Kandan.Plugins.MusicPlayer

  @pluginNamespace: "Kandan.Plugins.MusicPlayer"
  @pluginId: ""
  @widgetTitle: "Player"
  @playRegex: /^&#x2F;play .+/
  @stopRegex: /^&#x2F;stop/
  @resumeRegex: /^&#x2F;resume/
  @localSongData: false
  @sounds: {
    channel: 'ding.wav'
    attention: 'threetone-alert.wav'
  }

  @playTemplate:   _.template('<a class="audio-play" target="_blank" href="<%- soundUrl %>"><i>:sound: play <%- url %></i></a>')
  @stopTemplate:   _.template('<i>:mute: stop the music.</i>')
  @resumeTemplate: _.template('<i>:sound: resume the music.</i>')
  @songTemplate:   _.template('<li><%= song.split("/").pop() %></li>')

  @attachClicks: =>
    _this = this
    $(document).delegate('.audio-play', 'click', (e) ->
      e.preventDefault()
      soundUrl = $(this).attr('href')
      channelId = _this.currentChannel()
      _this.playUrl(channelId, soundUrl)
    )

  @setError: (errorMessage)->
    console.log "music player error", errorMessage


  @createSongList: (songs)->
    $songs = $('<ul class="songs"></ul>')
    if songs.length == 0
      $songs = "No songs! Maybe add some?"
    else
      $songs.append(@songTemplate({song: song})) for song in songs
    return $songs


  @render: ($widgetEl)->
    $widgetElementClass = $widgetEl.attr('class')

    if @localSongData
      $songs = @createSongList(@localSongData)
    else
      @getSongs({
        success: (songs)=>
          $songs = @createSongList(songs)

        failure: ()->
          @setError("Could not load songs")
      })
    $widgetEl.html($songs)


  # TODO: Add support for sounds
  @init: (pluginId)->
    @pluginId = pluginId
    Kandan.Data.Channels.registerCallback("change", $.proxy(@onChannelChange, this))
    @registerPlayModifier()
    @registerStopModifier()
    @registerResumeModifier()
    # Disabled for now
    #@registerWidget()


  @registerWidget: ()->
    Kandan.Widgets.register @pluginNamespace


  @registerPlayModifier: ()->
    Kandan.Modifiers.register @playRegex, (message, activity, options) =>
      url = $.trim(message.substr(message.indexOf(" ") + 1));
      rawInput  = Kandan.Helpers.Utils.unescape(url)
      soundUrl  = null
      soundUrl  = @localSounds(rawInput)
      soundUrl ?= rawInput

      if !options.silence_music and Kandan.Data.Channels.activeChannelId()?
        @playUrl(activity.channel_id, soundUrl)
      else
        console.log "Not playing stale song"

      message = @playTemplate({url: url, soundUrl: soundUrl})
      return message #Kandan.Helpers.Activities.buildFromBaseTemplate message

  @registerStopModifier: ()->
    Kandan.Modifiers.register @stopRegex, (message, activity) =>
      url = $.trim(message.substr(message.indexOf(" ") + 1));
      if true and Kandan.Data.Channels.activeChannelId()?
        @stopSound(activity.channel_id)

      message = @stopTemplate()
      return message

  @registerResumeModifier: ()->
    Kandan.Modifiers.register @resumeRegex, (message, activity) =>
      if true and Kandan.Data.Channels.activeChannelId()?
        @play(activity.channel_id)

      message = @resumeTemplate()
      return message


  # TODO display error about song not being added by creating an activity locally
  @storeSong: (url)->
    @getSongs({
      success: (data)=>
        data.push url
        Kandan.Store.set @pluginId, {
          success: (data)->
            @localSongData = data
            Kandan.Widgets.renderWidget @pluginNamespace
        }
    })


  @getSongs: (callbacks)->
    Kandan.Store.get @pluginId, callbacks

  @localFileUrl: (fileName) ->
    "//#{ window.location.hostname }:#{ window.location.port }/sounds/#{ fileName }"

  @localSounds: (name) ->
    sounds = {
      'threetone-alert'  : @localFileUrl('threetone-alert.wav')
      'ding'             : @localFileUrl('ding.wav')
      'secret'           : @localFileUrl('secret.mp3')
      'secret'           : @localFileUrl('secret.mp3')
      'trombone'         : @localFileUrl('trombone.mp3')
      'crickets'         : @localFileUrl('crickets.mp3')
      'rimshot'          : @localFileUrl('rimshot.mp3')
      'vuvuzela'         : @localFileUrl('vuvuzela.mp3')
      'tmyk'             : @localFileUrl('tmyk.mp3')
      'live'             : @localFileUrl('live.mp3')
      'drama'            : @localFileUrl('drama.mp3')
      'yeah'             : @localFileUrl('yeah.mp3')
      'greatjob'         : @localFileUrl('greatjob.mp3')
      'pushit'           : @localFileUrl('pushit.mp3')
      'nyan'             : @localFileUrl('nyan.mp3')
      'tada'             : @localFileUrl('tada.mp3')
      'ohmy'             : @localFileUrl('ohmy.mp3')
      'bueller'          : @localFileUrl('bueller.mp3')
      'ohyeah'           : @localFileUrl('ohyeah.mp3')
      '56k'              : @localFileUrl('56k.mp3')
      'dangerzone'       : @localFileUrl('dangerzone.mp3')
      'horn'             : @localFileUrl('horn.mp3')
      'horror'           : @localFileUrl('horror.mp3')
      'loggins'          : @localFileUrl('loggins.mp3')
      'yodel'            : @localFileUrl('yodel.mp3')
      'sax'              : @localFileUrl('sax.mp3')
      'noooo'            : @localFileUrl('noooo.mp3')
      'heygirl'          : @localFileUrl('heygirl.mp3')
      'inconceivable'    : @localFileUrl('inconceivable.mp3')
      'deeper'           : @localFileUrl('deeper.mp3')
      'whoomp'           : @localFileUrl('whoomp.mp3')
      'clowntown'        : @localFileUrl('clowntown.mp3')
      'what'             : @localFileUrl('what.mp3')
      'bezos'            : @localFileUrl('bezos.mp3')
      'trololo'          : @localFileUrl('trololo.mp3')
      'makeitso'         : @localFileUrl('makeitso.mp3')
      'sexyback'         : @localFileUrl('sexyback.mp3')
      'bell'             : @localFileUrl('bell.mp3')
      'danielsan'        : @localFileUrl('danielsan.mp3')
      'greyjoy'          : @localFileUrl('greyjoy.mp3')
      'story'            : @localFileUrl('story.mp3')
      'dadgummit'        : @localFileUrl('dadgummit.mp3')
      'rollout'          : @localFileUrl('rollout.mp3')
      'cottoneyejoe'     : @localFileUrl('cottoneyejoe.mp3')
      'rumble'           : @localFileUrl('rumble.mp3')
      'guarantee'        : @localFileUrl('guarantee.mp3')
      'lana'             : @localFileUrl('archerdangerzone.mp3')
      'ants'             : @localFileUrl('archerants.mp3')
      'logginszone'      : @localFileUrl('archerlogginszone.mp3')
      'phrasing'         : @localFileUrl('archerphrasing.mp3')
      'stayinshape'      : @localFileUrl('stayinshape.mp3')
      'thatswhatshesaid' : @localFileUrl('thatswhatshesaid.mp3')
      'thatswhathesaid'  : @localFileUrl('thatswhathesaid.mp3')
      'heorshesaid'      : @localFileUrl('heorshesaid.mp3')
      'pamsaid'          : @localFileUrl('pamsaid.mp3')
      'boomroasted'      : @localFileUrl('boomroasted.mp3')
      'woowoo'           : @localFileUrl('woowoo.mp3')
    }

    sounds[name]

  @audioChannels: ->
    Kandan.Helpers.Audio.audioChannels()

  @audioChannel: (id) ->
    Kandan.Helpers.Audio.audioChannel(id)

  @mute: (channelId) ->
    @setVolume(channelId, 0)

  @unmute: (channelId) ->
    @setVolume(channelId, 1)

  @toggle: (channelId) ->
    if @audioChannel(channelId).volume == 0
      @unmute(channelId)
    else
      @mute(channelId)

  @setVolume: (channelId, volume) ->
    @audioChannel(channelId).volume = volume

  @setAudioUrl: (channelId, url) ->
    @audioChannel(channelId).setAttribute('src', url)

  @playUrl: (channelId, url) ->
    @setAudioUrl(channelId, url)
    @play(channelId)

  @play: (channelId) ->
    @audioChannel(channelId).play()

  @stopSound: (channelId) ->
    @audioChannel(channelId).pause()

  @currentChannel: () ->
    Kandan.Data.Channels.activeChannelId()

  @onChannelChange: () ->
    channelId = @currentChannel()
    for channel in @audioChannels()
      raw = $(channel).attr('class').split("_")[1]
      id = parseInt(raw)
      continue if isNaN(id)
      @mute(id)

    if @audioChannel(channelId)?
      @unmute(channelId)

  @playAudioNotice: (type)->
    console.log "told to play for: #{type}"
    sound  = @sounds[type] || 'ding.wav'
    url    = @localFileUrl(sound)
    player = $('.audio_private')[0]
    player.setAttribute('src', url)
    player.play()

# Kandan.Plugins.register "Kandan.Plugins.MusicPlayer"
