-- 3. enviar custom osc desde tidal a hydra


{-# LANGUAGE TypeSynonymInstances, FlexibleInstances, OverloadedStrings #-}

import Sound.Tidal.Stream
import Sound.Tidal.Pattern
import Sound.Tidal.ParseBP
import Sound.Tidal.Stream
import Sound.Tidal.Context

customHydra :: OSCTarget
customHydra = (OSCTarget {oName = "customHydra",
                          oAddress = "127.0.0.1",
                          oPort = 5000,
                          oPath = "/hue",
                          oShape = Just [
                             ("hue", Just $ VF 0)
                          ],
                          oLatency = 0.1,
                          oPreamble = [],
                          oTimestamp = MessageStamp
                        })

hue = pF "hue"
