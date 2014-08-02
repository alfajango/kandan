class Kandan.Plugins.MeAnnounce

  @options:
    regex: /^&#x2F;me( |$)/

  @init: ()->
    Kandan.Modifiers.register @options.regex, (message, activity) =>
      actor = activity.user.username || activity.user.email
      if message.length == 8 || message.length == 9
        message = "<i>#{actor} whistles in the wind.</i>"
      else
        message = message.replace @options.regex, "#{actor} "
        message = "<i>#{message}</i>"
      return message
