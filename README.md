scumm_sync
==
<p align="center">
    <img style="margin: 5px" src="https://user-images.githubusercontent.com/2810775/107346092-29cfbf80-6a79-11eb-8a77-34139b6720a9.png" width="320"/>
    <img style="margin: 5px" src="https://user-images.githubusercontent.com/2810775/107347555-cb0b4580-6a7a-11eb-8a24-3f16aa139f1f.png" width="320">
</p>



### Summary
This is a repo with which to build a dialogue website for LucasArts games, with Monkey Island 2 and Full Throttle (original) implemented so far. It works with dialogue ripped with [scummtr](https://forums.scummvm.org/viewtopic.php?t=4448), with the output placed in `/public/scumm_text/<game>_<locale>.txt`, and audio ripped with [ScummSpeaks](http://www.jestarjokin.net/sw/doc/scummspeaks_manual.html), placed in `/public/scumm_text/<game>_<locale>`.

Batteries not included, so I don't suggest trying to do anything with it from scratch, especially as it uses some rather hard-to find localizations (eg. the Russian localization of Full Throttle and the FM Towns localization of MI2), with a bit of massaging to clean up the scummtr output (which is documented where applicable). Just play with [the demo](https://scumm-sync.surge.sh)! (NOTE: It is currently only showing the FT script, in a huge html file with no pagination.)

If there's audio, you can click it and play it; if not, it falls back to Responsive Voice for text-to-speech.

### Usage
It's no use, really, just check out the [demo](https://scumm-sync.surge.sh)!

For documentation purposes: run `bundle install` to set up. There are two entries, one that'll simply run with `rackup` and serve it from Sinatra (with the Guardfile set up already, also), or `ruby bake.rb`, which will run rack-test instance to internally scrape the site and dump html into `/public` for easily uploading somewhere without the server.

There are two separate files that show the syncing offsets, `/lib/ft_offsets.rb` and `/lib/mi2_offset.rb.` You can take a look at them if curious about what was left out (for example, the books in the library in MI2 were inconsistent across localizations, so they were cut.)

### Roadmap

I've considered adding synchronization offsets for other games with Japanese localizations, such as Indiana Jones and the Fate of Atlantis and the first Monkey Island. In terms of audio, I did Full Throttle mainly because of the existence of a Russian script with high-quality dub, for language-learning purposes, so I likely won't bother with DoTT or Sam and Max.

### Disclaimer

The demo is for educational purposes only, with incomplete audio and script resources provided under fair use. Please don't try to scrape the IPFS gateway for them!