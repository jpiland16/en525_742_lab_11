import mido # type: ignore
from dataclasses import dataclass
from typing import List
import numpy as np
import scipy.io.wavfile as wavfile # type: ignore

SAMPLE_RATE = 44100

SCALE_FACTOR = 0.64

REST = -1

@dataclass
class Note:
    duration_ms: float
    number: int # -1 signifies rest

@dataclass
class Rest(Note):
    duration_ms: float
    number: int = -1

tracks: List[List[Note]] = [[], []]

# Load the MIDI file
mid = mido.MidiFile('smb-overworld.mid')

def note_number_to_frequency(n):
    return 440 * 2 ** ((n - 69) / 12)

# Iterate through all messages in all tracks
for t, track_audio in enumerate(mid.tracks[1:3]):
    # print(f'Track: {track.name}')
    i = 0
    in_note = False
    for msg in track_audio:
        
        if msg.is_cc() or msg.is_meta or msg.type == "program_change":
            continue
        
        if msg.type == "note_on":
            if i != 0:
                tracks[t].append(Rest(msg.time * SCALE_FACTOR))
                if i > 73:
                    break
            tracks[t].append(Note(0, msg.note))
        
        if msg.type == "note_off":
            tracks[t][-1].duration_ms = msg.time * SCALE_FACTOR
            i += 1


tracks[0][11].duration_ms = tracks[1][11].duration_ms
tracks[0].insert(12, Note(tracks[1][12].duration_ms, tracks[1][12].number))
tracks[0].insert(13, Rest(tracks[1][13].duration_ms))
tracks[0] = tracks[0][:-2]
tracks[0][-1].duration_ms = 50
tracks[1][-1].duration_ms = 50

def get_best_phase_inc(frequency: float):
    return int(round(frequency / 125e6 * (1 << 27)))

def print_tracks(tracks: List[List[Note]]):
    with open("output.sh", "w") as file:
        for i, (e1, e2) in enumerate(zip(tracks[0], tracks[1])):
            if (e1.number == REST) != (e2.number == REST):
                raise ValueError("Note/rest mismatch")
            if (e1.duration_ms) != (e2.duration_ms):
                raise ValueError("duration mismatch")
            
            if e1.number == REST:
                print(f" <rest {e1.duration_ms:6.1f} ms>")
                print(f"devmem 0x43c00008 w 0x00000001", file=file)
                print(f"sleep {e1.duration_ms/1000 - 0.024:.3f}", file=file)
                # print(f" <rest {e1.duration_ms:6.1f} ms> <rest {e2.duration_ms:6.1f} ms>")
            else:
                print(f"{i // 2:3d} :: {e1.number:3d} | {e2.number:3d} | {e1.duration_ms:6.1f}ms", end="")
                f1 = note_number_to_frequency(e1.number)
                f2 = note_number_to_frequency(e2.number)
                fakeadc_pinc = get_best_phase_inc((f1 + f2) / 2)
                tuner_pinc = get_best_phase_inc(abs(f1 - f2) / 2)
                print(f"devmem 0x43c00000 w 0x{fakeadc_pinc:08x}", file=file)
                print(f"devmem 0x43c00004 w 0x{tuner_pinc:08x}", file=file)
                print(f"devmem 0x43c00008 w 0x00000000", file=file)
                print(f"sleep {e1.duration_ms/1000 - 0.024:.3f}", file=file)

    print()

print_tracks(tracks)


def sine_wave_of_length(time_seconds: float, frequency: float):

    zero_crossings_per_second = 2 * frequency
    samples_before_zero_cross = SAMPLE_RATE / zero_crossings_per_second

    sample_time = 1 / SAMPLE_RATE
    number_of_samples = round(SAMPLE_RATE * time_seconds)

    # CLIP WAVE NEAR ZERO CROSSINGS
    zero_crossing_stop = round(number_of_samples - (
        number_of_samples % samples_before_zero_cross
    ))

    silence_count = number_of_samples - zero_crossing_stop

    sequence_times = np.arange(zero_crossing_stop) * sample_time
    omega = 2 * np.pi * frequency

    wave = (np.sin(omega * sequence_times) * 32767).astype(np.int16)

    use_fade = True

    if use_fade:
        fade_len = 100

        for i in range(fade_len):
            wave[i] *= i / fade_len

        for i in range(fade_len):
            wave[- i - 1] *= i / fade_len

    return np.concatenate((wave, np.zeros(silence_count, dtype=np.int16)))

def empty_space_of_length(time_seconds: float):

    return np.zeros(int(SAMPLE_RATE * time_seconds), dtype=np.int16)

def create_track(track: List[Note]):

    output_track = np.array([], dtype=np.int16)

    for note in track:
        if note.number == REST:
            new_audio = empty_space_of_length(note.duration_ms / 1e3)
        else:
            new_audio = sine_wave_of_length(note.duration_ms / 1e3, note_number_to_frequency(note.number))

        output_track = np.concatenate((output_track, new_audio))

    return output_track

track1_audio = create_track(tracks[0])
track2_audio = create_track(tracks[1])
combined_tracks = (track1_audio * 0.45 + track2_audio * 0.45).astype(np.int16)

track_audio = combined_tracks[:, np.newaxis].repeat(2, axis=1)
print(track_audio.dtype)
print(track_audio.shape)
print(len(track_audio) / SAMPLE_RATE)
wavfile.write('output.wav', SAMPLE_RATE, track_audio)



