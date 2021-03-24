eval_file KNOBS_RB_PATH()

midi_name = PAD_MIDI_NAME()
#initKnobs

minLoopLength = 0.2

live_loop :midiButtons do
  use_real_time
  note, velocity = sync midi_name + "note_on"
  
  in_thread do
    amp = velocity / 10.0
    loop do
      sample (sample_names :drum)[note + get(:offset)], amp: amp
      t = (getKnob 1) / 10.0
      sleep t > minLoopLength ? t : minLoopLength
    end
  end
end

live_loop :midiButtons2 do
  use_real_time
  note, velocity = sync midi_name + "program_change"
  
  set :offset, note
end