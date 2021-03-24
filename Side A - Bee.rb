eval_file MULTI_KNOBS_RB_PATH()

midi_name = PAD_MIDI_NAME()

#initKnobs

minSleepLen = 0.4

define :playNotes do | knobSet |
  use_synth_defaults attack: (getKnob knobSet, 5) / 10.0,
    sustain: (getKnob knobSet, 6) / 10.0,
    release: (getKnob knobSet, 7) / 10.0
  
  play (hz_to_midi (rrand 40, 80)),
    amp: (getKnob knobSet, 1) / 127.0
  
  play (hz_to_midi (rrand 120, 150)),
    amp: (getKnob knobSet, 2) / 127.0
  
  play (hz_to_midi (rrand 240, 300)),
    amp: (getKnob knobSet, 3) / 127.0
  
  play (hz_to_midi (rrand 480, 600)),
    amp: (getKnob knobSet, 4) / 127.0
  
  s = (getKnob knobSet, 8) / 10.0
  sleep (s < minSleepLen ? minSleepLen : s)
end

live_loop :main do
  #use_synth :fm
  use_synth_defaults divisor: (rrand 0.01, 2.0)
  playNotes 1
end

live_loop :square do
  use_synth :square
  playNotes 2
end

live_loop :saw do
  use_synth :saw
  playNotes 3
end

live_loop :tri do
  use_synth :tri
  playNotes 4
end

define :playNoise do | knobSet |
  use_synth_defaults attack: (getKnob knobSet, 5) / 10.0,
    sustain: (getKnob knobSet, 6) / 10.0,
    release: (getKnob knobSet, 7) / 10.0
  
  play cutoff: (rrand 55, 65),
    amp: (getKnob knobSet, 1) / 127.0
  
  play cutoff: (rrand 80, 90),
    amp: (getKnob knobSet, 2) / 127.0
  
  play cutoff: (rrand 105, 115),
    amp: (getKnob knobSet, 3) / 127.0
  
  play cutoff: (rrand 120, 130),
    amp: (getKnob knobSet, 4) / 127.0
  
  s = (getKnob knobSet, 8) / 10.0
  sleep s < minSleepLen ? minSleepLen : s
end

live_loop :noise do
  use_synth :noise
  playNoise 5
end

live_loop :bnoise do
  use_synth :bnoise
  playNoise 6
end

live_loop :gnoise do
  use_synth :gnoise
  playNoise 7
end

live_loop :pnoise do
  use_synth :pnoise
  playNoise 8
end

len = 40.0

load_synthdefs SCL_ORK_SYNTHS_DIR() + 'guitar'

live_loop :midi_guitar2 do
  use_real_time
  note, velocity = sync midi_name + "note_on"
  note = (scale 36, :minor)[note-36]
  #use_synth 'distortedGuitar'
  #play freq: (midi_to_hz note), rel: len, muteSus: len, coef: 0.2, amp: velocity / 1000.0
  use_synth :pluck
  
  with_fx :gverb do
    play note, coef: 0.0, release: len, amp: velocity / 500.0, noise_amp: 0.5
  end
end